import { HydratedDocument, model, Schema, Types } from "mongoose";

export const USER_ROLES = ["admin", "teacher", "student"] as const;
export type UserRole = (typeof USER_ROLES)[number];

export const LEARNING_GOALS = ["professional", "academic", "certification", "daily_practice"] as const;
export const EXPERIENCE_LEVELS = ["beginner", "intermediate", "advanced"] as const;
export const DAILY_TARGET_MINUTES = [5, 10, 15, 20, 30] as const;

/** Set by the app's onboarding. Goal and level are informational in the MVP. */
export interface ILearningPreferences {
  specializationId?: Types.ObjectId;
  targetLanguage?: string;
  goal?: (typeof LEARNING_GOALS)[number];
  dailyTargetMinutes?: (typeof DAILY_TARGET_MINUTES)[number];
  experienceLevel?: (typeof EXPERIENCE_LEVELS)[number];
}

export interface IUser {
  email: string;
  passwordHash: string;
  role: UserRole;
  firstName?: string;
  lastName?: string;
  termsAcceptedAt?: Date;
  preferences?: ILearningPreferences;
  createdAt: Date;
  updatedAt: Date;
}

const learningPreferencesSchema = new Schema<ILearningPreferences>(
  {
    specializationId: { type: Schema.Types.ObjectId, ref: "Specialization" },
    targetLanguage: { type: String, lowercase: true, trim: true },
    goal: { type: String, enum: LEARNING_GOALS },
    dailyTargetMinutes: { type: Number, enum: DAILY_TARGET_MINUTES },
    experienceLevel: { type: String, enum: EXPERIENCE_LEVELS },
  },
  { _id: false },
);

const userSchema = new Schema<IUser>(
  {
    email: {
      type: String,
      required: true,
      unique: true,
      lowercase: true,
      trim: true,
    },
    passwordHash: {
      type: String,
      required: true,
      select: false,
    },
    role: {
      type: String,
      enum: USER_ROLES,
      default: "student",
    },
    firstName: {
      type: String,
      trim: true,
    },
    lastName: {
      type: String,
      trim: true,
    },
    termsAcceptedAt: {
      type: Date,
    },
    preferences: {
      type: learningPreferencesSchema,
    },
  },
  {
    timestamps: true,
    toJSON: {
      transform: (_document: HydratedDocument<IUser>, returnedObject: Record<string, unknown>) => {
        delete returnedObject.passwordHash;
        delete returnedObject.__v;
        return returnedObject;
      },
    },
  },
);

const User = model<IUser>("User", userSchema);

export default User;
