/*
 * The one rule for comparing typed answers (docs/decisions/adr-answer-normalization.md):
 *
 * 1. Normalize both sides: Unicode NFC, typographic apostrophes/quotes to
 *    ASCII, trim, collapse whitespace, lower-case, and drop trailing
 *    punctuation (. , ! ? ; : …).
 * 2. Equal → "correct".
 * 3. Equal after also folding accents and ligatures (é→e, œ→oe, æ→ae, ß→ss)
 *    → "almost" (counts as correct; the app shows the exact spelling).
 * 4. Otherwise → "wrong".
 */

import type { Verdict } from "../models/ExerciseSession";

export const normalizeAnswer = (value: string): string =>
  value
    .normalize("NFC")
    .replace(/[‘’ʼ]/g, "'")
    .replace(/[“”]/g, '"')
    .trim()
    .replace(/\s+/g, " ")
    .toLowerCase()
    .replace(/[.,!?;:…]+$/u, "")
    .trim();

const LIGATURES: Record<string, string> = { "œ": "oe", "æ": "ae", "ß": "ss" };

export const foldAccents = (value: string): string =>
  value
    .replace(/[œæß]/g, (ch) => LIGATURES[ch] ?? ch)
    .normalize("NFD")
    .replace(/\p{M}+/gu, "")
    .normalize("NFC");

export const compareText = (given: string, expected: string): Verdict => {
  const a = normalizeAnswer(given);
  const b = normalizeAnswer(expected);
  if (a === b) {
    return "correct";
  }
  return a !== "" && foldAccents(a) === foldAccents(b) ? "almost" : "wrong";
};

/** Word by word; the sequence is as good as its weakest word. */
export const compareWords = (given: string[], expected: string[]): Verdict => {
  if (given.length !== expected.length) {
    return "wrong";
  }
  let verdict: Verdict = "correct";
  for (let i = 0; i < given.length; i++) {
    const word = compareText(given[i] ?? "", expected[i] ?? "");
    if (word === "wrong") {
      return "wrong";
    }
    if (word === "almost") {
      verdict = "almost";
    }
  }
  return verdict;
};
