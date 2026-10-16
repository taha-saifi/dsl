import { Types, type QueryFilter } from "mongoose";

import { publicMediaUrl } from "../config/storage";
import { ApiError } from "../middleware/error.middleware";
import Course, { type ICourse } from "../models/Course";
import Exercise from "../models/Exercise";
import Media from "../models/Media";
import Question from "../models/Question";
import Specialization from "../models/Specialization";
import Unit from "../models/Unit";

/*
 * What a student can see. Content is visible only when it's published all
 * the way down:
 *   exercise: isPublished and ≥1 question ("playable")
 *   unit:     isPublished, in a visible course, with ≥1 playable exercise
 *   course:   isPublished, with ≥1 visible unit
 *   domain:   has ≥1 visible course
 * Publish gating doesn't cascade (a teacher can unpublish the last exercise
 * of a published unit), so this is checked on every read. Hidden or missing
 * content is a 404, never a 403, so drafts don't leak.
 *
 * Loads the tree in four queries per request; fine at MVP sizes.
 */

interface VisibleExercise {
  _id: Types.ObjectId;
  name: string;
  orderIndex: number;
  questionCount: number;
}

interface VisibleUnit {
  _id: Types.ObjectId;
  name: string;
  orderIndex: number;
  exercises: VisibleExercise[];
}

interface VisibleCourse {
  course: ICourse & { _id: Types.ObjectId };
  units: VisibleUnit[];
}

const byOrder = (a: { orderIndex: number }, b: { orderIndex: number }): number =>
  a.orderIndex - b.orderIndex;

const loadVisibleCourses = async (filter: QueryFilter<ICourse>): Promise<VisibleCourse[]> => {
  const courses = await Course.find({ ...filter, isPublished: true }).sort({ createdAt: -1 }).lean();
  if (courses.length === 0) {
    return [];
  }

  const units = await Unit.find({ courseId: { $in: courses.map((c) => c._id) }, isPublished: true })
    .select("courseId name orderIndex")
    .lean();
  const exercises = await Exercise.find({ unitId: { $in: units.map((u) => u._id) }, isPublished: true })
    .select("unitId name orderIndex")
    .lean();
  const questionCounts = await Question.aggregate<{ _id: Types.ObjectId; count: number }>([
    { $match: { exerciseId: { $in: exercises.map((e) => e._id) } } },
    { $group: { _id: "$exerciseId", count: { $sum: 1 } } },
  ]);
  const countByExercise = new Map(questionCounts.map((q) => [q._id.toString(), q.count]));

  const exercisesByUnit = new Map<string, VisibleExercise[]>();
  for (const exercise of exercises) {
    const questionCount = countByExercise.get(exercise._id.toString()) ?? 0;
    if (questionCount === 0) {
      continue;
    }
    const key = exercise.unitId.toString();
    const list = exercisesByUnit.get(key) ?? [];
    list.push({ _id: exercise._id, name: exercise.name, orderIndex: exercise.orderIndex, questionCount });
    exercisesByUnit.set(key, list);
  }

  const unitsByCourse = new Map<string, VisibleUnit[]>();
  for (const unit of units) {
    const unitExercises = exercisesByUnit.get(unit._id.toString());
    if (!unitExercises) {
      continue;
    }
    const key = unit.courseId.toString();
    const list = unitsByCourse.get(key) ?? [];
    list.push({
      _id: unit._id,
      name: unit.name,
      orderIndex: unit.orderIndex,
      exercises: unitExercises.sort(byOrder),
    });
    unitsByCourse.set(key, list);
  }

  return courses.flatMap((course) => {
    const courseUnits = unitsByCourse.get(course._id.toString());
    return courseUnits ? [{ course, units: courseUnits.sort(byOrder) }] : [];
  });
};

const thumbnailUrls = async (courses: VisibleCourse[]): Promise<Map<string, string>> => {
  const ids = courses.flatMap(({ course }) => (course.thumbnailMediaId ? [course.thumbnailMediaId] : []));
  if (ids.length === 0) {
    return new Map();
  }
  const media = await Media.find({ _id: { $in: ids }, type: "image" }).select("storageKey").lean();
  return new Map(media.map((m) => [m._id.toString(), publicMediaUrl(m.storageKey)]));
};

/** The course fields a student sees. No authoring fields (`isPublished`, ids of drafts). */
const courseSummary = (
  { course, units }: VisibleCourse,
  thumbnails: Map<string, string>,
): Record<string, unknown> => {
  const thumbnailUrl = course.thumbnailMediaId ? thumbnails.get(course.thumbnailMediaId.toString()) : undefined;
  return {
    _id: course._id,
    specializationId: course.specializationId,
    name: course.name,
    ...(course.description ? { description: course.description } : {}),
    sourceLanguage: course.sourceLanguage,
    targetLanguage: course.targetLanguage,
    ...(thumbnailUrl ? { thumbnailUrl } : {}),
    unitCount: units.length,
    exerciseCount: units.reduce((sum, unit) => sum + unit.exercises.length, 0),
  };
};

const escapeRegExp = (value: string): string => value.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");

export interface CourseFilters {
  specializationId?: Types.ObjectId;
  targetLanguage?: string;
  search?: string;
}

export const listCourseSummaries = async (filters: CourseFilters): Promise<Record<string, unknown>[]> => {
  const visible = await loadVisibleCourses({
    ...(filters.specializationId ? { specializationId: filters.specializationId } : {}),
    ...(filters.targetLanguage ? { targetLanguage: filters.targetLanguage } : {}),
    ...(filters.search ? { name: { $regex: escapeRegExp(filters.search), $options: "i" } } : {}),
  });
  const thumbnails = await thumbnailUrls(visible);
  return visible.map((entry) => courseSummary(entry, thumbnails));
};

/** A visible course with its visible units (each with `exerciseCount`). */
export const getCourseDetail = async (courseId: Types.ObjectId): Promise<Record<string, unknown>> => {
  const [visible] = await loadVisibleCourses({ _id: courseId });
  if (!visible) {
    throw new ApiError(404, "Course not found.", "COURSE_NOT_FOUND");
  }
  const thumbnails = await thumbnailUrls([visible]);
  return {
    ...courseSummary(visible, thumbnails),
    units: visible.units.map((unit) => ({
      _id: unit._id,
      name: unit.name,
      orderIndex: unit.orderIndex,
      exerciseCount: unit.exercises.length,
    })),
  };
};

/** A visible unit with its playable exercises (each with `questionCount`). */
export const getUnitDetail = async (unitId: Types.ObjectId): Promise<Record<string, unknown>> => {
  const unit = await Unit.findById(unitId).select("courseId").lean();
  const [visible] = unit ? await loadVisibleCourses({ _id: unit.courseId }) : [];
  const visibleUnit = visible?.units.find((candidate) => candidate._id.equals(unitId));
  if (!visible || !visibleUnit) {
    throw new ApiError(404, "Unit not found.", "UNIT_NOT_FOUND");
  }
  return {
    _id: visibleUnit._id,
    courseId: visible.course._id,
    courseName: visible.course.name,
    name: visibleUnit.name,
    orderIndex: visibleUnit.orderIndex,
    exercises: visibleUnit.exercises,
  };
};

export interface SpecializationSummary {
  _id: Types.ObjectId;
  name: string;
  slug: string;
  iconUrl?: string;
  publishedCourseCount: number;
}

/** Domains that have at least one visible course, sorted by name. */
export const listSpecializationSummaries = async (): Promise<SpecializationSummary[]> => {
  const countById = new Map<string, number>();
  for (const { course } of await loadVisibleCourses({})) {
    const key = course.specializationId.toString();
    countById.set(key, (countById.get(key) ?? 0) + 1);
  }

  const specializations = await Specialization.find({ _id: { $in: [...countById.keys()] } }).sort({
    name: 1,
  });
  return specializations.map((specialization) => ({
    _id: specialization._id,
    name: specialization.name,
    slug: specialization.slug,
    ...(specialization.iconUrl ? { iconUrl: specialization.iconUrl } : {}),
    publishedCourseCount: countById.get(specialization._id.toString()) ?? 0,
  }));
};

export interface LanguageSummary {
  code: string;
  publishedCourseCount: number;
}

/** Target languages of visible courses (optionally in one domain), most courses first. */
export const listLanguageSummaries = async (
  specializationId?: Types.ObjectId,
): Promise<LanguageSummary[]> => {
  const countByCode = new Map<string, number>();
  for (const { course } of await loadVisibleCourses(specializationId ? { specializationId } : {})) {
    countByCode.set(course.targetLanguage, (countByCode.get(course.targetLanguage) ?? 0) + 1);
  }
  return [...countByCode.entries()]
    .map(([code, publishedCourseCount]) => ({ code, publishedCourseCount }))
    .sort((a, b) => b.publishedCourseCount - a.publishedCourseCount || a.code.localeCompare(b.code));
};
