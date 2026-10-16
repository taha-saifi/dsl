import { apiRequest } from "@/lib/api";
import type { User, UserRole } from "@/types";

/** Admin only (`/admin/users`). Students sign up in the mobile app. */
export interface StaffUserInput {
  email: string;
  password: string;
  firstName: string;
  lastName: string;
  role: "teacher" | "admin";
}

export function listUsers(roles?: UserRole[]) {
  const query = roles?.length ? `?role=${roles.join(",")}` : "";
  return apiRequest<User[]>(`/admin/users${query}`);
}

export function createStaffUser(input: StaffUserInput) {
  return apiRequest<User>("/admin/users", {
    method: "POST",
    body: JSON.stringify(input),
  });
}

export function resetUserPassword(id: string, password: string) {
  return apiRequest<User>(`/admin/users/${id}/password`, {
    method: "PATCH",
    body: JSON.stringify({ password }),
  });
}
