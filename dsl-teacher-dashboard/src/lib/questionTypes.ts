import type { QuestionType } from "@/types";

/** How the student answers. Groups the type picker. */
export type QuestionFamily = "pick" | "type" | "build";

export interface QuestionTypeInfo {
  type: QuestionType;
  label: string;
  description: string;
  family: QuestionFamily;
}

export const QUESTION_TYPE_INFO: Record<QuestionType, QuestionTypeInfo> = {
  choose_picture: {
    type: "choose_picture",
    label: "Choose picture",
    description: "Students see a word and tap the picture that matches it.",
    family: "pick",
  },
  multiple_choice: {
    type: "multiple_choice",
    label: "Multiple choice",
    description: "Students see a word and pick its translation from a list.",
    family: "pick",
  },
  listening_select: {
    type: "listening_select",
    label: "Listen and select",
    description: "Students hear a recording and pick the word they heard.",
    family: "pick",
  },
  typing: {
    type: "typing",
    label: "Typing",
    description: "Students see a word and type its translation.",
    family: "type",
  },
  listening_transcribe: {
    type: "listening_transcribe",
    label: "Listen and type",
    description: "Students hear a recording and type what they heard.",
    family: "type",
  },
  fill_blank: {
    type: "fill_blank",
    label: "Fill in the blank",
    description: "Students type the word missing from a sentence.",
    family: "type",
  },
  arrange_sentence: {
    type: "arrange_sentence",
    label: "Arrange sentence",
    description: "Students put shuffled word blocks in the right order.",
    family: "build",
  },
  matching: {
    type: "matching",
    label: "Matching pairs",
    description: "Students pair each word with its translation.",
    family: "build",
  },
};

export const QUESTION_FAMILIES: {
  family: QuestionFamily;
  title: string;
  hint: string;
}[] = [
  { family: "pick", title: "Pick an answer", hint: "Recognition: the right answer is on screen." },
  { family: "type", title: "Type an answer", hint: "Recall: students produce the word themselves." },
  { family: "build", title: "Build an answer", hint: "Structure: students assemble or connect pieces." },
];

export const QUESTION_TYPES_BY_FAMILY: Record<QuestionFamily, QuestionType[]> =
  {
    pick: ["choose_picture", "multiple_choice", "listening_select"],
    type: ["typing", "listening_transcribe", "fill_blank"],
    build: ["arrange_sentence", "matching"],
  };

/** Counted the way the server counts: Unicode code points, after trimming. */
export function questionTextLength(value: string) {
  return [...value.trim()].length;
}
