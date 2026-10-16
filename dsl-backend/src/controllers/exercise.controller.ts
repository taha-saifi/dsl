import type { Request, Response } from "express";
import { Types } from "mongoose";

import { ApiError } from "../middleware/error.middleware";
import Exercise from "../models/Exercise";
import {
  ensureExerciseHasNoQuestions,
  ensureExerciseReadyToPublish,
  ensureUnitExists,
} from "../services/resourceDependencies.service";
import {
  getBodyObject,
  getOptionalBoolean,
  getOptionalNumber,
  getOptionalObjectId,
  getOptionalString,
  getRequiredNumber,
  getRequiredObjectId,
  getRequiredString,
  getRouteObjectId,
} from "../utils/requestValidation";

interface ReorderEntry {
  id: Types.ObjectId;
  orderIndex: number;
}

const getExerciseUpdate = async (body: Record<string, unknown>): Promise<Record<string, unknown>> => {
  const update: Record<string, unknown> = {};
  const unitId = getOptionalObjectId(body.unitId, "Unit ID");
  const name = getOptionalString(body.name, "Name");
  const orderIndex = getOptionalNumber(body.orderIndex, "orderIndex");
  const isPublished = getOptionalBoolean(body.isPublished, "isPublished");

  if (unitId !== undefined) {
    await ensureUnitExists(unitId);
    update.unitId = unitId;
  }
  if (name !== undefined) update.name = name;
  if (orderIndex !== undefined) update.orderIndex = orderIndex;
  if (isPublished !== undefined) update.isPublished = isPublished;

  return update;
};

export const list = async (request: Request, response: Response): Promise<void> => {
  const unitIdQuery = request.query.unitId;
  const filter: { unitId?: Types.ObjectId } = {};
  if (unitIdQuery !== undefined) {
    filter.unitId = getRequiredObjectId(unitIdQuery, "unitId");
  }

  const exercises = await Exercise.find(filter).sort({ orderIndex: 1 });
  response.status(200).json({ data: exercises });
};

export const getById = async (request: Request, response: Response): Promise<void> => {
  const exerciseId = getRouteObjectId(request.params.id, "Exercise");
  const exercise = await Exercise.findById(exerciseId);
  if (!exercise) {
    throw new ApiError(404, "Exercise not found.", "EXERCISE_NOT_FOUND");
  }

  response.status(200).json({ data: exercise });
};

export const create = async (request: Request, response: Response): Promise<void> => {
  const body = getBodyObject(request.body as unknown);
  const unitId = getRequiredObjectId(body.unitId, "Unit ID");
  await ensureUnitExists(unitId);

  const name = getRequiredString(body.name, "Name");
  const orderIndex = getRequiredNumber(body.orderIndex, "orderIndex");
  const isPublished = getOptionalBoolean(body.isPublished, "isPublished");
  if (isPublished === true) {
    await ensureExerciseReadyToPublish(null);
  }

  const exercise = await Exercise.create({
    unitId,
    name,
    orderIndex,
    ...(isPublished !== undefined ? { isPublished } : {}),
  });
  response.status(201).json({ data: exercise });
};

export const update = async (request: Request, response: Response): Promise<void> => {
  const exerciseId = getRouteObjectId(request.params.id, "Exercise");
  const existing = await Exercise.findById(exerciseId);
  if (!existing) {
    throw new ApiError(404, "Exercise not found.", "EXERCISE_NOT_FOUND");
  }

  const update = await getExerciseUpdate(getBodyObject(request.body as unknown));
  if (update.isPublished === true) {
    await ensureExerciseReadyToPublish(exerciseId);
  }

  const exercise = await Exercise.findByIdAndUpdate(exerciseId, update, {
    new: true,
    runValidators: true,
  });
  if (!exercise) {
    throw new ApiError(404, "Exercise not found.", "EXERCISE_NOT_FOUND");
  }

  response.status(200).json({ data: exercise });
};

export const remove = async (request: Request, response: Response): Promise<void> => {
  const exerciseId = getRouteObjectId(request.params.id, "Exercise");
  const exercise = await Exercise.findById(exerciseId);
  if (!exercise) {
    throw new ApiError(404, "Exercise not found.", "EXERCISE_NOT_FOUND");
  }

  await ensureExerciseHasNoQuestions(exerciseId);
  await exercise.deleteOne();
  response.status(200).json({ data: { id: exercise.id } });
};

export const reorder = async (request: Request, response: Response): Promise<void> => {
  if (!Array.isArray(request.body) || request.body.length === 0) {
    throw new ApiError(400, "Request body must be a non-empty array.", "VALIDATION_ERROR");
  }

  const entries: ReorderEntry[] = request.body.map((entry) => {
    const item = getBodyObject(entry);
    return {
      id: getRequiredObjectId(item.id, "Exercise ID"),
      orderIndex: getRequiredNumber(item.orderIndex, "orderIndex"),
    };
  });
  const exerciseIds = entries.map((entry) => entry.id);
  if (new Set(exerciseIds.map((id) => id.toString())).size !== exerciseIds.length) {
    throw new ApiError(400, "Each exercise may appear only once.", "VALIDATION_ERROR");
  }

  const exercises = await Exercise.find({ _id: { $in: exerciseIds } }).select("unitId");
  const firstExercise = exercises[0];
  if (exercises.length !== entries.length || !firstExercise) {
    throw new ApiError(404, "One or more exercises do not exist.", "EXERCISE_NOT_FOUND");
  }

  const unitIds = new Set(exercises.map((exercise) => exercise.unitId.toString()));
  if (unitIds.size !== 1) {
    throw new ApiError(
      400,
      "All exercises in a reorder request must belong to the same unit.",
      "VALIDATION_ERROR",
    );
  }

  await Exercise.bulkWrite(
    entries.map((entry) => ({
      updateOne: { filter: { _id: entry.id }, update: { orderIndex: entry.orderIndex } },
    })),
  );

  const updatedExercises = await Exercise.find({ unitId: firstExercise.unitId }).sort({
    orderIndex: 1,
  });
  response.status(200).json({ data: updatedExercises });
};
