import { model, Schema, Types } from "mongoose";

/**
 * A student's explicit "Enroll Now" in a course. Referenced rather than
 * embedded in User: it has its own lifecycle and grows with use
 * (docs/decisions/adr-embed-vs-reference.md).
 */
export interface IEnrollment {
  studentId: Types.ObjectId;
  courseId: Types.ObjectId;
  enrolledAt: Date;
  completedAt?: Date;
}

const enrollmentSchema = new Schema<IEnrollment>({
  studentId: { type: Schema.Types.ObjectId, ref: "User", required: true },
  courseId: { type: Schema.Types.ObjectId, ref: "Course", required: true },
  enrolledAt: { type: Date, required: true, default: () => new Date() },
  completedAt: { type: Date },
});

enrollmentSchema.index({ studentId: 1, courseId: 1 }, { unique: true });
enrollmentSchema.index({ courseId: 1 });

const Enrollment = model<IEnrollment>("Enrollment", enrollmentSchema);

export default Enrollment;
