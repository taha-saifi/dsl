import { HydratedDocument, model, Schema } from "mongoose";

export type UserRole = "admin" | "teacher" | "student";

export interface IUser {
  email: string;
  passwordHash: string;
  role: UserRole;
  firstName?: string;
  lastName?: string;
  createdAt: Date;
  updatedAt: Date;
}

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
      enum: ["admin", "teacher", "student"],
      default: "teacher",
    },
    firstName: {
      type: String,
      trim: true,
    },
    lastName: {
      type: String,
      trim: true,
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
