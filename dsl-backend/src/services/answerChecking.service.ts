import { ApiError } from "../middleware/error.middleware";
import type { Verdict } from "../models/ExerciseSession";
import { compareText, compareWords } from "./answerNormalization";
import { choiceId } from "./playPayload.service";
import {
  configString,
  targetOf,
  textOf,
  tokenizeWords,
  type ResolvedQuestion,
} from "./questionContent.service";

/*
 * Judges one answer against the answer derived from the question's learning
 * items, the same derivation the play payload uses (questionContent.service).
 * Choice ids are recomputed (playPayload.choiceId), so nothing about the
 * answer is stored per session.
 *
 * Answer shapes (anything else is 400 VALIDATION_ERROR):
 *   choose_picture, multiple_choice, listening_select: { optionId }
 *   typing, listening_transcribe, fill_blank:          { text }
 *   arrange_sentence:                                  { blockIds: string[] }
 *   matching:                                          { pairs: [{ leftId, rightId }] }
 * Ids that don't belong to the question simply make the answer wrong.
 */

export interface CheckResult {
  verdict: Verdict;
  /** What to show the student after answering. */
  correctAnswer: Record<string, unknown>;
}

const invalid = (message: string): ApiError => new ApiError(400, message, "VALIDATION_ERROR");

const asObject = (answer: unknown): Record<string, unknown> => {
  if (typeof answer !== "object" || answer === null || Array.isArray(answer)) {
    throw invalid("answer must be an object.");
  }
  return answer as Record<string, unknown>;
};

const stringField = (answer: Record<string, unknown>, key: string, max = 500): string => {
  const value = answer[key];
  if (typeof value !== "string" || value.length > max) {
    throw invalid(`answer.${key} must be a string of at most ${max} characters.`);
  }
  return value;
};

const stringArray = (answer: Record<string, unknown>, key: string): string[] => {
  const value = answer[key];
  if (!Array.isArray(value) || value.length > 100 || !value.every((v) => typeof v === "string")) {
    throw invalid(`answer.${key} must be an array of strings.`);
  }
  return value as string[];
};

/** Content that disappeared since the session started (deleted item or translation). */
const unavailable = (): ApiError =>
  new ApiError(409, "This question can no longer be checked.", "QUESTION_UNAVAILABLE");

export const checkAnswer = (resolved: ResolvedQuestion, rawAnswer: unknown): CheckResult => {
  const { question, config: cfg } = resolved;
  const qid = question._id.toString();
  const answer = asObject(rawAnswer);
  const target = targetOf(resolved);
  const targetKey = resolved.items.find(({ ref }) => ref.role === "target")?.ref.learningItemId.toString();

  switch (question.type) {
    case "choose_picture":
    case "multiple_choice":
    case "listening_select": {
      const optionId = stringField(answer, "optionId", 64);
      if (!targetKey) throw unavailable();
      const correctId = choiceId(qid, "option", targetKey);
      const text =
        question.type === "choose_picture" ? undefined : textOf(target, configString(cfg, "answerLanguage"));
      return {
        verdict: optionId === correctId ? "correct" : "wrong",
        correctAnswer: { optionId: correctId, ...(text ? { text } : {}) },
      };
    }
    case "typing":
    case "listening_transcribe": {
      const given = stringField(answer, "text");
      const expected = textOf(target, configString(cfg, "answerLanguage"));
      if (!expected) throw unavailable();
      return { verdict: compareText(given, expected), correctAnswer: { text: expected } };
    }
    case "fill_blank": {
      const given = stringField(answer, "text");
      const expected = typeof cfg.blankWord === "string" ? cfg.blankWord.trim() : "";
      if (!expected) throw unavailable();
      return { verdict: compareText(given, expected), correctAnswer: { text: expected } };
    }
    case "arrange_sentence": {
      const blockIds = stringArray(answer, "blockIds");
      const sentence = textOf(target, configString(cfg, "sentenceLanguage"));
      const blocks = Array.isArray(cfg.wordBlocks) ? cfg.wordBlocks.filter((w): w is string => typeof w === "string") : [];
      if (!sentence) throw unavailable();
      const textById = new Map(blocks.map((text, index) => [choiceId(qid, "block", String(index)), text]));
      const used = new Set<string>();
      const given: string[] = [];
      for (const id of blockIds) {
        const text = textById.get(id);
        if (text === undefined || used.has(id)) {
          return { verdict: "wrong", correctAnswer: { text: sentence } };
        }
        used.add(id);
        given.push(text);
      }
      return { verdict: compareWords(given, tokenizeWords(sentence)), correctAnswer: { text: sentence } };
    }
    case "matching": {
      const rawPairs = answer.pairs;
      if (!Array.isArray(rawPairs) || rawPairs.length > 50) {
        throw invalid("answer.pairs must be an array of { leftId, rightId }.");
      }
      const pairs = rawPairs.map((pair) => {
        const p = asObject(pair);
        return { leftId: stringField(p, "leftId", 64), rightId: stringField(p, "rightId", 64) };
      });
      const sourceLanguage = configString(cfg, "sourceLanguage");
      const targetLanguage = configString(cfg, "targetLanguage");
      const correct = resolved.items.map(({ ref, item }) => {
        const key = ref.learningItemId.toString();
        return {
          leftId: choiceId(qid, "left", key),
          rightId: choiceId(qid, "right", key),
          left: textOf(item, sourceLanguage),
          right: textOf(item, targetLanguage),
        };
      });
      const expected = new Map(correct.map((c) => [c.leftId, c.rightId]));
      const givenLeft = new Set(pairs.map((p) => p.leftId));
      const allRight =
        pairs.length === correct.length &&
        givenLeft.size === pairs.length &&
        pairs.every((p) => expected.get(p.leftId) === p.rightId);
      return { verdict: allRight ? "correct" : "wrong", correctAnswer: { pairs: correct } };
    }
  }
};
