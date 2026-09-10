import { apiRequest } from "@/lib/api";
import type { Specialization } from "@/types";

export interface SpecializationInput {
  name: string;
  iconUrl?: string;
}

export function listSpecializations() {
  return apiRequest<Specialization[]>("/specializations");
}

export function getSpecialization(id: string) {
  return apiRequest<Specialization>(`/specializations/${id}`);
}

export function createSpecialization(input: SpecializationInput) {
  return apiRequest<Specialization>("/specializations", {
    method: "POST",
    body: JSON.stringify(input),
  });
}

export function updateSpecialization(
  id: string,
  input: Partial<SpecializationInput>,
) {
  return apiRequest<Specialization>(`/specializations/${id}`, {
    method: "PATCH",
    body: JSON.stringify(input),
  });
}

export function deleteSpecialization(id: string) {
  return apiRequest<{ id: string }>(`/specializations/${id}`, {
    method: "DELETE",
  });
}
