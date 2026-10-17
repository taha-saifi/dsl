import { Types, type HydratedDocument } from "mongoose";

import { ApiError } from "../middleware/error.middleware";
import ExerciseSession, { type IExerciseSession, type Verdict } from "../models/ExerciseSession";
import { checkAnswer, type CheckResult } from "./answerChecking.service";
import { ensureEnrolled } from "./enrollment.service";
import { buildPlayQuestion, type PlayQuestion } from "./playPayload.service";
import { resolveExerciseQuestions } from "./questionContent.service";
import { getPlayableExercise, type PlayableExercise } from "./studentCatalog.service";

/*
 * Exercise sessions (docs/mobile/features/feat-answer-checking-and-sessions.md):
 * - Starting abandons the student's active session for the exercise (Q14).
 * - Unlimited retries; only a question's first attempt counts (Q12), and
 *   "almost" counts as correct (Q11).
 * - Score = points of first-attempt-correct questions; accuracy = their share
 *   of the session's questions, 0–100. Unanswered questions count as wrong.
 */

type SessionDocument = HydratedDocument<IExerciseSession>;

const isDuplicateKeyError = (error: unknown): boolean =>
  typeof error === "object" && error !== null && "code" in error && error.code === 11000;

const isCorrect = (verdict: Verdict): boolean => verdict !== "wrong";

/** What clients see of a session: no stored answers. */
export const sessionSummary = (session: SessionDocument): Record<string, unknown> => ({
  _id: session._id,
  exerciseId: session.exerciseId,
  unitId: session.unitId,
  courseId: session.courseId,
  status: session.status,
  startedAt: session.startedAt,
  questionCount: session.questions.length,
  ...(session.completedAt ? { completedAt: session.completedAt } : {}),
  ...(session.score !== undefined ? { score: session.score, maxScore: session.maxScore, accuracy: session.accuracy } : {}),
});

export const startSession = async (
  studentId: Types.ObjectId,
  exerciseId: Types.ObjectId,
): Promise<{ session: SessionDocument; exercise: PlayableExercise; questions: PlayQuestion[] }> => {
  const exercise = await getPlayableExercise(exerciseId);
  await ensureEnrolled(studentId, exercise.courseId);

  const resolved = await resolveExerciseQuestions(exerciseId);
  const built = resolved.flatMap((entry) => {
    const play = buildPlayQuestion(entry);
    return play ? [{ entry, play }] : [];
  });
  if (built.length === 0) {
    throw new ApiError(409, "This exercise has no playable questions right now.", "EXERCISE_EMPTY");
  }

  const create = async (): Promise<SessionDocument> => {
    await ExerciseSession.updateMany({ studentId, exerciseId, status: "active" }, { $set: { status: "abandoned" } });
    return ExerciseSession.create({
      studentId,
      exerciseId,
      unitId: exercise.unitId,
      courseId: exercise.courseId,
      questions: built.map(({ entry }) => ({
        questionId: entry.question._id,
        type: entry.question.type,
        points: entry.question.points,
      })),
    });
  };

  let session: SessionDocument;
  try {
    session = await create();
  } catch (error: unknown) {
    // Two starts at once: the partial unique index let one through. Retry once.
    if (!isDuplicateKeyError(error)) throw error;
    session = await create();
  }
  return { session, exercise: { ...exercise }, questions: built.map(({ play }) => play) };
};

/** The student's own session, else 404 (another student's session doesn't exist for them). */
const ownSession = async (studentId: Types.ObjectId, sessionId: Types.ObjectId): Promise<SessionDocument> => {
  const session = await ExerciseSession.findOne({ _id: sessionId, studentId });
  if (!session) {
    throw new ApiError(404, "Session not found.", "SESSION_NOT_FOUND");
  }
  return session;
};

const ensureActive = (session: SessionDocument): void => {
  if (session.status !== "active") {
    throw new ApiError(409, `This session is ${session.status}.`, "SESSION_NOT_ACTIVE");
  }
};

export const answerQuestion = async (
  studentId: Types.ObjectId,
  sessionId: Types.ObjectId,
  questionId: Types.ObjectId,
  answer: unknown,
  timeTakenMs: number | undefined,
): Promise<CheckResult & { isCorrect: boolean; attemptNumber: number; firstAttempt: boolean }> => {
  const session = await ownSession(studentId, sessionId);
  ensureActive(session);
  if (!session.questions.some((q) => q.questionId.equals(questionId))) {
    throw new ApiError(409, "That question isn't part of this session.", "QUESTION_NOT_IN_SESSION");
  }

  const resolved = (await resolveExerciseQuestions(session.exerciseId)).find((r) => r.question._id.equals(questionId));
  if (!resolved) {
    throw new ApiError(409, "This question can no longer be checked.", "QUESTION_UNAVAILABLE");
  }
  const result = checkAnswer(resolved, answer);

  const previous = session.attempts.filter((a) => a.questionId.equals(questionId)).length;
  session.attempts.push({
    questionId,
    answer,
    verdict: result.verdict,
    attemptedAt: new Date(),
    ...(timeTakenMs !== undefined ? { timeTakenMs } : {}),
  });
  await session.save();

  return {
    ...result,
    isCorrect: isCorrect(result.verdict),
    attemptNumber: previous + 1,
    firstAttempt: previous === 0,
  };
};

export const completeSession = async (
  studentId: Types.ObjectId,
  sessionId: Types.ObjectId,
): Promise<Record<string, unknown>> => {
  const session = await ownSession(studentId, sessionId);
  ensureActive(session);

  let score = 0;
  let correctCount = 0;
  for (const question of session.questions) {
    const first = session.attempts.find((a) => a.questionId.equals(question.questionId));
    if (first && isCorrect(first.verdict)) {
      score += question.points;
      correctCount += 1;
    }
  }
  const maxScore = session.questions.reduce((sum, q) => sum + q.points, 0);
  const completedAt = new Date();
  session.status = "completed";
  session.completedAt = completedAt;
  session.score = score;
  session.maxScore = maxScore;
  session.accuracy = Math.round((correctCount / session.questions.length) * 100);
  await session.save();

  return {
    ...sessionSummary(session),
    correctCount,
    durationMs: completedAt.getTime() - session.startedAt.getTime(),
  };
};

export const abandonSession = async (
  studentId: Types.ObjectId,
  sessionId: Types.ObjectId,
): Promise<Record<string, unknown>> => {
  const session = await ownSession(studentId, sessionId);
  ensureActive(session);
  session.status = "abandoned";
  await session.save();
  return sessionSummary(session);
};
