import { model, Schema, Types } from "mongoose";

export interface IExercise {
  unitId: Types.ObjectId;
  name: string;
  orderIndex: number;
  isPublished: boolean;
  createdAt: Date;
  updatedAt: Date;
}

const exerciseSchema = new Schema<IExercise>(
  {
    unitId: {
      type: Schema.Types.ObjectId,
      ref: "Unit",
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
  },
  { timestamps: true },
);

const Exercise = model<IExercise>("Exercise", exerciseSchema);

export default Exercise;
