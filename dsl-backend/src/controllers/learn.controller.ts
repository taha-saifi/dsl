import type { Request, Response } from "express";
import type { Types } from "mongoose";

import { ApiError } from "../middleware/error.middleware";
import {
  enroll as enrollStudent,
  ensureEnrolled,
  unenroll as unenrollStudent,
} from "../services/enrollment.service";
import { buildPlayQuestion, type PlayQuestion } from "../services/playPayload.service";
import { resolveExerciseQuestions } from "../services/questionContent.service";
import { ensureSpecializationExists } from "../services/resourceDependencies.service";
import {
  getCourseDetail,
  getPlayableExercise,
  getUnitDetail,
  listCourseSummaries,
  listEnrolledCourses,
  listLanguageSummaries,
  listSpecializationSummaries,
  type Viewer,
} from "../services/studentCatalog.service";
import { getOptionalObjectId, getRouteObjectId } from "../utils/requestValidation";

const LANGUAGE_CODE = /^[a-z]{2}$/;

const viewerOf = (request: Request): Viewer =>
  request.user?.role === "student" ? { studentId: request.user._id } : {};

const studentIdOf = (request: Request): Types.ObjectId => {
  // requireRole("student") runs first; this narrows the type.
  if (!request.user) {
    throw new ApiError(401, "Unauthorized.", "UNAUTHORIZED");
  }
  return request.user._id;
};
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

  const data = await listCourseSummaries(
    {
      ...(specializationId ? { specializationId } : {}),
      ...(targetLanguage ? { targetLanguage } : {}),
      ...(search ? { search } : {}),
    },
    viewerOf(request),
  );
  response.status(200).json({ data });
};

export const course = async (request: Request, response: Response): Promise<void> => {
  const courseId = getRouteObjectId(request.params.id, "Course");
  response.status(200).json({ data: await getCourseDetail(courseId, viewerOf(request)) });
};

export const unit = async (request: Request, response: Response): Promise<void> => {
  const unitId = getRouteObjectId(request.params.id, "Unit");
  response.status(200).json({ data: await getUnitDetail(unitId) });
};

export const enroll = async (request: Request, response: Response): Promise<void> => {
  const courseId = getRouteObjectId(request.params.id, "Course");
  const { enrollment, created } = await enrollStudent(studentIdOf(request), courseId);
  response.status(created ? 201 : 200).json({ data: enrollment });
};

export const unenroll = async (request: Request, response: Response): Promise<void> => {
  const courseId = getRouteObjectId(request.params.id, "Course");
  await unenrollStudent(studentIdOf(request), courseId);
  response.status(200).json({ data: { id: courseId } });
};

export const myCourses = async (request: Request, response: Response): Promise<void> => {
  response.status(200).json({ data: await listEnrolledCourses(studentIdOf(request)) });
};

/**
 * `GET /learn/exercises/:id/play`: the exercise and its questions in order,
 * without answers. Students must be enrolled in the course.
 */
export const play = async (request: Request, response: Response): Promise<void> => {
  const exerciseId = getRouteObjectId(request.params.id, "Exercise");
  const exercise = await getPlayableExercise(exerciseId);
  const viewer = viewerOf(request);
  if (viewer.studentId) {
    await ensureEnrolled(viewer.studentId, exercise.courseId);
  }

  const resolved = await resolveExerciseQuestions(exerciseId);
  const questions: PlayQuestion[] = [];
  for (const entry of resolved) {
    const built = buildPlayQuestion(entry);
    if (built) {
      questions.push(built);
    } else {
      console.warn(`Play: skipped question ${entry.question._id.toString()} (missing content).`);
    }
  }

  response.status(200).json({ data: { exercise: { ...exercise, questionCount: questions.length }, questions } });
};
