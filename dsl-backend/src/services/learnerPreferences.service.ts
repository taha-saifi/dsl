import { ApiError } from "../middleware/error.middleware";
import {
  DAILY_TARGET_MINUTES,
  EXPERIENCE_LEVELS,
  LEARNING_GOALS,
} from "../models/User";
import { ensureSpecializationExists } from "./resourceDependencies.service";
import { getRequiredObjectId } from "../utils/requestValidation";

const PREFERENCE_KEYS = [
  "specializationId",
  "targetLanguage",
  "goal",
  "dailyTargetMinutes",
  "experienceLevel",
] as const;
type PreferenceKey = (typeof PREFERENCE_KEYS)[number];

const LANGUAGE_CODE = /^[a-z]{2}$/;

export interface PreferencesUpdate {
  set: Record<string, unknown>;
  unset: string[];
}

const invalid = (message: string): ApiError => new ApiError(400, message, "VALIDATION_ERROR");

const oneOf = <T extends string | number>(
  value: unknown,
  allowed: readonly T[],
  field: string,
): T => {
  if (!allowed.includes(value as T)) {
    throw invalid(`${field} must be one of: ${allowed.join(", ")}.`);
  }
  return value as T;
};

const validatePreference = async (key: PreferenceKey, value: unknown): Promise<unknown> => {
  switch (key) {
    case "specializationId": {
      const specializationId = getRequiredObjectId(value, "Specialization id");
      await ensureSpecializationExists(specializationId);
      return specializationId;
    }
    case "targetLanguage": {
      const code = typeof value === "string" ? value.trim().toLowerCase() : "";
      if (!LANGUAGE_CODE.test(code)) {
        throw invalid("Target language must be a 2-letter language code.");
      }
      return code;
    }
    case "goal":
      return oneOf(value, LEARNING_GOALS, "Goal");
    case "dailyTargetMinutes":
      return oneOf(value, DAILY_TARGET_MINUTES, "Daily target minutes");
    case "experienceLevel":
      return oneOf(value, EXPERIENCE_LEVELS, "Experience level");
  }
};

/**
 * `preferences` from `PATCH /auth/me`: each key is optional, `null` clears
 * it, and unknown keys are rejected so typos don't silently do nothing.
 */
export const getPreferencesUpdate = async (value: unknown): Promise<PreferencesUpdate> => {
  if (typeof value !== "object" || value === null || Array.isArray(value)) {
    throw invalid("Preferences must be an object.");
  }

  const update: PreferencesUpdate = { set: {}, unset: [] };
  for (const [key, entry] of Object.entries(value)) {
    if (!(PREFERENCE_KEYS as readonly string[]).includes(key)) {
      throw invalid(`Unknown preference "${key}".`);
    }
    const path = `preferences.${key}`;
    if (entry === null) {
      update.unset.push(path);
    } else {
      update.set[path] = await validatePreference(key as PreferenceKey, entry);
    }
  }

  return update;
};
