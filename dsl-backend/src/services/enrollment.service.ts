import { Types } from "mongoose";

import Enrollment, { type IEnrollment } from "../models/Enrollment";
import { ensureCourseVisible } from "./studentCatalog.service";

const isDuplicateKeyError = (error: unknown): boolean =>
  typeof error === "object" && error !== null && "code" in error && error.code === 11000;

/**
 * Idempotent: enrolling twice keeps one document. `created` tells the
 * controller whether to answer 201 or 200. Only visible courses (404).
 */
export const enroll = async (
  studentId: Types.ObjectId,
  courseId: Types.ObjectId,
): Promise<{ enrollment: IEnrollment; created: boolean }> => {
  await ensureCourseVisible(courseId);

  const existing = await Enrollment.findOne({ studentId, courseId });
  if (existing) {
    return { enrollment: existing, created: false };
  }
  try {
    return { enrollment: await Enrollment.create({ studentId, courseId }), created: true };
  } catch (error: unknown) {
    // Two taps at once: the unique index let one through; return that one.
    const winner = isDuplicateKeyError(error) ? await Enrollment.findOne({ studentId, courseId }) : null;
    if (winner) {
      return { enrollment: winner, created: false };
    }
    throw error;
  }
};

/** Idempotent; works even if the course has since been hidden. */
export const unenroll = async (studentId: Types.ObjectId, courseId: Types.ObjectId): Promise<void> => {
  await Enrollment.deleteOne({ studentId, courseId });
};
