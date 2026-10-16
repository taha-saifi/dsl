export interface User {
  _id: string;
  email: string;
  role: "admin" | "teacher" | "student";
  firstName: string;
  lastName: string;
  termsAcceptedAt?: string;
  createdAt?: string;
}

export type UserRole = User["role"];

export interface Specialization {
  _id: string;
  name: string;
  slug: string;
  iconUrl?: string;
}

export interface Course {
  _id: string;
  specializationId: string;
  thumbnailMediaId?: string;
  name: string;
  sourceLanguage: string;
  targetLanguage: string;
  description?: string;
  isPublished: boolean;
}

export interface Unit {
  _id: string;
  courseId: string;
  name: string;
  orderIndex: number;
  isPublished: boolean;
  learningItems: { learningItemId: string; order: number }[];
}

export interface Media {
  _id: string;
  type: "image" | "audio" | "video";
  url: string;
  filename: string;
  mimeType: string;
  sizeBytes: number;
  createdAt: string;
}

export interface Translation {
  language: string;
  text: string;
  pronunciation?: string;
  ipa?: string;
  audioMediaId?: string;
}

export interface LearningItem {
  _id: string;
  imageMediaId?: string;
  type: "word" | "phrase" | "sentence";
  translations: Translation[];
}

export interface Exercise {
  _id: string;
  unitId: string;
  name: string;
  orderIndex: number;
  isPublished: boolean;
}

export type QuestionType =
  | "choose_picture"
  | "multiple_choice"
  | "listening_transcribe"
  | "listening_select"
  | "typing"
  | "fill_blank"
  | "arrange_sentence"
  | "matching";

export interface QuestionItem {
  learningItemId: string;
  role: "target" | "distractor" | "pair";
  displayOrder: number;
}

export interface Question {
  _id: string;
  exerciseId: string;
  type: QuestionType;
  orderIndex: number;
  config: Record<string, unknown>;
  points: number;
  items: QuestionItem[];
  /** Teacher-written text. Absent when the question uses its type's default. */
  questionText?: string;
  /** Always set by the server: `questionText`, or the type's default text. */
  displayText: string;
}

export interface QuestionTextDefaults {
  maxLength: number;
  defaults: Record<QuestionType, string>;
}
