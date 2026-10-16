import type { Request, Response } from "express";

import { ApiError } from "../middleware/error.middleware";
import User, { USER_ROLES, type UserRole } from "../models/User";
import {
  ensureEmailAvailable,
  getValidEmail,
  getValidPassword,
  hashPassword,
} from "../services/userAccount.service";
import { getBodyObject, getRequiredString, getRouteObjectId } from "../utils/requestValidation";

/** Roles an admin can hand out. Students sign up themselves through the app. */
const STAFF_ROLES: readonly UserRole[] = ["teacher", "admin"];

const isUserRole = (value: string): value is UserRole =>
  (USER_ROLES as readonly string[]).includes(value);

const getStaffRole = (value: unknown): UserRole => {
  if (typeof value !== "string" || !STAFF_ROLES.includes(value as UserRole)) {
    throw new ApiError(400, "Role must be one of: teacher, admin.", "VALIDATION_ERROR");
  }

  return value as UserRole;
};

/** `?role=teacher,admin` → those roles; no `role` → every role. */
const getRoleFilter = (value: unknown): UserRole[] | undefined => {
  if (value === undefined) {
    return undefined;
  }

  const roles = typeof value === "string" ? value.split(",").map((role) => role.trim()) : [];
  if (roles.length === 0 || !roles.every(isUserRole)) {
    throw new ApiError(
      400,
      `Role filter must be a comma-separated list of: ${USER_ROLES.join(", ")}.`,
      "VALIDATION_ERROR",
    );
  }

  return roles;
};

export const list = async (request: Request, response: Response): Promise<void> => {
  const roles = getRoleFilter(request.query.role);
  const users = await User.find(roles ? { role: { $in: roles } } : {}).sort({ createdAt: -1 });
  response.status(200).json({ data: users });
};

export const create = async (request: Request, response: Response): Promise<void> => {
  const body = getBodyObject(request.body as unknown);
  const email = getValidEmail(body.email);
  const password = getValidPassword(body.password);
  const firstName = getRequiredString(body.firstName, "First name");
  const lastName = getRequiredString(body.lastName, "Last name");
  const role = getStaffRole(body.role);

  await ensureEmailAvailable(email);

  const user = await User.create({
    email,
    passwordHash: await hashPassword(password),
    role,
    firstName,
    lastName,
  });

  response.status(201).json({ data: user });
};

/** Admin-set password. There is no email provider yet, so this is how accounts are recovered. */
export const resetPassword = async (request: Request, response: Response): Promise<void> => {
  const userId = getRouteObjectId(request.params.id, "User");
  const body = getBodyObject(request.body as unknown);
  const password = getValidPassword(body.password);

  const user = await User.findById(userId);
  if (!user) {
    throw new ApiError(404, "User not found.", "USER_NOT_FOUND");
  }

  user.passwordHash = await hashPassword(password);
  await user.save();

  response.status(200).json({ data: user });
};
