import { tokenize } from "@/lib/sentenceWords";
import type {
  LearningItem,
  Media,
  QuestionItem,
  QuestionType,
  Translation,
} from "@/types";

/**
 * Turns a question (saved or still being edited) plus its learning items into
 * exactly what a student would see. Answers are derived from translations the
 * same way the mobile app will (docs: question-types → "How a client derives
 * the answer"); nothing here is stored or sent to the server.
 *
 * Any piece that can't be derived yet (no target picked, missing translation)
 * comes back as `null`, and the renderer shows a placeholder in its place.
 */

export interface PreviewOption {
  key: string;
  text: string | null;
  imageUrl: string | null;
  correct: boolean;
}

interface PreviewBase {
  text: string;
}

export type QuestionPreviewModel =
  | (PreviewBase & {
      type: "choose_picture";
      prompt: string | null;
      options: PreviewOption[];
    })
  | (PreviewBase & {
      type: "multiple_choice";
      prompt: string | null;
      options: PreviewOption[];
    })
  | (PreviewBase & {
      type: "listening_select";
      hasAudio: boolean;
      options: PreviewOption[];
    })
  | (PreviewBase & {
      type: "listening_transcribe";
      hasAudio: boolean;
      answer: string | null;
      answerLanguage: string;
    })
  | (PreviewBase & {
      type: "typing";
      prompt: string | null;
      answer: string | null;
      answerLanguage: string;
    })
  | (PreviewBase & {
      type: "fill_blank";
      hint: string | null;
      /** The sentence split around the blank; `null` until it can be derived. */
      sentence: { before: string; after: string } | null;
      answer: string | null;
    })
  | (PreviewBase & {
      type: "arrange_sentence";
      hint: string | null;
      answerWords: string[];
      bank: string[];
    })
  | (PreviewBase & {
      type: "matching";
      sourceLanguage: string;
      targetLanguage: string;
      pairs: { key: string; source: string | null; target: string | null }[];
      /** Indexes into `pairs` giving the right column's shuffled order. */
      targetOrder: number[];
    });

export interface PreviewInput {
  type: QuestionType;
  config: Record<string, unknown>;
  items: QuestionItem[];
  text: string;
  itemsById: Record<string, LearningItem>;
  mediaById: Record<string, Media>;
}

function str(value: unknown): string {
  return typeof value === "string" ? value.toLowerCase() : "";
}

function translationOf(
  item: LearningItem | undefined,
  language: string,
): Translation | undefined {
  if (!item || !language) return undefined;
  return item.translations.find((t) => t.language.toLowerCase() === language);
}

function textOf(item: LearningItem | undefined, language: string) {
  return translationOf(item, language)?.text ?? null;
}

/** Stable pseudo-shuffle so options don't jump around while the teacher types. */
function stableShuffle<T>(values: T[], keyOf: (value: T, index: number) => string): T[] {
  const hash = (s: string) => {
    let h = 2166136261;
    for (let i = 0; i < s.length; i++) h = Math.imul(h ^ s.charCodeAt(i), 16777619);
    return h >>> 0;
  };
  return values
    .map((value, index) => ({ value, h: hash(keyOf(value, index)) }))
    .sort((a, b) => a.h - b.h)
    .map((entry) => entry.value);
}

export function buildPreviewModel(input: PreviewInput): QuestionPreviewModel {
  const { type, config, text, itemsById, mediaById } = input;
  const items = [...input.items].sort((a, b) => a.displayOrder - b.displayOrder);
  const target = items.find((it) => it.role === "target");
  const targetItem = target ? itemsById[target.learningItemId] : undefined;
  const distractors = items.filter((it) => it.role === "distractor");

  const optionsFrom = (pick: (item: LearningItem | undefined) => Omit<PreviewOption, "key" | "correct">) =>
    stableShuffle(
      [...(target ? [target] : []), ...distractors].map((it) => ({
        key: it.learningItemId,
        correct: it.role === "target",
        ...pick(itemsById[it.learningItemId]),
      })),
      (option) => option.key,
    );

  const imageOf = (item: LearningItem | undefined) =>
    item?.imageMediaId ? (mediaById[item.imageMediaId]?.url ?? null) : null;

  switch (type) {
    case "choose_picture": {
      const promptLanguage = str(config.promptLanguage);
      return {
        type,
        text,
        prompt: textOf(targetItem, promptLanguage),
        options: optionsFrom((item) => ({ text: null, imageUrl: imageOf(item) })),
      };
    }
    case "multiple_choice": {
      const answerLanguage = str(config.answerLanguage);
      return {
        type,
        text,
        prompt: textOf(targetItem, str(config.promptLanguage)),
        options: optionsFrom((item) => ({ text: textOf(item, answerLanguage), imageUrl: null })),
      };
    }
    case "listening_select": {
      const answerLanguage = str(config.answerLanguage);
      return {
        type,
        text,
        hasAudio: Boolean(translationOf(targetItem, str(config.audioLanguage))?.audioMediaId),
        options: optionsFrom((item) => ({ text: textOf(item, answerLanguage), imageUrl: null })),
      };
    }
    case "listening_transcribe": {
      const answerLanguage = str(config.answerLanguage);
      return {
        type,
        text,
        hasAudio: Boolean(translationOf(targetItem, str(config.audioLanguage))?.audioMediaId),
        answer: textOf(targetItem, answerLanguage),
        answerLanguage,
      };
    }
    case "typing": {
      const answerLanguage = str(config.answerLanguage);
      return {
        type,
        text,
        prompt: textOf(targetItem, str(config.promptLanguage)),
        answer: textOf(targetItem, answerLanguage),
        answerLanguage,
      };
    }
    case "fill_blank": {
      const sentence = textOf(targetItem, str(config.sentenceLanguage));
      const blankWord = typeof config.blankWord === "string" ? config.blankWord.trim() : "";
      return {
        type,
        text,
        hint: textOf(targetItem, str(config.promptLanguage)),
        sentence: sentence && blankWord ? splitAroundWord(sentence, blankWord) : null,
        answer: blankWord || null,
      };
    }
    case "arrange_sentence": {
      const sentence = textOf(targetItem, str(config.sentenceLanguage));
      const blocks = Array.isArray(config.wordBlocks)
        ? config.wordBlocks.filter((w): w is string => typeof w === "string")
        : [];
      return {
        type,
        text,
        hint: textOf(targetItem, str(config.promptLanguage)),
        answerWords: sentence ? tokenize(sentence) : [],
        bank: stableShuffle(blocks, (word, index) => `${word}#${index}`),
      };
    }
    case "matching": {
      const sourceLanguage = str(config.sourceLanguage);
      const targetLanguage = str(config.targetLanguage);
      const pairs = items.map((it) => ({
        key: it.learningItemId,
        source: textOf(itemsById[it.learningItemId], sourceLanguage),
        target: textOf(itemsById[it.learningItemId], targetLanguage),
      }));
      return {
        type,
        text,
        sourceLanguage,
        targetLanguage,
        pairs,
        targetOrder: stableShuffle(
          pairs.map((_, index) => index),
          (index) => `m:${pairs[index]?.key}`,
        ),
      };
    }
  }
}

/** Finds `word` as a whole word (case-insensitive) and splits the sentence around it. */
function splitAroundWord(sentence: string, word: string) {
  const escaped = word.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
  const match = new RegExp(`(^|[^\\p{L}\\p{N}])(${escaped})(?=$|[^\\p{L}\\p{N}])`, "iu").exec(sentence);
  if (!match) return null;
  const start = match.index + (match[1]?.length ?? 0);
  return {
    before: sentence.slice(0, start),
    after: sentence.slice(start + (match[2]?.length ?? 0)),
  };
}

