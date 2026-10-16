import { model, Schema, Types } from "mongoose";

export type QuestionType =
  | "choose_picture"
  | "multiple_choice"
  | "listening_transcribe"
  | "listening_select"
  | "typing"
  | "fill_blank"
  | "arrange_sentence"
  | "matching";

export type QuestionItemRole = "target" | "distractor" | "pair";

export interface IQuestionItem {
  learningItemId: Types.ObjectId;
  role: QuestionItemRole;
  displayOrder: number;
}

export interface IQuestion {
  exerciseId: Types.ObjectId;
  type: QuestionType;
  orderIndex: number;
  config: unknown;
  points: number;
  items: IQuestionItem[];
  createdAt: Date;
  updatedAt: Date;
}

export const questionTypes: QuestionType[] = [
  "choose_picture",
  "multiple_choice",
  "listening_transcribe",
  "listening_select",
  "typing",
  "fill_blank",
  "arrange_sentence",
  "matching",
];

export const questionItemRoles: QuestionItemRole[] = ["target", "distractor", "pair"];

const questionItemSchema = new Schema<IQuestionItem>(
  {
    learningItemId: {
      type: Schema.Types.ObjectId,
      ref: "LearningItem",
      required: true,
    },
    role: {
      type: String,
      enum: questionItemRoles,
      required: true,
    },
    displayOrder: {
      type: Number,
      required: true,
    },
  },
  { _id: false },
);

const questionSchema = new Schema<IQuestion>(
  {
    exerciseId: {
      type: Schema.Types.ObjectId,
      ref: "Exercise",
      required: true,
    },
    type: {
      type: String,
      enum: questionTypes,
      required: true,
    },
    orderIndex: {
      type: Number,
      required: true,
    },
    config: {
      type: Schema.Types.Mixed,
      default: {},
    },
    points: {
      type: Number,
      default: 10,
    },
    items: {
      type: [questionItemSchema],
      default: [],
    },
  },
  { timestamps: true },
);

const Question = model<IQuestion>("Question", questionSchema);

export default Question;
