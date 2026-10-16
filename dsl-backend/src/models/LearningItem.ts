import { model, Schema, Types } from "mongoose";

import { ApiError } from "../middleware/error.middleware";

export type LearningItemType = "word" | "phrase" | "sentence";

export interface ITranslation {
  language: string;
  text: string;
  pronunciation?: string;
  ipa?: string;
  audioMediaId?: Types.ObjectId;
}

export interface ILearningItem {
  createdBy: Types.ObjectId;
  imageMediaId?: Types.ObjectId | null;
  type: LearningItemType;
  translations: ITranslation[];
  createdAt: Date;
  updatedAt: Date;
}

const translationSchema = new Schema<ITranslation>(
  {
    language: {
      type: String,
      required: true,
      lowercase: true,
      trim: true,
      match: /^[a-z]{2}$/,
    },
    text: {
      type: String,
      required: true,
      trim: true,
    },
    pronunciation: {
      type: String,
      trim: true,
    },
    ipa: {
      type: String,
      trim: true,
    },
    audioMediaId: {
      type: Schema.Types.ObjectId,
      ref: "Media",
    },
  },
  { _id: false },
);

const learningItemSchema = new Schema<ILearningItem>(
  {
    createdBy: {
      type: Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },
    imageMediaId: {
      type: Schema.Types.ObjectId,
      ref: "Media",
      default: null,
    },
    type: {
      type: String,
      enum: ["word", "phrase", "sentence"],
      required: true,
    },
    translations: {
      type: [translationSchema],
      default: [],
    },
  },
  { timestamps: true },
);

learningItemSchema.pre("save", function enforceUniqueTranslationLanguages() {
  const normalizedLanguages = this.translations.map((translation) => translation.language.toLowerCase());
  if (new Set(normalizedLanguages).size !== normalizedLanguages.length) {
    throw new ApiError(
      400,
      "Translation languages must be unique within a learning item.",
      "DUPLICATE_TRANSLATION_LANGUAGE",
    );
  }
});

const LearningItem = model<ILearningItem>("LearningItem", learningItemSchema);

export default LearningItem;
