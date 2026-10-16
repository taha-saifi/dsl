import mongoose, { Types } from "mongoose";

import { ApiError } from "../middleware/error.middleware";

export const getBodyObject = (body: unknown): Record<string, unknown> => {
  if (typeof body !== "object" || body === null || Array.isArray(body)) {
    throw new ApiError(400, "Request body must be an object.", "VALIDATION_ERROR");
  }

  return body as Record<string, unknown>;
};

export const getRequiredString = (value: unknown, field: string): string => {
  if (typeof value !== "string" || value.trim() === "") {
    throw new ApiError(400, `${field} is required.`, "VALIDATION_ERROR");
  }

  return value.trim();
};

export const getOptionalString = (value: unknown, field: string): string | undefined => {
  if (value === undefined) {
    return undefined;
  }

  if (typeof value !== "string" || value.trim() === "") {
    throw new ApiError(400, `${field} must be a non-empty string.`, "VALIDATION_ERROR");
  }

  return value.trim();
};

export const getRequiredObjectId = (value: unknown, field: string): Types.ObjectId => {
  if (typeof value !== "string" || !mongoose.isObjectIdOrHexString(value)) {
    throw new ApiError(400, `${field} must be a valid ObjectId.`, "VALIDATION_ERROR");
  }

  return new Types.ObjectId(value);
};

export const getOptionalObjectId = (value: unknown, field: string): Types.ObjectId | undefined =>
  value === undefined ? undefined : getRequiredObjectId(value, field);

export const getRequiredNumber = (value: unknown, field: string): number => {
  if (typeof value !== "number" || !Number.isFinite(value)) {
    throw new ApiError(400, `${field} must be a number.`, "VALIDATION_ERROR");
  }

  return value;
};

export const getOptionalNumber = (value: unknown, field: string): number | undefined =>
  value === undefined ? undefined : getRequiredNumber(value, field);

export const getOptionalBoolean = (value: unknown, field: string): boolean | undefined => {
  if (value === undefined) {
    return undefined;
  }

  if (typeof value !== "boolean") {
    throw new ApiError(400, `${field} must be a boolean.`, "VALIDATION_ERROR");
  }

  return value;
};

export const getRouteObjectId = (value: unknown, resource: string): Types.ObjectId =>
  getRequiredObjectId(value, `${resource} id`);
