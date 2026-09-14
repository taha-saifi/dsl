import { apiRequest } from "@/lib/api";
import type { Exercise } from "@/types";

export interface ExerciseInput {
  unitId: string;
  name: string;
  orderIndex: number;
}

export interface ExerciseUpdateInput {
  name?: string;
  isPublished?: boolean;
}

export interface ReorderExerciseEntry {
  id: string;
  orderIndex: number;
}

export function listExercises({ unitId }: { unitId?: string } = {}) {
  return apiRequest<Exercise[]>(
    unitId ? `/exercises?unitId=${encodeURIComponent(unitId)}` : "/exercises",
  );
}

export function getExercise(id: string) {
  return apiRequest<Exercise>(`/exercises/${id}`);
}

export function createExercise(input: ExerciseInput) {
  return apiRequest<Exercise>("/exercises", {
    method: "POST",
    body: JSON.stringify(input),
  });
}

export function updateExercise(id: string, input: ExerciseUpdateInput) {
  return apiRequest<Exercise>(`/exercises/${id}`, {
    method: "PATCH",
    body: JSON.stringify(input),
  });
}

export function deleteExercise(id: string) {
  return apiRequest<{ id: string }>(`/exercises/${id}`, {
    method: "DELETE",
  });
}

export function reorderExercises(items: ReorderExerciseEntry[]) {
  return apiRequest<Exercise[]>("/exercises/reorder", {
    method: "PATCH",
    body: JSON.stringify(items),
  });
}
