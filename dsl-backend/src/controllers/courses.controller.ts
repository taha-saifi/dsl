import type { Request, Response } from "express";
import { Types } from "mongoose";

import { ApiError } from "../middleware/error.middleware";
import Course from "../models/Course";
import {
  ensureCourseHasNoUnits,
  ensureCourseReadyToPublish,
  ensureSpecializationExists,
} from "../services/resourceDependencies.service";
import {
  getBodyObject,
  getOptionalBoolean,
  getOptionalObjectId,
  getOptionalString,
  getRequiredObjectId,
  getRequiredString,
  getRouteObjectId,
} from "../utils/requestValidation";

const getCourseUpdate = async (body: Record<string, unknown>): Promise<Record<string, unknown>> => {
  const update: Record<string, unknown> = {};
  const specializationId = getOptionalObjectId(body.specializationId, "Specialization ID");
  const thumbnailMediaId = getOptionalObjectId(body.thumbnailMediaId, "Thumbnail media ID");
  const name = getOptionalString(body.name, "Name");
  const sourceLanguage = getOptionalString(body.sourceLanguage, "Source language");
  const targetLanguage = getOptionalString(body.targetLanguage, "Target language");
  const description = getOptionalString(body.description, "Description");
  const isPublished = getOptionalBoolean(body.isPublished, "isPublished");

  if (specializationId !== undefined) {
    await ensureSpecializationExists(specializationId);
    update.specializationId = specializationId;
  }
  if (thumbnailMediaId !== undefined) update.thumbnailMediaId = thumbnailMediaId;
  if (name !== undefined) update.name = name;
  if (sourceLanguage !== undefined) update.sourceLanguage = sourceLanguage.toLowerCase();
  if (targetLanguage !== undefined) update.targetLanguage = targetLanguage.toLowerCase();
  if (description !== undefined) update.description = description;
  if (isPublished !== undefined) update.isPublished = isPublished;

  return update;
};

export const list = async (request: Request, response: Response): Promise<void> => {
  const specializationIdQuery = request.query.specializationId;
  const filter: { specializationId?: Types.ObjectId } = {};
  if (specializationIdQuery !== undefined) {
    filter.specializationId = getRequiredObjectId(specializationIdQuery, "specializationId");
  }

  const courses = await Course.find(filter).sort({ createdAt: -1 });
  response.status(200).json({ data: courses });
};

export const getById = async (request: Request, response: Response): Promise<void> => {
  const courseId = getRouteObjectId(request.params.id, "Course");
  const course = await Course.findById(courseId);
  if (!course) {
    throw new ApiError(404, "Course not found.", "COURSE_NOT_FOUND");
  }

  response.status(200).json({ data: course });
};

export const create = async (request: Request, response: Response): Promise<void> => {
  const body = getBodyObject(request.body as unknown);
  const specializationId = getRequiredObjectId(body.specializationId, "Specialization ID");
  await ensureSpecializationExists(specializationId);

  const thumbnailMediaId = getOptionalObjectId(body.thumbnailMediaId, "Thumbnail media ID");
  const name = getRequiredString(body.name, "Name");
  const sourceLanguage = getRequiredString(body.sourceLanguage, "Source language").toLowerCase();
  const targetLanguage = getRequiredString(body.targetLanguage, "Target language").toLowerCase();
  const description = getOptionalString(body.description, "Description");
  const isPublished = getOptionalBoolean(body.isPublished, "isPublished");
  if (isPublished === true) {
    await ensureCourseReadyToPublish(null);
  }

  const course = await Course.create({
    specializationId,
    name,
    sourceLanguage,
    targetLanguage,
    ...(thumbnailMediaId !== undefined ? { thumbnailMediaId } : {}),
    ...(description !== undefined ? { description } : {}),
    ...(isPublished !== undefined ? { isPublished } : {}),
  });
  response.status(201).json({ data: course });
};

export const update = async (request: Request, response: Response): Promise<void> => {
  const courseId = getRouteObjectId(request.params.id, "Course");
  const existing = await Course.findById(courseId);
  if (!existing) {
    throw new ApiError(404, "Course not found.", "COURSE_NOT_FOUND");
  }

  const update = await getCourseUpdate(getBodyObject(request.body as unknown));
  if (update.isPublished === true) {
    await ensureCourseReadyToPublish(courseId);
  }

  const course = await Course.findByIdAndUpdate(courseId, update, { new: true, runValidators: true });
  if (!course) {
    throw new ApiError(404, "Course not found.", "COURSE_NOT_FOUND");
  }

  response.status(200).json({ data: course });
};

export const remove = async (request: Request, response: Response): Promise<void> => {
  const courseId = getRouteObjectId(request.params.id, "Course");
  const course = await Course.findById(courseId);
  if (!course) {
    throw new ApiError(404, "Course not found.", "COURSE_NOT_FOUND");
  }

  await ensureCourseHasNoUnits(courseId);
  await course.deleteOne();
  response.status(200).json({ data: { id: course.id } });
};
