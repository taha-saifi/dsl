import { model, Schema, Types } from "mongoose";

export interface ICourse {
  specializationId: Types.ObjectId;
  thumbnailMediaId?: Types.ObjectId;
  name: string;
  sourceLanguage: string;
  targetLanguage: string;
  description?: string;
  isPublished: boolean;
  createdAt: Date;
  updatedAt: Date;
}

const courseSchema = new Schema<ICourse>(
  {
    specializationId: {
      type: Schema.Types.ObjectId,
      ref: "Specialization",
      required: true,
    },
    thumbnailMediaId: {
      type: Schema.Types.ObjectId,
    },
    name: {
      type: String,
      required: true,
      trim: true,
    },
    sourceLanguage: {
      type: String,
      required: true,
      lowercase: true,
      trim: true,
      match: /^[a-z]{2}$/,
    },
    targetLanguage: {
      type: String,
      required: true,
      lowercase: true,
      trim: true,
      match: /^[a-z]{2}$/,
    },
    description: {
      type: String,
      trim: true,
    },
    isPublished: {
      type: Boolean,
      default: false,
    },
  },
  { timestamps: true },
);

const Course = model<ICourse>("Course", courseSchema);

export default Course;
