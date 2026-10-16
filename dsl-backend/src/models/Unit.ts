import { model, Schema, Types } from "mongoose";

export interface ILearningItemReference {
  learningItemId: Types.ObjectId;
  order: number;
}

export interface IUnit {
  courseId: Types.ObjectId;
  name: string;
  orderIndex: number;
  isPublished: boolean;
  learningItems: ILearningItemReference[];
  createdAt: Date;
  updatedAt: Date;
}

const learningItemReferenceSchema = new Schema<ILearningItemReference>(
  {
    learningItemId: {
      type: Schema.Types.ObjectId,
      required: true,
    },
    order: {
      type: Number,
      required: true,
    },
  },
  { _id: false },
);

const unitSchema = new Schema<IUnit>(
  {
    courseId: {
      type: Schema.Types.ObjectId,
      ref: "Course",
      required: true,
    },
    name: {
      type: String,
      required: true,
      trim: true,
    },
    orderIndex: {
      type: Number,
      required: true,
    },
    isPublished: {
      type: Boolean,
      default: false,
    },
    learningItems: {
      type: [learningItemReferenceSchema],
      default: [],
    },
  },
  { timestamps: true },
);

const Unit = model<IUnit>("Unit", unitSchema);

export default Unit;
