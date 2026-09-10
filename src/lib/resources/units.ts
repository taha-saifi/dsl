import { apiRequest } from "@/lib/api";
import type { Unit } from "@/types";

export interface UnitInput {
  courseId: string;
  name: string;
  orderIndex: number;
}

export interface UnitUpdateInput {
  name?: string;
}

export interface ReorderUnitEntry {
  id: string;
  orderIndex: number;
}

export function listUnits({ courseId }: { courseId: string }) {
  return apiRequest<Unit[]>(`/units?courseId=${encodeURIComponent(courseId)}`);
}

export function getUnit(id: string) {
  return apiRequest<Unit>(`/units/${id}`);
}

export function createUnit(input: UnitInput) {
  return apiRequest<Unit>("/units", {
    method: "POST",
    body: JSON.stringify(input),
  });
}

export function updateUnit(id: string, input: UnitUpdateInput) {
  return apiRequest<Unit>(`/units/${id}`, {
    method: "PATCH",
    body: JSON.stringify(input),
  });
}

export function deleteUnit(id: string) {
  return apiRequest<{ id: string }>(`/units/${id}`, {
    method: "DELETE",
  });
}

export function reorderUnits(courseId: string, units: ReorderUnitEntry[]) {
  return apiRequest<Unit[]>("/units/reorder", {
    method: "PATCH",
    body: JSON.stringify({ courseId, units }),
  });
}
