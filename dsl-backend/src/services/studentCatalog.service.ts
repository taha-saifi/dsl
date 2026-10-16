import { Types } from "mongoose";

import Course from "../models/Course";
import Specialization from "../models/Specialization";

/**
 * Which courses a student can see. For now that's `isPublished: true`;
 * slice 3 (feat-published-content-api) tightens it to courses with at least
 * one playable exercise, here, for every `/learn` endpoint at once.
 */
const visibleCourseMatch = (extra: Record<string, unknown> = {}): Record<string, unknown> => ({
  isPublished: true,
  ...extra,
});

export interface SpecializationSummary {
  _id: Types.ObjectId;
  name: string;
  slug: string;
  iconUrl?: string;
  publishedCourseCount: number;
}

/** Domains that have at least one visible course, sorted by name. */
export const listSpecializationSummaries = async (): Promise<SpecializationSummary[]> => {
  const counts = await Course.aggregate<{ _id: Types.ObjectId; count: number }>([
    { $match: visibleCourseMatch() },
    { $group: { _id: "$specializationId", count: { $sum: 1 } } },
  ]);
  const countById = new Map(counts.map((entry) => [entry._id.toString(), entry.count]));

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
  const counts = await Course.aggregate<{ _id: string; count: number }>([
    { $match: visibleCourseMatch(specializationId ? { specializationId } : {}) },
    { $group: { _id: "$targetLanguage", count: { $sum: 1 } } },
    { $sort: { count: -1, _id: 1 } },
  ]);
  return counts.map((entry) => ({ code: entry._id, publishedCourseCount: entry.count }));
};
