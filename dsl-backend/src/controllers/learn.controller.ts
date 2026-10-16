import type { Request, Response } from "express";

import { ApiError } from "../middleware/error.middleware";
import { ensureSpecializationExists } from "../services/resourceDependencies.service";
import {
  getCourseDetail,
  getUnitDetail,
  listCourseSummaries,
  listLanguageSummaries,
  listSpecializationSummaries,
} from "../services/studentCatalog.service";
import { getOptionalObjectId, getRouteObjectId } from "../utils/requestValidation";

const LANGUAGE_CODE = /^[a-z]{2}$/;
const SEARCH_MAX_LENGTH = 100;

const getOptionalQueryString = (value: unknown, field: string): string | undefined => {
  if (value === undefined) {
    return undefined;
  }
  if (typeof value !== "string") {
    throw new ApiError(400, `${field} must be a single value.`, "VALIDATION_ERROR");
  }
  const trimmed = value.trim();
  return trimmed === "" ? undefined : trimmed;
};

export const specializations = async (_request: Request, response: Response): Promise<void> => {
  response.status(200).json({ data: await listSpecializationSummaries() });
};

export const languages = async (request: Request, response: Response): Promise<void> => {
  const specializationId = getOptionalObjectId(request.query.specializationId, "Specialization id");
  if (specializationId) {
    await ensureSpecializationExists(specializationId);
  }

  response.status(200).json({ data: await listLanguageSummaries(specializationId) });
};

export const courses = async (request: Request, response: Response): Promise<void> => {
  const specializationId = getOptionalObjectId(request.query.specializationId, "Specialization id");
  const targetLanguage = getOptionalQueryString(request.query.targetLanguage, "Target language")?.toLowerCase();
  if (targetLanguage !== undefined && !LANGUAGE_CODE.test(targetLanguage)) {
    throw new ApiError(400, "Target language must be a 2-letter language code.", "VALIDATION_ERROR");
  }
  const search = getOptionalQueryString(request.query.search, "Search");
  if (search !== undefined && search.length > SEARCH_MAX_LENGTH) {
    throw new ApiError(400, `Search must be at most ${SEARCH_MAX_LENGTH} characters.`, "VALIDATION_ERROR");
  }

  const data = await listCourseSummaries({
    ...(specializationId ? { specializationId } : {}),
    ...(targetLanguage ? { targetLanguage } : {}),
    ...(search ? { search } : {}),
  });
  response.status(200).json({ data });
};

export const course = async (request: Request, response: Response): Promise<void> => {
  const courseId = getRouteObjectId(request.params.id, "Course");
  response.status(200).json({ data: await getCourseDetail(courseId) });
};

export const unit = async (request: Request, response: Response): Promise<void> => {
  const unitId = getRouteObjectId(request.params.id, "Unit");
  response.status(200).json({ data: await getUnitDetail(unitId) });
};
