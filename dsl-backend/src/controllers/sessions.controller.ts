import type { Request, Response } from "express";
import type { Types } from "mongoose";

import { ApiError } from "../middleware/error.middleware";
import {
  abandonSession,
  answerQuestion,
  completeSession,
  sessionSummary,
  startSession,
} from "../services/exerciseSession.service";
import { getBodyObject, getRequiredObjectId, getRouteObjectId } from "../utils/requestValidation";

const studentIdOf = (request: Request): Types.ObjectId => {
  if (!request.user) {
    throw new ApiError(401, "Unauthorized.", "UNAUTHORIZED");
  }
  return request.user._id;
};

const MAX_TIME_TAKEN_MS = 60 * 60 * 1000;

/** `POST /learn/exercises/:id/sessions` → 201 `{session, play}`. */
export const start = async (request: Request, response: Response): Promise<void> => {
  const exerciseId = getRouteObjectId(request.params.id, "Exercise");
  const { session, exercise, questions } = await startSession(studentIdOf(request), exerciseId);
  response.status(201).json({
    data: {
      session: sessionSummary(session),
      play: { exercise: { ...exercise, questionCount: questions.length }, questions },
    },
  });
};

/** `POST /learn/sessions/:id/answers` `{questionId, answer, timeTakenMs?}`. */
export const answer = async (request: Request, response: Response): Promise<void> => {
  const sessionId = getRouteObjectId(request.params.id, "Session");
  const body = getBodyObject(request.body as unknown);
  const questionId = getRequiredObjectId(body.questionId, "questionId");
  if (body.answer === undefined) {
    throw new ApiError(400, "answer is required.", "VALIDATION_ERROR");
  }
  const rawTime = body.timeTakenMs;
  if (rawTime !== undefined && (typeof rawTime !== "number" || !Number.isFinite(rawTime) || rawTime < 0)) {
    throw new ApiError(400, "timeTakenMs must be a non-negative number.", "VALIDATION_ERROR");
  }
  const timeTakenMs = rawTime === undefined ? undefined : Math.min(Math.round(rawTime), MAX_TIME_TAKEN_MS);

  const result = await answerQuestion(studentIdOf(request), sessionId, questionId, body.answer, timeTakenMs);
  response.status(200).json({ data: result });
};

export const complete = async (request: Request, response: Response): Promise<void> => {
  const sessionId = getRouteObjectId(request.params.id, "Session");
  response.status(200).json({ data: await completeSession(studentIdOf(request), sessionId) });
};

export const abandon = async (request: Request, response: Response): Promise<void> => {
  const sessionId = getRouteObjectId(request.params.id, "Session");
  response.status(200).json({ data: await abandonSession(studentIdOf(request), sessionId) });
};
