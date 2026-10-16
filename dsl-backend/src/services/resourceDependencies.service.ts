import { Types } from "mongoose";

import { ApiError } from "../middleware/error.middleware";
import Course from "../models/Course";
import Exercise from "../models/Exercise";
import LearningItem from "../models/LearningItem";
import Question from "../models/Question";
import Specialization from "../models/Specialization";
import Unit from "../models/Unit";

export const ensureSpecializationExists = async (specializationId: Types.ObjectId): Promise<void> => {
  const specialization = await Specialization.exists({ _id: specializationId });
  if (!specialization) {
    throw new ApiError(404, "Specialization not found.", "SPECIALIZATION_NOT_FOUND");
  }
};

export const ensureCourseExists = async (courseId: Types.ObjectId): Promise<void> => {
  const course = await Course.exists({ _id: courseId });
  if (!course) {
    throw new ApiError(404, "Course not found.", "COURSE_NOT_FOUND");
  }
};

export const ensureSpecializationHasNoCourses = async (
  specializationId: Types.ObjectId,
): Promise<void> => {
  const course = await Course.exists({ specializationId });
  if (course) {
    throw new ApiError(
      409,
      "Cannot delete a specialization while courses reference it.",
      "SPECIALIZATION_HAS_COURSES",
    );
  }
};

export const ensureCourseHasNoUnits = async (courseId: Types.ObjectId): Promise<void> => {
  const unit = await Unit.exists({ courseId });
  if (unit) {
    throw new ApiError(409, "Cannot delete a course while units reference it.", "COURSE_HAS_UNITS");
  }
};

export const ensureLearningItemHasNoUnitReferences = async (
  learningItemId: Types.ObjectId,
): Promise<void> => {
  const unit = await Unit.exists({ "learningItems.learningItemId": learningItemId });
  if (unit) {
    throw new ApiError(
      409,
      "Cannot delete a learning item while a unit references it.",
      "LEARNING_ITEM_ATTACHED_TO_UNIT",
    );
  }
};

export const ensureLearningItemExists = async (learningItemId: Types.ObjectId): Promise<void> => {
  const learningItem = await LearningItem.exists({ _id: learningItemId });
  if (!learningItem) {
    throw new ApiError(404, "Learning item not found.", "LEARNING_ITEM_NOT_FOUND");
  }
};

export const ensureUnitExists = async (unitId: Types.ObjectId): Promise<void> => {
  const unit = await Unit.exists({ _id: unitId });
  if (!unit) {
    throw new ApiError(404, "Unit not found.", "UNIT_NOT_FOUND");
  }
};

export const ensureExerciseExists = async (exerciseId: Types.ObjectId): Promise<void> => {
  const exercise = await Exercise.exists({ _id: exerciseId });
  if (!exercise) {
    throw new ApiError(404, "Exercise not found.", "EXERCISE_NOT_FOUND");
  }
};

export const ensureExerciseHasNoQuestions = async (exerciseId: Types.ObjectId): Promise<void> => {
  const question = await Question.exists({ exerciseId });
  if (question) {
    throw new ApiError(
      409,
      "Cannot delete an exercise while questions reference it.",
      "EXERCISE_HAS_QUESTIONS",
    );
  }
};

export const ensureUnitHasNoExercises = async (unitId: Types.ObjectId): Promise<void> => {
  const exercise = await Exercise.exists({ unitId });
  if (exercise) {
    throw new ApiError(409, "Cannot delete a unit while exercises reference it.", "UNIT_HAS_EXERCISES");
  }
};

// Pass null for a not-yet-created resource (e.g. during create) — it can't have children yet, so the gate always fails.
export const ensureExerciseReadyToPublish = async (exerciseId: Types.ObjectId | null): Promise<void> => {
  const hasQuestion = exerciseId !== null && (await Question.exists({ exerciseId }));
  if (!hasQuestion) {
    throw new ApiError(
      409,
      "Cannot publish this exercise: it has no questions yet.",
      "EXERCISE_HAS_NO_QUESTIONS",
    );
  }
};

export const ensureUnitReadyToPublish = async (unitId: Types.ObjectId | null): Promise<void> => {
  const hasPublishedExercise = unitId !== null && (await Exercise.exists({ unitId, isPublished: true }));
  if (!hasPublishedExercise) {
    throw new ApiError(
      409,
      "Cannot publish this unit: it has no published exercises yet.",
      "UNIT_HAS_NO_PUBLISHED_EXERCISE",
    );
  }
};

export const ensureCourseReadyToPublish = async (courseId: Types.ObjectId | null): Promise<void> => {
  const hasPublishedUnit = courseId !== null && (await Unit.exists({ courseId, isPublished: true }));
  if (!hasPublishedUnit) {
    throw new ApiError(
      409,
      "Cannot publish this course: it has no published units yet.",
      "COURSE_HAS_NO_PUBLISHED_UNIT",
    );
  }
};
