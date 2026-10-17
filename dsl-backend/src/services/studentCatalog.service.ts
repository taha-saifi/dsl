import { Types, type QueryFilter } from "mongoose";

import { publicMediaUrl } from "../config/storage";
import { ApiError } from "../middleware/error.middleware";
import Course, { type ICourse } from "../models/Course";
import Enrollment from "../models/Enrollment";
import Exercise from "../models/Exercise";
import Media from "../models/Media";
import {
  loadExerciseBests,
  loadLastActivity,
  progressOf,
  type ExerciseBest,
} from "./learnerProgress.service";
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
  /** Distinct, in the order they first appear (by question `orderIndex`). */
  questionTypes: string[];
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
  // Exercises are mixed-type, so collect each one's types in question order.
  const questionStats = await Question.aggregate<{ _id: Types.ObjectId; count: number; types: string[] }>([
    { $match: { exerciseId: { $in: exercises.map((e) => e._id) } } },
    { $sort: { orderIndex: 1, _id: 1 } },
    { $group: { _id: "$exerciseId", count: { $sum: 1 }, types: { $push: "$type" } } },
  ]);
  const statsByExercise = new Map(
    questionStats.map((q) => [q._id.toString(), { count: q.count, types: [...new Set(q.types)] }]),
  );

  const exercisesByUnit = new Map<string, VisibleExercise[]>();
  for (const exercise of exercises) {
    const stats = statsByExercise.get(exercise._id.toString());
    if (!stats || stats.count === 0) {
      continue;
    }
    const key = exercise.unitId.toString();
    const list = exercisesByUnit.get(key) ?? [];
    list.push({
      _id: exercise._id,
      name: exercise.name,
      orderIndex: exercise.orderIndex,
      questionCount: stats.count,
      questionTypes: stats.types,
    });
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

/** Throws 404 unless the course is visible to students. */
export const ensureCourseVisible = async (courseId: Types.ObjectId): Promise<void> => {
  const [visible] = await loadVisibleCourses({ _id: courseId });
  if (!visible) {
    throw new ApiError(404, "Course not found.", "COURSE_NOT_FOUND");
  }
};

/** The viewer, for per-student fields. Only students have enrollments. */
export interface Viewer {
  studentId?: Types.ObjectId;
}

const enrolledCourseIds = async (viewer: Viewer, courses: VisibleCourse[]): Promise<Map<string, Date>> => {
  if (!viewer.studentId || courses.length === 0) {
    return new Map();
  }
  const enrollments = await Enrollment.find({
    studentId: viewer.studentId,
    courseId: { $in: courses.map(({ course }) => course._id) },
  })
    .select("courseId enrolledAt")
    .lean();
  return new Map(enrollments.map((e) => [e.courseId.toString(), e.enrolledAt]));
};

const specializationNames = async (courses: VisibleCourse[]): Promise<Map<string, string>> => {
  const ids = [...new Set(courses.map(({ course }) => course.specializationId.toString()))];
  const specializations = await Specialization.find({ _id: { $in: ids } }).select("name").lean();
  return new Map(specializations.map((s) => [s._id.toString(), s.name]));
};

interface SummaryContext {
  thumbnails: Map<string, string>;
  domainNames: Map<string, string>;
  enrolled: Map<string, Date>;
  /** Best completed session per exercise; undefined when the viewer isn't a student. */
  bests: Map<string, ExerciseBest> | undefined;
}

const allExerciseIds = (courses: VisibleCourse[]): Types.ObjectId[] =>
  courses.flatMap(({ units }) => units.flatMap((unit) => unit.exercises.map((e) => e._id)));

const loadSummaryContext = async (viewer: Viewer, courses: VisibleCourse[]): Promise<SummaryContext> => {
  const [thumbnails, domainNames, enrolled, bests] = await Promise.all([
    thumbnailUrls(courses),
    specializationNames(courses),
    enrolledCourseIds(viewer, courses),
    viewer.studentId ? loadExerciseBests(viewer.studentId, allExerciseIds(courses)) : undefined,
  ]);
  return { thumbnails, domainNames, enrolled, bests };
};

/** The first exercise (in unit, then exercise order) the student hasn't completed. */
const nextExercise = (
  units: VisibleUnit[],
  bests: Map<string, ExerciseBest>,
): { unitId: Types.ObjectId; exerciseId: Types.ObjectId } | undefined => {
  for (const unit of units) {
    const exercise = unit.exercises.find((e) => !bests.has(e._id.toString()));
    if (exercise) {
      return { unitId: unit._id, exerciseId: exercise._id };
    }
  }
  return undefined;
};

/** Students only: `progress` and where Continue goes (null when everything is done). */
const progressFields = (units: VisibleUnit[], bests: Map<string, ExerciseBest> | undefined): Record<string, unknown> => {
  if (!bests) {
    return {};
  }
  const next = nextExercise(units, bests);
  return {
    progress: progressOf(
      units.flatMap((unit) => unit.exercises.map((e) => e._id)),
      bests,
    ),
    nextUnitId: next?.unitId ?? null,
    nextExerciseId: next?.exerciseId ?? null,
  };
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
  { thumbnails, domainNames, enrolled, bests }: SummaryContext,
): Record<string, unknown> => {
  const thumbnailUrl = course.thumbnailMediaId ? thumbnails.get(course.thumbnailMediaId.toString()) : undefined;
  const enrolledAt = enrolled.get(course._id.toString());
  return {
    _id: course._id,
    specializationId: course.specializationId,
    specializationName: domainNames.get(course.specializationId.toString()) ?? "",
    name: course.name,
    ...(course.description ? { description: course.description } : {}),
    sourceLanguage: course.sourceLanguage,
    targetLanguage: course.targetLanguage,
    ...(thumbnailUrl ? { thumbnailUrl } : {}),
    unitCount: units.length,
    exerciseCount: units.reduce((sum, unit) => sum + unit.exercises.length, 0),
    isEnrolled: enrolledAt !== undefined,
    ...(enrolledAt ? { enrolledAt } : {}),
    ...progressFields(units, bests),
  };
};

const escapeRegExp = (value: string): string => value.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");

export interface CourseFilters {
  specializationId?: Types.ObjectId;
  targetLanguage?: string;
  search?: string;
}

export const listCourseSummaries = async (
  filters: CourseFilters,
  viewer: Viewer,
): Promise<Record<string, unknown>[]> => {
  const visible = await loadVisibleCourses({
    ...(filters.specializationId ? { specializationId: filters.specializationId } : {}),
    ...(filters.targetLanguage ? { targetLanguage: filters.targetLanguage } : {}),
    ...(filters.search ? { name: { $regex: escapeRegExp(filters.search), $options: "i" } } : {}),
  });
  const context = await loadSummaryContext(viewer, visible);
  return visible.map((entry) => courseSummary(entry, context));
};

/** A visible course with its visible units (each with `exerciseCount`). */
export const getCourseDetail = async (
  courseId: Types.ObjectId,
  viewer: Viewer,
): Promise<Record<string, unknown>> => {
  const [visible] = await loadVisibleCourses({ _id: courseId });
  if (!visible) {
    throw new ApiError(404, "Course not found.", "COURSE_NOT_FOUND");
  }
  const context = await loadSummaryContext(viewer, [visible]);
  return {
    ...courseSummary(visible, context),
    units: visible.units.map((unit) => ({
      _id: unit._id,
      name: unit.name,
      orderIndex: unit.orderIndex,
      exerciseCount: unit.exercises.length,
      ...(context.bests
        ? { progress: progressOf(unit.exercises.map((e) => e._id), context.bests) }
        : {}),
    })),
  };
};

/**
 * A visible unit with its playable exercises (each with `questionCount`).
 * For students: unit `progress`, `nextExerciseId`, and per exercise
 * `status` (`not_started` | `completed`) with the best score.
 */
export const getUnitDetail = async (unitId: Types.ObjectId, viewer: Viewer): Promise<Record<string, unknown>> => {
  const unit = await Unit.findById(unitId).select("courseId").lean();
  const [visible] = unit ? await loadVisibleCourses({ _id: unit.courseId }) : [];
  const visibleUnit = visible?.units.find((candidate) => candidate._id.equals(unitId));
  if (!visible || !visibleUnit) {
    throw new ApiError(404, "Unit not found.", "UNIT_NOT_FOUND");
  }
  const bests = viewer.studentId
    ? await loadExerciseBests(
        viewer.studentId,
        visibleUnit.exercises.map((e) => e._id),
      )
    : undefined;
  return {
    _id: visibleUnit._id,
    courseId: visible.course._id,
    courseName: visible.course.name,
    name: visibleUnit.name,
    orderIndex: visibleUnit.orderIndex,
    exercises: visibleUnit.exercises.map((exercise) => {
      const best = bests?.get(exercise._id.toString());
      return {
        ...exercise,
        ...(bests ? { status: best ? "completed" : "not_started" } : {}),
        ...(best ? { bestScore: best.bestScore, bestMaxScore: best.bestMaxScore, bestPercent: best.bestPercent } : {}),
      };
    }),
    ...(bests
      ? {
          progress: progressOf(
            visibleUnit.exercises.map((e) => e._id),
            bests,
          ),
          nextExerciseId: visibleUnit.exercises.find((e) => !bests.has(e._id.toString()))?._id ?? null,
        }
      : {}),
  };
};

/**
 * The student's enrolled courses that are still visible, most recently
 * active first (last exercise started, else enrollment date). Courses that
 * stopped being visible drop out (Q5); their enrollment is kept.
 */
export const listEnrolledCourses = async (studentId: Types.ObjectId): Promise<Record<string, unknown>[]> => {
  const enrollments = await Enrollment.find({ studentId }).sort({ enrolledAt: -1 }).select("courseId enrolledAt").lean();
  if (enrollments.length === 0) {
    return [];
  }
  const visible = await loadVisibleCourses({ _id: { $in: enrollments.map((e) => e.courseId) } });
  const byId = new Map(visible.map((entry) => [entry.course._id.toString(), entry]));
  const [context, lastActivity] = await Promise.all([
    loadSummaryContext({ studentId }, visible),
    loadLastActivity(
      studentId,
      visible.map((entry) => entry.course._id),
    ),
  ]);
  const rows = enrollments.flatMap((enrollment) => {
    const entry = byId.get(enrollment.courseId.toString());
    if (!entry) return [];
    const key = entry.course._id.toString();
    const lastActivityAt = lastActivity.get(key) ?? enrollment.enrolledAt;
    return [{ ...courseSummary(entry, context), lastActivityAt }];
  });
  return rows.sort((a, b) => b.lastActivityAt.getTime() - a.lastActivityAt.getTime());
};

export interface PlayableExercise {
  _id: Types.ObjectId;
  name: string;
  unitId: Types.ObjectId;
  unitName: string;
  courseId: Types.ObjectId;
  courseName: string;
}

/** The exercise if a student can play it (visible all the way up), else 404. */
export const getPlayableExercise = async (exerciseId: Types.ObjectId): Promise<PlayableExercise> => {
  const exercise = await Exercise.findById(exerciseId).select("unitId").lean();
  const unit = exercise ? await Unit.findById(exercise.unitId).select("courseId").lean() : null;
  const [visible] = unit ? await loadVisibleCourses({ _id: unit.courseId }) : [];
  for (const visibleUnit of visible?.units ?? []) {
    const match = visibleUnit.exercises.find((candidate) => candidate._id.equals(exerciseId));
    if (visible && match) {
      return {
        _id: match._id,
        name: match.name,
        unitId: visibleUnit._id,
        unitName: visibleUnit.name,
        courseId: visible.course._id,
        courseName: visible.course.name,
      };
    }
  }
  throw new ApiError(404, "Exercise not found.", "EXERCISE_NOT_FOUND");
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
