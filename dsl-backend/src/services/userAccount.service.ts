import bcrypt from "bcryptjs";

import { ApiError } from "../middleware/error.middleware";
import User from "../models/User";
import { getRequiredString } from "../utils/requestValidation";

export const PASSWORD_MIN_LENGTH = 8;
const PASSWORD_MAX_LENGTH = 128;
const EMAIL_PATTERN = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

export const getValidEmail = (value: unknown): string => {
  const email = getRequiredString(value, "Email").toLowerCase();
  if (!EMAIL_PATTERN.test(email)) {
    throw new ApiError(400, "Email must be a valid email address.", "VALIDATION_ERROR");
  }

  return email;
};

/** Passwords are trimmed like every other string field, so login trims too. */
export const getValidPassword = (value: unknown): string => {
  const password = getRequiredString(value, "Password");
  if (password.length < PASSWORD_MIN_LENGTH) {
    throw new ApiError(
      400,
      `Password must be at least ${PASSWORD_MIN_LENGTH} characters.`,
      "VALIDATION_ERROR",
    );
  }
  if (password.length > PASSWORD_MAX_LENGTH) {
    throw new ApiError(
      400,
      `Password must be at most ${PASSWORD_MAX_LENGTH} characters.`,
      "VALIDATION_ERROR",
    );
  }

  return password;
};

export const hashPassword = (password: string): Promise<string> => bcrypt.hash(password, 12);

export const ensureEmailAvailable = async (email: string): Promise<void> => {
  const existingUser = await User.exists({ email });
  if (existingUser) {
    throw new ApiError(409, "An account with that email already exists.", "EMAIL_IN_USE");
  }
};
