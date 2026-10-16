import { apiRequest } from "@/lib/api";
import type {
  Question,
  QuestionItem,
  QuestionTextDefaults,
  QuestionType,
} from "@/types";

export interface QuestionInput {
  exerciseId: string;
  type: QuestionType;
  orderIndex: number;
  points: number;
  config: Record<string, unknown>;
  items: QuestionItem[];
  /** Omit to use the type's default text. */
  questionText?: string;
}

/** The type can't change after creation, so it isn't part of an update. */
export interface QuestionUpdateInput {
  points?: number;
  config?: Record<string, unknown>;
  items?: QuestionItem[];
  /** `null` clears custom text so the type's default is used again. */
  questionText?: string | null;
}

export interface ReorderQuestionEntry {
  id: string;
  orderIndex: number;
}

export function listQuestions({ exerciseId }: { exerciseId: string }) {
  return apiRequest<Question[]>(
    `/questions?exerciseId=${encodeURIComponent(exerciseId)}`,
  );
}

let textDefaultsRequest: Promise<QuestionTextDefaults> | null = null;

/** Per-type default question text and the length limit. Fetched once per page load. */
export function getQuestionTextDefaults() {
  textDefaultsRequest ??= apiRequest<QuestionTextDefaults>(
    "/questions/text-defaults",
  ).catch((err) => {
    textDefaultsRequest = null;
    throw err;
  });
  return textDefaultsRequest;
}

export function getQuestion(id: string) {
  return apiRequest<Question>(`/questions/${id}`);
}

export function createQuestion(input: QuestionInput) {
  return apiRequest<Question>("/questions", {
    method: "POST",
    body: JSON.stringify(input),
  });
}

export function updateQuestion(id: string, input: QuestionUpdateInput) {
  return apiRequest<Question>(`/questions/${id}`, {
    method: "PATCH",
    body: JSON.stringify(input),
  });
}

export function deleteQuestion(id: string) {
  return apiRequest<{ id: string }>(`/questions/${id}`, {
    method: "DELETE",
  });
}

export function reorderQuestions(items: ReorderQuestionEntry[]) {
  return apiRequest<Question[]>("/questions/reorder", {
    method: "PATCH",
    body: JSON.stringify(items),
  });
}
