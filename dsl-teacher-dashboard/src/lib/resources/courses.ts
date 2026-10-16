import { apiRequest } from "@/lib/api";
import type { Course } from "@/types";

export interface CourseInput {
  specializationId: string;
  name: string;
  sourceLanguage: string;
  targetLanguage: string;
  description?: string;
}

export interface CourseUpdateInput {
  name?: string;
  sourceLanguage?: string;
  targetLanguage?: string;
  description?: string;
  isPublished?: boolean;
}

export function listCourses({
  specializationId,
}: { specializationId?: string } = {}) {
  return apiRequest<Course[]>(
    specializationId
      ? `/courses?specializationId=${encodeURIComponent(specializationId)}`
      : "/courses",
  );
}

export function getCourse(id: string) {
  return apiRequest<Course>(`/courses/${id}`);
}

export function createCourse(input: CourseInput) {
  return apiRequest<Course>("/courses", {
    method: "POST",
    body: JSON.stringify(input),
  });
}

export function updateCourse(id: string, input: CourseUpdateInput) {
  return apiRequest<Course>(`/courses/${id}`, {
    method: "PATCH",
    body: JSON.stringify(input),
  });
}

export function deleteCourse(id: string) {
  return apiRequest<{ id: string }>(`/courses/${id}`, {
    method: "DELETE",
  });
}
