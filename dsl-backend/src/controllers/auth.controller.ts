import type { Request, Response } from "express";
import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";

import { config } from "../config/config";
import User, { type UserRole } from "../models/User";
import { ApiError } from "../middleware/error.middleware";
import {
  ensureEmailAvailable,
  getValidEmail,
  getValidPassword,
  hashPassword,
} from "../services/userAccount.service";
import {
  getBodyObject,
  getOptionalBoolean,
  getRequiredString,
} from "../utils/requestValidation";

interface AuthRequestBody {
  email?: unknown;
  password?: unknown;
}

const requireString = (value: unknown, field: string): string => {
  if (typeof value !== "string" || value.trim() === "") {
    throw new ApiError(400, `${field} is required.`, "VALIDATION_ERROR");
  }

  return value.trim();
};

const createToken = (userId: string, role: UserRole): string => {
  if (!config.jwtSecret) {
    throw new ApiError(500, "JWT_SECRET is not configured.", "CONFIGURATION_ERROR");
  }

  return jwt.sign({ userId, role }, config.jwtSecret, { expiresIn: "7d" });
};

/** Self-registration always creates a student. Teachers and admins are created by an admin. */
export const register = async (request: Request, response: Response): Promise<void> => {
  const body = getBodyObject(request.body as unknown);
  const email = getValidEmail(body.email);
  const password = getValidPassword(body.password);
  const firstName = getRequiredString(body.firstName, "First name");
  const lastName = getRequiredString(body.lastName, "Last name");
  const acceptedTerms = getOptionalBoolean(body.acceptedTerms, "Accepted terms");

  await ensureEmailAvailable(email);

  const user = await User.create({
    email,
    passwordHash: await hashPassword(password),
    role: "student",
    firstName,
    lastName,
    ...(acceptedTerms === true ? { termsAcceptedAt: new Date() } : {}),
  });

  response.status(201).json({
    data: { token: createToken(user.id, user.role), user },
  });
};

export const login = async (request: Request, response: Response): Promise<void> => {
  const body = request.body as AuthRequestBody;
  const email = requireString(body.email, "Email").toLowerCase();
  const password = requireString(body.password, "Password");

  const user = await User.findOne({ email }).select("+passwordHash");
  const passwordMatches = user ? await bcrypt.compare(password, user.passwordHash) : false;
  if (!user || !passwordMatches) {
    throw new ApiError(401, "Invalid credentials.", "INVALID_CREDENTIALS");
  }

  response.status(200).json({
    data: { token: createToken(user.id, user.role), user },
  });
};

export const me = async (request: Request, response: Response): Promise<void> => {
  if (!request.user) {
    throw new ApiError(401, "Unauthorized.", "UNAUTHORIZED");
  }

  response.status(200).json({ data: request.user });
};
