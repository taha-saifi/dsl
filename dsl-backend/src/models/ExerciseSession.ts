import { model, Schema, Types } from "mongoose";

export const SESSION_STATUSES = ["active", "completed", "abandoned"] as const;
export type SessionStatus = (typeof SESSION_STATUSES)[number];
export const VERDICTS = ["correct", "almost", "wrong"] as const;
export type Verdict = (typeof VERDICTS)[number];

/** A question as it was when the session started. */
export interface ISessionQuestion {
  questionId: Types.ObjectId;
  type: string;
  points: number;
}

export interface IAttempt {
  questionId: Types.ObjectId;
  /** The submitted answer as sent (`{optionId}`, `{text}`, `{blockIds}`, `{pairs}`). */
  answer: unknown;
  verdict: Verdict;
  attemptedAt: Date;
  timeTakenMs?: number;
}

/**
 * One play of one exercise by one student (docs/data-model/exercise-session.md).
 * Attempts are embedded: bounded (questions × retries) and always read with
 * the session. `unitId`/`courseId` are denormalized for progress queries.
 */
export interface IExerciseSession {
  studentId: Types.ObjectId;
  exerciseId: Types.ObjectId;
  unitId: Types.ObjectId;
  courseId: Types.ObjectId;
  status: SessionStatus;
  startedAt: Date;
  completedAt?: Date;
  questions: ISessionQuestion[];
  attempts: IAttempt[];
  score?: number;
  maxScore?: number;
  accuracy?: number;
}

const sessionQuestionSchema = new Schema<ISessionQuestion>(
  {
    questionId: { type: Schema.Types.ObjectId, ref: "Question", required: true },
    type: { type: String, required: true },
    points: { type: Number, required: true },
  },
  { _id: false },
);

const attemptSchema = new Schema<IAttempt>(
  {
    questionId: { type: Schema.Types.ObjectId, required: true },
    answer: { type: Schema.Types.Mixed, required: true },
    verdict: { type: String, enum: VERDICTS, required: true },
    attemptedAt: { type: Date, required: true },
    timeTakenMs: { type: Number },
  },
  { _id: false },
);

const exerciseSessionSchema = new Schema<IExerciseSession>({
  studentId: { type: Schema.Types.ObjectId, ref: "User", required: true },
  exerciseId: { type: Schema.Types.ObjectId, ref: "Exercise", required: true },
  unitId: { type: Schema.Types.ObjectId, ref: "Unit", required: true },
  courseId: { type: Schema.Types.ObjectId, ref: "Course", required: true },
  status: { type: String, enum: SESSION_STATUSES, required: true, default: "active" },
  startedAt: { type: Date, required: true, default: () => new Date() },
  completedAt: { type: Date },
  questions: { type: [sessionQuestionSchema], required: true },
  attempts: { type: [attemptSchema], default: [] },
  score: { type: Number },
  maxScore: { type: Number },
  accuracy: { type: Number },
});

exerciseSessionSchema.index({ studentId: 1, exerciseId: 1, status: 1 });
exerciseSessionSchema.index({ studentId: 1, courseId: 1, completedAt: 1 });
// At most one active session per student and exercise (decision Q14).
exerciseSessionSchema.index(
  { studentId: 1, exerciseId: 1 },
  { unique: true, partialFilterExpression: { status: "active" }, name: "one_active_session" },
);

const ExerciseSession = model<IExerciseSession>("ExerciseSession", exerciseSessionSchema);

export default ExerciseSession;
