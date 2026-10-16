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
  questionText?: string;
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

/** Upper bound for `questionText`, counted in Unicode code points after trimming. */
export const QUESTION_TEXT_MAX_LENGTH = 300;

/** What a student sees above a question when the teacher wrote no `questionText`. */
export const defaultQuestionTexts: Record<QuestionType, string> = {
  choose_picture: "Choose the matching picture",
  multiple_choice: "Choose the correct translation",
  listening_transcribe: "Listen and type what you hear",
  listening_select: "Listen and choose what you hear",
  typing: "Type the translation",
  fill_blank: "Complete the sentence",
  arrange_sentence: "Arrange the words to form the sentence",
  matching: "Match each word to its translation",
};

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
    questionText: {
      type: String,
      trim: true,
    },
  },
  {
    timestamps: true,
    // Serialize `displayText` without also adding Mongoose's `id` virtual.
    id: false,
    toJSON: { virtuals: true },
  },
);

questionSchema.virtual("displayText").get(function (this: IQuestion): string {
  return this.questionText ?? defaultQuestionTexts[this.type];
});

const Question = model<IQuestion>("Question", questionSchema);

export default Question;
