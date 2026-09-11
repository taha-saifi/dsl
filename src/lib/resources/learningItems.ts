import { apiRequest } from "@/lib/api";
import type { LearningItem } from "@/types";

export interface TranslationInput {
  language: string;
  text: string;
  pronunciation?: string;
  ipa?: string;
  audioMediaId?: string;
}

export interface TranslationUpdateInput {
  text?: string;
  pronunciation?: string;
  ipa?: string;
  audioMediaId?: string;
}

export interface LearningItemInput {
  type: LearningItem["type"];
  imageMediaId?: string;
}

export interface LearningItemUpdateInput {
  type?: LearningItem["type"];
  imageMediaId?: string;
}

export function listLearningItems(filter?: {
  type?: LearningItem["type"];
  search?: string;
}) {
  const params = new URLSearchParams();
  if (filter?.type) params.set("type", filter.type);
  if (filter?.search) params.set("search", filter.search);
  const query = params.toString();
  return apiRequest<LearningItem[]>(
    `/learning-items${query ? `?${query}` : ""}`,
  );
}

export function getLearningItem(id: string) {
  return apiRequest<LearningItem>(`/learning-items/${id}`);
}

export function createLearningItem(input: LearningItemInput) {
  return apiRequest<LearningItem>("/learning-items", {
    method: "POST",
    body: JSON.stringify(input),
  });
}

export function updateLearningItem(id: string, input: LearningItemUpdateInput) {
  return apiRequest<LearningItem>(`/learning-items/${id}`, {
    method: "PATCH",
    body: JSON.stringify(input),
  });
}

export function deleteLearningItem(id: string) {
  return apiRequest<{ id: string }>(`/learning-items/${id}`, {
    method: "DELETE",
  });
}

export function addTranslation(itemId: string, input: TranslationInput) {
  return apiRequest<LearningItem>(`/learning-items/${itemId}/translations`, {
    method: "POST",
    body: JSON.stringify(input),
  });
}

export function updateTranslation(
  itemId: string,
  language: string,
  input: TranslationUpdateInput,
) {
  return apiRequest<LearningItem>(
    `/learning-items/${itemId}/translations/${encodeURIComponent(language)}`,
    {
      method: "PATCH",
      body: JSON.stringify(input),
    },
  );
}

export function removeTranslation(itemId: string, language: string) {
  return apiRequest<LearningItem>(
    `/learning-items/${itemId}/translations/${encodeURIComponent(language)}`,
    {
      method: "DELETE",
    },
  );
}
