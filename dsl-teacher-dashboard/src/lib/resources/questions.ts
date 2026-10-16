import { apiRequest } from "@/lib/api";
import type { Question, QuestionItem, QuestionType } from "@/types";

export interface QuestionInput {
  exerciseId: string;
  type: QuestionType;
  orderIndex: number;
  points: number;
  config: Record<string, unknown>;
  items: QuestionItem[];
}

export interface QuestionUpdateInput {
  type?: QuestionType;
  points?: number;
  config?: Record<string, unknown>;
  items?: QuestionItem[];
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
