import { createHmac, randomInt } from "node:crypto";

import { config } from "../config/config";
import { defaultQuestionTexts } from "../models/Question";
import {
  configString,
  splitAroundWord,
  targetOf,
  textOf,
  translationOf,
  type ResolvedQuestion,
} from "./questionContent.service";

/*
 * What a student gets to play a question: everything needed to render it and
 * nothing that gives the answer away (docs/mobile/features/feat-exercise-player.md):
 * - choices are shuffled on every request and none is marked correct;
 * - option, word and matching ids are opaque HMACs, never learning-item ids,
 *   and a matching pair's left and right ids differ;
 * - typing / listening never include the expected text; fill_blank withholds
 *   the blank word; arrange_sentence's bank is shuffled.
 * The ids are stable, so answer checking (slice 7) recomputes them instead of
 * storing anything.
 */

/** Opaque, stable id for one choice of one question. */
export const choiceId = (questionId: string, kind: string, value: string): string =>
  createHmac("sha256", config.jwtSecret)
    .update(`play:${questionId}:${kind}:${value}`)
    .digest("base64url")
    .slice(0, 16);

const shuffle = <T>(values: T[]): T[] => {
  const result = [...values];
  for (let i = result.length - 1; i > 0; i--) {
    const j = randomInt(i + 1);
    [result[i], result[j]] = [result[j] as T, result[i] as T];
  }
  return result;
};

export type PlayQuestion = Record<string, unknown> & { id: string; type: string };

/** Learning-item roles that become answer choices: the target and its distractors. */
const choiceItems = (resolved: ResolvedQuestion) =>
  resolved.items.filter(({ ref }) => ref.role === "target" || ref.role === "distractor");

/**
 * Builds one question's payload, or `undefined` if its content is broken
 * (e.g. a referenced learning item or its audio was deleted). Broken
 * questions are left out rather than shown half-rendered.
 */
export const buildPlayQuestion = (resolved: ResolvedQuestion): PlayQuestion | undefined => {
  const { question, config: cfg } = resolved;
  const id = question._id.toString();
  const base = {
    id,
    type: question.type,
    displayText: question.questionText ?? defaultQuestionTexts[question.type],
    points: question.points,
  };
  const target = targetOf(resolved);
  const textChoices = (language: string) => {
    const options = choiceItems(resolved).map(({ ref, item }) => ({
      id: choiceId(id, "option", ref.learningItemId.toString()),
      text: textOf(item, language),
    }));
    return options.every((o) => o.text) ? shuffle(options) : undefined;
  };

  switch (question.type) {
    case "choose_picture": {
      const prompt = textOf(target, configString(cfg, "promptLanguage"));
      const options = choiceItems(resolved).map(({ ref, item }) => ({
        id: choiceId(id, "option", ref.learningItemId.toString()),
        imageUrl: resolved.mediaUrl(item?.imageMediaId),
      }));
      if (!prompt || !options.every((o) => o.imageUrl)) return undefined;
      return { ...base, prompt, options: shuffle(options) };
    }
    case "multiple_choice": {
      const promptLanguage = configString(cfg, "promptLanguage");
      const answerLanguage = configString(cfg, "answerLanguage");
      const prompt = textOf(target, promptLanguage);
      const options = textChoices(answerLanguage);
      if (!prompt || !options) return undefined;
      const imageUrl = resolved.mediaUrl(target?.imageMediaId);
      return { ...base, prompt, promptLanguage, answerLanguage, ...(imageUrl ? { imageUrl } : {}), options };
    }
    case "listening_select": {
      const answerLanguage = configString(cfg, "answerLanguage");
      const audioUrl = resolved.mediaUrl(translationOf(target, configString(cfg, "audioLanguage"))?.audioMediaId);
      const options = textChoices(answerLanguage);
      if (!audioUrl || !options) return undefined;
      return { ...base, audioUrl, answerLanguage, options };
    }
    case "typing": {
      const promptLanguage = configString(cfg, "promptLanguage");
      const answerLanguage = configString(cfg, "answerLanguage");
      const prompt = textOf(target, promptLanguage);
      if (!prompt || !textOf(target, answerLanguage)) return undefined;
      const imageUrl = resolved.mediaUrl(target?.imageMediaId);
      return { ...base, prompt, promptLanguage, answerLanguage, ...(imageUrl ? { imageUrl } : {}) };
    }
    case "listening_transcribe": {
      const answerLanguage = configString(cfg, "answerLanguage");
      const audioUrl = resolved.mediaUrl(translationOf(target, configString(cfg, "audioLanguage"))?.audioMediaId);
      if (!audioUrl || !textOf(target, answerLanguage)) return undefined;
      return { ...base, audioUrl, answerLanguage };
    }
    case "fill_blank": {
      const sentenceLanguage = configString(cfg, "sentenceLanguage");
      const sentence = textOf(target, sentenceLanguage);
      const blankWord = typeof cfg.blankWord === "string" ? cfg.blankWord.trim() : "";
      const split = sentence && blankWord ? splitAroundWord(sentence, blankWord) : undefined;
      if (!split) return undefined;
      const hint = textOf(target, configString(cfg, "promptLanguage"));
      return { ...base, sentenceLanguage, before: split.before, after: split.after, ...(hint ? { hint } : {}) };
    }
    case "arrange_sentence": {
      const sentenceLanguage = configString(cfg, "sentenceLanguage");
      const blocks = Array.isArray(cfg.wordBlocks)
        ? cfg.wordBlocks.filter((w): w is string => typeof w === "string")
        : [];
      if (!textOf(target, sentenceLanguage) || blocks.length === 0) return undefined;
      const hint = textOf(target, configString(cfg, "promptLanguage"));
      // Index in the id keeps duplicate words ("the", "the") distinct.
      const bank = blocks.map((text, index) => ({ id: choiceId(id, "block", String(index)), text }));
      return { ...base, sentenceLanguage, ...(hint ? { hint } : {}), bank: shuffle(bank) };
    }
    case "matching": {
      const sourceLanguage = configString(cfg, "sourceLanguage");
      const targetLanguage = configString(cfg, "targetLanguage");
      const pairs = resolved.items.map(({ ref, item }) => ({
        key: ref.learningItemId.toString(),
        source: textOf(item, sourceLanguage),
        target: textOf(item, targetLanguage),
      }));
      if (pairs.length < 2 || !pairs.every((p) => p.source && p.target)) return undefined;
      return {
        ...base,
        sourceLanguage,
        targetLanguage,
        left: shuffle(pairs.map((p) => ({ id: choiceId(id, "left", p.key), text: p.source }))),
        right: shuffle(pairs.map((p) => ({ id: choiceId(id, "right", p.key), text: p.target }))),
      };
    }
  }
};
