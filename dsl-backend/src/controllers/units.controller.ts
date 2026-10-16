import type { Request, Response } from "express";
import { Types } from "mongoose";

import { ApiError } from "../middleware/error.middleware";
import Unit from "../models/Unit";
import {
  ensureCourseExists,
  ensureLearningItemExists,
  ensureUnitHasNoExercises,
  ensureUnitReadyToPublish,
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

interface LearningItemReorderEntry {
  learningItemId: Types.ObjectId;
  order: number;
}

const getUnitUpdate = async (body: Record<string, unknown>): Promise<Record<string, unknown>> => {
  const update: Record<string, unknown> = {};
  const courseId = getOptionalObjectId(body.courseId, "Course ID");
  const name = getOptionalString(body.name, "Name");
  const orderIndex = getOptionalNumber(body.orderIndex, "orderIndex");
  const isPublished = getOptionalBoolean(body.isPublished, "isPublished");

  if (courseId !== undefined) {
    await ensureCourseExists(courseId);
    update.courseId = courseId;
  }
  if (name !== undefined) update.name = name;
  if (orderIndex !== undefined) update.orderIndex = orderIndex;
  if (isPublished !== undefined) update.isPublished = isPublished;

  return update;
};

export const list = async (request: Request, response: Response): Promise<void> => {
  const courseIdQuery = request.query.courseId;
  const filter: { courseId?: Types.ObjectId } = {};
  if (courseIdQuery !== undefined) {
    filter.courseId = getRequiredObjectId(courseIdQuery, "courseId");
  }

  const units = await Unit.find(filter).sort({ orderIndex: 1 });
  response.status(200).json({ data: units });
};

export const getById = async (request: Request, response: Response): Promise<void> => {
  const unitId = getRouteObjectId(request.params.id, "Unit");
  const unit = await Unit.findById(unitId);
  if (!unit) {
    throw new ApiError(404, "Unit not found.", "UNIT_NOT_FOUND");
  }

  response.status(200).json({ data: unit });
};

export const create = async (request: Request, response: Response): Promise<void> => {
  const body = getBodyObject(request.body as unknown);
  const courseId = getRequiredObjectId(body.courseId, "Course ID");
  await ensureCourseExists(courseId);

  const name = getRequiredString(body.name, "Name");
  const orderIndex = getRequiredNumber(body.orderIndex, "orderIndex");
  const isPublished = getOptionalBoolean(body.isPublished, "isPublished");
  if (isPublished === true) {
    await ensureUnitReadyToPublish(null);
  }

  const unit = await Unit.create({
    courseId,
    name,
    orderIndex,
    ...(isPublished !== undefined ? { isPublished } : {}),
  });
  response.status(201).json({ data: unit });
};

export const update = async (request: Request, response: Response): Promise<void> => {
  const unitId = getRouteObjectId(request.params.id, "Unit");
  const existing = await Unit.findById(unitId);
  if (!existing) {
    throw new ApiError(404, "Unit not found.", "UNIT_NOT_FOUND");
  }

  const update = await getUnitUpdate(getBodyObject(request.body as unknown));
  if (update.isPublished === true) {
    await ensureUnitReadyToPublish(unitId);
  }

  const unit = await Unit.findByIdAndUpdate(unitId, update, { new: true, runValidators: true });
  if (!unit) {
    throw new ApiError(404, "Unit not found.", "UNIT_NOT_FOUND");
  }

  response.status(200).json({ data: unit });
};

export const reorder = async (request: Request, response: Response): Promise<void> => {
  const body = getBodyObject(request.body as unknown);
  const courseId = getRequiredObjectId(body.courseId, "Course ID");
  await ensureCourseExists(courseId);

  if (!Array.isArray(body.units) || body.units.length === 0) {
    throw new ApiError(400, "units must be a non-empty array.", "VALIDATION_ERROR");
  }

  const entries: ReorderEntry[] = body.units.map((entry) => {
    const item = getBodyObject(entry);
    return {
      id: getRequiredObjectId(item.id, "Unit ID"),
      orderIndex: getRequiredNumber(item.orderIndex, "orderIndex"),
    };
  });
  const unitIds = entries.map((entry) => entry.id);
  if (new Set(unitIds.map((unitId) => unitId.toString())).size !== unitIds.length) {
    throw new ApiError(400, "Each unit may appear only once.", "VALIDATION_ERROR");
  }

  const matchedUnits = await Unit.countDocuments({ courseId, _id: { $in: unitIds } });
  if (matchedUnits !== entries.length) {
    throw new ApiError(404, "One or more units do not belong to the course.", "UNIT_NOT_FOUND");
  }

  await Unit.bulkWrite(
    entries.map((entry) => ({
      updateOne: { filter: { _id: entry.id, courseId }, update: { orderIndex: entry.orderIndex } },
    })),
  );

  const units = await Unit.find({ courseId }).sort({ orderIndex: 1 });
  response.status(200).json({ data: units });
};

export const attachLearningItem = async (request: Request, response: Response): Promise<void> => {
  const unitId = getRouteObjectId(request.params.id, "Unit");
  const unit = await Unit.findById(unitId);
  if (!unit) {
    throw new ApiError(404, "Unit not found.", "UNIT_NOT_FOUND");
  }

  const body = getBodyObject(request.body as unknown);
  const learningItemId = getRequiredObjectId(body.learningItemId, "Learning item ID");
  const order = getRequiredNumber(body.order, "order");
  await ensureLearningItemExists(learningItemId);

  if (unit.learningItems.some((item) => item.learningItemId.equals(learningItemId))) {
    throw new ApiError(
      409,
      "This learning item is already attached to the unit.",
      "LEARNING_ITEM_ALREADY_ATTACHED",
    );
  }

  unit.learningItems.push({ learningItemId, order });
  await unit.save();
  response.status(201).json({ data: unit });
};

export const detachLearningItem = async (request: Request, response: Response): Promise<void> => {
  const unitId = getRouteObjectId(request.params.id, "Unit");
  const learningItemId = getRequiredObjectId(request.params.learningItemId, "Learning item ID");
  const unit = await Unit.findById(unitId);
  if (!unit) {
    throw new ApiError(404, "Unit not found.", "UNIT_NOT_FOUND");
  }

  const attachmentIndex = unit.learningItems.findIndex((item) =>
    item.learningItemId.equals(learningItemId),
  );
  if (attachmentIndex !== -1) {
    unit.learningItems.splice(attachmentIndex, 1);
    await unit.save();
  }

  response.status(200).json({ data: unit });
};

export const reorderLearningItems = async (request: Request, response: Response): Promise<void> => {
  const unitId = getRouteObjectId(request.params.id, "Unit");
  const unit = await Unit.findById(unitId);
  if (!unit) {
    throw new ApiError(404, "Unit not found.", "UNIT_NOT_FOUND");
  }
  if (!Array.isArray(request.body)) {
    throw new ApiError(400, "Request body must be an array.", "VALIDATION_ERROR");
  }

  const entries: LearningItemReorderEntry[] = request.body.map((entry) => {
    const item = getBodyObject(entry);
    return {
      learningItemId: getRequiredObjectId(item.learningItemId, "Learning item ID"),
      order: getRequiredNumber(item.order, "order"),
    };
  });
  const incomingIds = entries.map((entry) => entry.learningItemId.toString());
  const attachedIds = unit.learningItems.map((item) => item.learningItemId.toString());
  const incomingIdSet = new Set(incomingIds);
  if (
    incomingIdSet.size !== entries.length ||
    entries.length !== attachedIds.length ||
    !attachedIds.every((learningItemId) => incomingIdSet.has(learningItemId))
  ) {
    throw new ApiError(
      400,
      "Reorder payload must include each attached learning item exactly once.",
      "VALIDATION_ERROR",
    );
  }

  for (const entry of entries) {
    const attachment = unit.learningItems.find((item) =>
      item.learningItemId.equals(entry.learningItemId),
    );
    if (attachment) {
      attachment.order = entry.order;
    }
  }

  await unit.save();
  response.status(200).json({ data: unit });
};

export const remove = async (request: Request, response: Response): Promise<void> => {
  const unitId = getRouteObjectId(request.params.id, "Unit");
  const unit = await Unit.findById(unitId);
  if (!unit) {
    throw new ApiError(404, "Unit not found.", "UNIT_NOT_FOUND");
  }

  await ensureUnitHasNoExercises(unitId);
  await unit.deleteOne();
  response.status(200).json({ data: { id: unit.id } });
};
