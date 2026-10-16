import type { Request, Response } from "express";

import { ApiError } from "../middleware/error.middleware";
import Specialization, { toKebabCase } from "../models/Specialization";
import {
  ensureSpecializationHasNoCourses,
} from "../services/resourceDependencies.service";
import {
  getBodyObject,
  getOptionalString,
  getRequiredString,
  getRouteObjectId,
} from "../utils/requestValidation";

const getSpecializationUpdate = (body: Record<string, unknown>): Record<string, unknown> => {
  const update: Record<string, unknown> = {};
  const name = getOptionalString(body.name, "Name");
  const slug = getOptionalString(body.slug, "Slug");
  const iconUrl = getOptionalString(body.iconUrl, "Icon URL");

  if (name !== undefined) {
    update.name = name;
  }
  if (slug !== undefined) {
    update.slug = slug.toLowerCase();
  }
  if (iconUrl !== undefined) {
    update.iconUrl = iconUrl;
  }

  return update;
};

export const list = async (_request: Request, response: Response): Promise<void> => {
  const specializations = await Specialization.find().sort({ name: 1 });
  response.status(200).json({ data: specializations });
};

export const getById = async (request: Request, response: Response): Promise<void> => {
  const specializationId = getRouteObjectId(request.params.id, "Specialization");
  const specialization = await Specialization.findById(specializationId);
  if (!specialization) {
    throw new ApiError(404, "Specialization not found.", "SPECIALIZATION_NOT_FOUND");
  }

  response.status(200).json({ data: specialization });
};

export const create = async (request: Request, response: Response): Promise<void> => {
  const body = getBodyObject(request.body as unknown);
  const name = getRequiredString(body.name, "Name");
  const suppliedSlug = getOptionalString(body.slug, "Slug");
  const slug = (suppliedSlug ?? toKebabCase(name)).toLowerCase();
  const iconUrl = getOptionalString(body.iconUrl, "Icon URL");

  if (!slug) {
    throw new ApiError(400, "Name must produce a valid slug.", "VALIDATION_ERROR");
  }

  const existingSpecialization = await Specialization.exists({ slug });
  if (existingSpecialization) {
    throw new ApiError(409, "A specialization with that slug already exists.", "SLUG_IN_USE");
  }

  const specialization = await Specialization.create({
    name,
    slug,
    ...(iconUrl !== undefined ? { iconUrl } : {}),
  });
  response.status(201).json({ data: specialization });
};

export const update = async (request: Request, response: Response): Promise<void> => {
  const specializationId = getRouteObjectId(request.params.id, "Specialization");
  const update = getSpecializationUpdate(getBodyObject(request.body as unknown));

  if (typeof update.slug === "string") {
    const existingSpecialization = await Specialization.exists({
      slug: update.slug,
      _id: { $ne: specializationId },
    });
    if (existingSpecialization) {
      throw new ApiError(409, "A specialization with that slug already exists.", "SLUG_IN_USE");
    }
  }

  const specialization = await Specialization.findByIdAndUpdate(specializationId, update, {
    new: true,
    runValidators: true,
  });
  if (!specialization) {
    throw new ApiError(404, "Specialization not found.", "SPECIALIZATION_NOT_FOUND");
  }

  response.status(200).json({ data: specialization });
};

export const remove = async (request: Request, response: Response): Promise<void> => {
  const specializationId = getRouteObjectId(request.params.id, "Specialization");
  const specialization = await Specialization.findById(specializationId);
  if (!specialization) {
    throw new ApiError(404, "Specialization not found.", "SPECIALIZATION_NOT_FOUND");
  }

  await ensureSpecializationHasNoCourses(specializationId);
  await specialization.deleteOne();
  response.status(200).json({ data: { id: specialization.id } });
};
