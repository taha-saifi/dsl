import { Types } from "mongoose";

import { publicMediaUrl } from "../config/storage";
import LearningItem, { type ILearningItem, type ITranslation } from "../models/LearningItem";
import Media from "../models/Media";
import Question, { type IQuestion, type IQuestionItem } from "../models/Question";

/*
 * Everything needed to show or check a question, resolved from its learning
 * items. Answers are never stored: they're derived here from translations
 * (docs/data-model/question-types.md, "How a client derives the answer").
 * The play payload (slice 6) and answer checking (slice 7) both build on it.
 */

type LeanItem = ILearningItem & { _id: Types.ObjectId };
export type LeanQuestion = IQuestion & { _id: Types.ObjectId };

export interface ResolvedQuestion {
  question: LeanQuestion;
  config: Record<string, unknown>;
  /** Items in `displayOrder`, with their learning item (missing if deleted). */
  items: { ref: IQuestionItem; item: LeanItem | undefined }[];
  mediaUrl: (mediaId: Types.ObjectId | null | undefined) => string | undefined;
}

export const configString = (config: Record<string, unknown>, key: string): string => {
  const value = config[key];
  return typeof value === "string" ? value.trim().toLowerCase() : "";
};

export const translationOf = (item: LeanItem | undefined, language: string): ITranslation | undefined =>
  language ? item?.translations.find((t) => t.language === language) : undefined;

export const textOf = (item: LeanItem | undefined, language: string): string | undefined =>
  translationOf(item, language)?.text;

export const targetOf = (resolved: ResolvedQuestion): LeanItem | undefined =>
  resolved.items.find(({ ref }) => ref.role === "target")?.item;

/** Same word rule as `questionValidation.service.ts` (`tokenizeWords`). */
export const tokenizeWords = (text: string): string[] =>
  text
    .split(/[^\p{L}\p{N}]+/u)
    .map((word) => word.trim())
    .filter((word) => word.length > 0);

/** Splits `sentence` around the first whole-word, case-insensitive `word`. */
export const splitAroundWord = (
  sentence: string,
  word: string,
): { before: string; after: string } | undefined => {
  const escaped = word.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
  const match = new RegExp(`(^|[^\\p{L}\\p{N}])(${escaped})(?=$|[^\\p{L}\\p{N}])`, "iu").exec(sentence);
  if (!match) {
    return undefined;
  }
  const start = match.index + (match[1]?.length ?? 0);
  return { before: sentence.slice(0, start), after: sentence.slice(start + (match[2]?.length ?? 0)) };
};

/** Loads an exercise's questions (by `orderIndex`) with their items and media, in three queries. */
export const resolveExerciseQuestions = async (exerciseId: Types.ObjectId): Promise<ResolvedQuestion[]> => {
  const questions = await Question.find({ exerciseId }).sort({ orderIndex: 1, _id: 1 }).lean<LeanQuestion[]>();
  const itemIds = [...new Set(questions.flatMap((q) => q.items.map((i) => i.learningItemId.toString())))];
  const items = await LearningItem.find({ _id: { $in: itemIds } }).lean<LeanItem[]>();
  const itemById = new Map(items.map((item) => [item._id.toString(), item]));

  const mediaIds = items.flatMap((item) => [
    ...(item.imageMediaId ? [item.imageMediaId] : []),
    ...item.translations.flatMap((t) => (t.audioMediaId ? [t.audioMediaId] : [])),
  ]);
  const media = await Media.find({ _id: { $in: mediaIds } }).select("storageKey").lean();
  const urlById = new Map(media.map((m) => [m._id.toString(), publicMediaUrl(m.storageKey)]));

  return questions.map((question) => ({
    question,
    config:
      typeof question.config === "object" && question.config !== null
        ? (question.config as Record<string, unknown>)
        : {},
    items: [...question.items]
      .sort((a, b) => a.displayOrder - b.displayOrder)
      .map((ref) => ({ ref, item: itemById.get(ref.learningItemId.toString()) })),
    mediaUrl: (mediaId) => (mediaId ? urlById.get(mediaId.toString()) : undefined),
  }));
};
