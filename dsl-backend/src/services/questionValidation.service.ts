import { Types } from "mongoose";

import { ApiError } from "../middleware/error.middleware";
import type { ILearningItem, ITranslation } from "../models/LearningItem";
import type { IQuestionItem, QuestionType } from "../models/Question";

type ReferenceQuestionType =
  | "choose_picture"
  | "multiple_choice"
  | "listening_transcribe"
  | "listening_select"
  | "typing";

type ItemScope = "none" | "targetOnly" | "targetAndDistractors";

interface ReferenceQuestionTypeRule {
  targetCount: number;
  distractorMin: number;
  distractorMax: number | null;
  requiredConfigFields: readonly string[];
  imageRequiredFor: ItemScope;
  promptTranslationRequiredFor: ItemScope;
  audioTranslationRequiredFor: ItemScope;
  answerTranslationRequiredFor: ItemScope;
}

const referenceQuestionTypeRules: Record<ReferenceQuestionType, ReferenceQuestionTypeRule> = {
  choose_picture: {
    targetCount: 1,
    distractorMin: 1,
    distractorMax: null,
    requiredConfigFields: ["promptLanguage"],
    imageRequiredFor: "targetAndDistractors",
    promptTranslationRequiredFor: "targetOnly",
    audioTranslationRequiredFor: "none",
    answerTranslationRequiredFor: "none",
  },
  multiple_choice: {
    targetCount: 1,
    distractorMin: 1,
    distractorMax: null,
    requiredConfigFields: ["promptLanguage", "answerLanguage"],
    imageRequiredFor: "none",
    promptTranslationRequiredFor: "targetOnly",
    audioTranslationRequiredFor: "none",
    answerTranslationRequiredFor: "targetAndDistractors",
  },
  listening_transcribe: {
    targetCount: 1,
    distractorMin: 0,
    distractorMax: 0,
    requiredConfigFields: ["audioLanguage", "answerLanguage"],
    imageRequiredFor: "none",
    promptTranslationRequiredFor: "none",
    audioTranslationRequiredFor: "targetOnly",
    answerTranslationRequiredFor: "targetOnly",
  },
  listening_select: {
    targetCount: 1,
    distractorMin: 1,
    distractorMax: null,
    requiredConfigFields: ["audioLanguage", "answerLanguage"],
    imageRequiredFor: "none",
    promptTranslationRequiredFor: "none",
    audioTranslationRequiredFor: "targetOnly",
    answerTranslationRequiredFor: "targetAndDistractors",
  },
  typing: {
    targetCount: 1,
    distractorMin: 0,
    distractorMax: 0,
    requiredConfigFields: ["promptLanguage", "answerLanguage"],
    imageRequiredFor: "none",
    promptTranslationRequiredFor: "targetOnly",
    audioTranslationRequiredFor: "none",
    answerTranslationRequiredFor: "targetOnly",
  },
};

const buildCardinalityMessage = (type: QuestionType, rule: ReferenceQuestionTypeRule): string => {
  const distractorPart =
    rule.distractorMax === 0
      ? "no distractor items"
      : rule.distractorMin > 0
        ? `at least ${rule.distractorMin} distractor item(s)`
        : "any number of distractor items";

  return `${type} questions require exactly ${rule.targetCount} target item(s), ${distractorPart}, and no pair items.`;
};

const getConfigRecord = (type: QuestionType, config: unknown): Record<string, unknown> => {
  const value = config ?? {};
  if (typeof value !== "object" || value === null || Array.isArray(value)) {
    throw new ApiError(400, `config is required for ${type} questions.`, "MISSING_CONFIG_FIELD");
  }

  return value as Record<string, unknown>;
};

const getLearningItemDoc = (
  learningItemId: Types.ObjectId,
  learningItemDocsById: Map<string, ILearningItem>,
): ILearningItem => {
  const learningItem = learningItemDocsById.get(learningItemId.toString());
  if (!learningItem) {
    throw new ApiError(404, "Learning item not found.", "LEARNING_ITEM_NOT_FOUND");
  }

  return learningItem;
};

const requireImage = (
  type: QuestionType,
  role: "target" | "distractor",
  learningItemId: Types.ObjectId,
  learningItem: ILearningItem,
): void => {
  if (!learningItem.imageMediaId) {
    throw new ApiError(
      400,
      `The ${role} learning item ${learningItemId.toString()} must have an imageMediaId set for ${type} questions.`,
      "ITEM_MISSING_IMAGE",
    );
  }
};

const requireTranslation = (
  type: QuestionType,
  role: "target" | "distractor" | "pair",
  learningItemId: Types.ObjectId,
  learningItem: ILearningItem,
  language: string,
  configField: string,
): ITranslation => {
  const translation = learningItem.translations.find(
    (item) => item.language === language.toLowerCase(),
  );
  if (!translation) {
    throw new ApiError(
      400,
      `The ${role} learning item ${learningItemId.toString()} is missing a "${language}" translation required by ${configField} for ${type} questions.`,
      "ITEM_MISSING_TRANSLATION",
    );
  }

  return translation;
};

const requireAudio = (
  type: QuestionType,
  role: "target",
  learningItemId: Types.ObjectId,
  translation: ITranslation,
  language: string,
): void => {
  if (!translation.audioMediaId) {
    throw new ApiError(
      400,
      `The ${role} learning item ${learningItemId.toString()}'s "${language}" translation must have audioMediaId set for ${type} questions.`,
      "ITEM_MISSING_AUDIO",
    );
  }
};

type SentenceQuestionType = "fill_blank" | "arrange_sentence";

const sentenceQuestionBaseConfigFields: readonly string[] = ["promptLanguage", "sentenceLanguage"];

const tokenizeWords = (text: string): string[] =>
  text
    .split(/[^\p{L}\p{N}]+/u)
    .map((word) => word.trim())
    .filter((word) => word.length > 0);

const countMultiset = (words: string[]): Map<string, number> => {
  const counts = new Map<string, number>();
  for (const word of words) {
    counts.set(word, (counts.get(word) ?? 0) + 1);
  }

  return counts;
};

const validateSentenceQuestionCardinality = (
  type: SentenceQuestionType,
  items: IQuestionItem[],
): IQuestionItem => {
  const targets = items.filter((item) => item.role === "target");
  const nonTargetItems = items.filter((item) => item.role !== "target");
  const target = targets[0];

  if (targets.length !== 1 || nonTargetItems.length !== 0 || !target) {
    throw new ApiError(
      400,
      `${type} questions require exactly 1 target item and no distractor or pair items.`,
      "INVALID_ITEM_CARDINALITY",
    );
  }

  return target;
};

const validateFillBlankWord = (
  configRecord: Record<string, unknown>,
  sentenceTranslation: ITranslation,
  sentenceLanguage: string,
): void => {
  const blankWordValue = configRecord.blankWord;
  if (typeof blankWordValue !== "string" || blankWordValue.trim() === "") {
    throw new ApiError(400, "config.blankWord is required for fill_blank questions.", "MISSING_CONFIG_FIELD");
  }
  const blankWord = blankWordValue.trim().toLowerCase();

  const sentenceWords = tokenizeWords(sentenceTranslation.text).map((word) => word.toLowerCase());
  if (!sentenceWords.includes(blankWord)) {
    throw new ApiError(
      400,
      `config.blankWord "${blankWordValue.trim()}" does not appear as a whole word in the target learning item's "${sentenceLanguage}" translation.`,
      "BLANK_WORD_NOT_IN_SENTENCE",
    );
  }
};

const validateArrangeSentenceWordBlocks = (
  configRecord: Record<string, unknown>,
  sentenceTranslation: ITranslation,
  sentenceLanguage: string,
): void => {
  const wordBlocksValue = configRecord.wordBlocks;
  if (
    !Array.isArray(wordBlocksValue) ||
    wordBlocksValue.length === 0 ||
    !wordBlocksValue.every((word) => typeof word === "string" && word.trim() !== "")
  ) {
    throw new ApiError(
      400,
      "config.wordBlocks is required and must be a non-empty array of non-empty strings for arrange_sentence questions.",
      "MISSING_CONFIG_FIELD",
    );
  }
  const wordBlocks = wordBlocksValue.map((word) => word.trim().toLowerCase());

  const sentenceWords = tokenizeWords(sentenceTranslation.text).map((word) => word.toLowerCase());
  const sentenceWordCounts = countMultiset(sentenceWords);
  const wordBlockCounts = countMultiset(wordBlocks);

  for (const [word, count] of sentenceWordCounts) {
    if ((wordBlockCounts.get(word) ?? 0) < count) {
      throw new ApiError(
        400,
        `config.wordBlocks is missing the word "${word}" needed to arrange the target learning item's "${sentenceLanguage}" translation.`,
        "WORD_BLOCKS_MISSING_WORD",
      );
    }
  }

  if (wordBlocks.length === sentenceWords.length) {
    throw new ApiError(
      400,
      "config.wordBlocks must include at least one distractor word beyond what the sentence requires.",
      "WORD_BLOCKS_NO_DISTRACTOR",
    );
  }
};

const validateSentenceQuestion = (
  type: SentenceQuestionType,
  config: unknown,
  items: IQuestionItem[],
  learningItemDocsById: Map<string, ILearningItem>,
): void => {
  const target = validateSentenceQuestionCardinality(type, items);

  const configRecord = getConfigRecord(type, config);
  for (const field of sentenceQuestionBaseConfigFields) {
    const value = configRecord[field];
    if (typeof value !== "string" || value.trim() === "") {
      throw new ApiError(400, `config.${field} is required for ${type} questions.`, "MISSING_CONFIG_FIELD");
    }
  }

  const promptLanguage = configRecord.promptLanguage as string;
  const sentenceLanguage = configRecord.sentenceLanguage as string;
  const targetItem = getLearningItemDoc(target.learningItemId, learningItemDocsById);

  requireTranslation(type, "target", target.learningItemId, targetItem, promptLanguage, "promptLanguage");
  const sentenceTranslation = requireTranslation(
    type,
    "target",
    target.learningItemId,
    targetItem,
    sentenceLanguage,
    "sentenceLanguage",
  );

  if (type === "fill_blank") {
    validateFillBlankWord(configRecord, sentenceTranslation, sentenceLanguage);
  } else {
    validateArrangeSentenceWordBlocks(configRecord, sentenceTranslation, sentenceLanguage);
  }
};

const validateMatchingQuestion = (
  config: unknown,
  items: IQuestionItem[],
  learningItemDocsById: Map<string, ILearningItem>,
): void => {
  const nonPairItems = items.filter((item) => item.role !== "pair");
  if (items.length < 2 || nonPairItems.length > 0) {
    throw new ApiError(
      400,
      'matching questions require at least 2 items, and every item\'s role must be "pair".',
      "INVALID_ITEM_CARDINALITY",
    );
  }

  const configRecord = getConfigRecord("matching", config);
  for (const field of ["sourceLanguage", "targetLanguage"]) {
    const value = configRecord[field];
    if (typeof value !== "string" || value.trim() === "") {
      throw new ApiError(400, `config.${field} is required for matching questions.`, "MISSING_CONFIG_FIELD");
    }
  }

  const sourceLanguage = configRecord.sourceLanguage as string;
  const targetLanguage = configRecord.targetLanguage as string;

  for (const item of items) {
    const learningItem = getLearningItemDoc(item.learningItemId, learningItemDocsById);
    requireTranslation("matching", "pair", item.learningItemId, learningItem, sourceLanguage, "sourceLanguage");
    requireTranslation("matching", "pair", item.learningItemId, learningItem, targetLanguage, "targetLanguage");
  }
};

export const validateQuestionForType = (
  type: QuestionType,
  config: unknown,
  items: IQuestionItem[],
  learningItemDocsById: Map<string, ILearningItem>,
): void => {
  if (type === "fill_blank" || type === "arrange_sentence") {
    validateSentenceQuestion(type, config, items, learningItemDocsById);
    return;
  }
  if (type === "matching") {
    validateMatchingQuestion(config, items, learningItemDocsById);
    return;
  }

  const rule = referenceQuestionTypeRules[type as ReferenceQuestionType];

  const targets = items.filter((item) => item.role === "target");
  const distractors = items.filter((item) => item.role === "distractor");
  const pairs = items.filter((item) => item.role === "pair");
  const distractorCountValid =
    distractors.length >= rule.distractorMin &&
    (rule.distractorMax === null || distractors.length <= rule.distractorMax);

  if (targets.length !== rule.targetCount || pairs.length !== 0 || !distractorCountValid) {
    throw new ApiError(400, buildCardinalityMessage(type, rule), "INVALID_ITEM_CARDINALITY");
  }

  const configRecord = getConfigRecord(type, config);
  for (const field of rule.requiredConfigFields) {
    const value = configRecord[field];
    if (typeof value !== "string" || value.trim() === "") {
      throw new ApiError(
        400,
        `config.${field} is required for ${type} questions.`,
        "MISSING_CONFIG_FIELD",
      );
    }
  }

  const target = targets[0];
  if (!target) {
    throw new ApiError(400, buildCardinalityMessage(type, rule), "INVALID_ITEM_CARDINALITY");
  }
  const targetItem = getLearningItemDoc(target.learningItemId, learningItemDocsById);

  if (rule.imageRequiredFor !== "none") {
    requireImage(type, "target", target.learningItemId, targetItem);
  }
  if (rule.promptTranslationRequiredFor !== "none") {
    requireTranslation(
      type,
      "target",
      target.learningItemId,
      targetItem,
      configRecord.promptLanguage as string,
      "promptLanguage",
    );
  }
  if (rule.audioTranslationRequiredFor !== "none") {
    const translation = requireTranslation(
      type,
      "target",
      target.learningItemId,
      targetItem,
      configRecord.audioLanguage as string,
      "audioLanguage",
    );
    requireAudio(type, "target", target.learningItemId, translation, configRecord.audioLanguage as string);
  }
  if (rule.answerTranslationRequiredFor !== "none") {
    requireTranslation(
      type,
      "target",
      target.learningItemId,
      targetItem,
      configRecord.answerLanguage as string,
      "answerLanguage",
    );
  }

  if (rule.imageRequiredFor === "targetAndDistractors" || rule.answerTranslationRequiredFor === "targetAndDistractors") {
    for (const distractor of distractors) {
      const distractorItem = getLearningItemDoc(distractor.learningItemId, learningItemDocsById);
      if (rule.imageRequiredFor === "targetAndDistractors") {
        requireImage(type, "distractor", distractor.learningItemId, distractorItem);
      }
      if (rule.answerTranslationRequiredFor === "targetAndDistractors") {
        requireTranslation(
          type,
          "distractor",
          distractor.learningItemId,
          distractorItem,
          configRecord.answerLanguage as string,
          "answerLanguage",
        );
      }
    }
  }
};
