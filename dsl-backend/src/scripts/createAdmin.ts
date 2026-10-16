/**
 * Creates the first admin, or promotes an existing account to admin.
 *
 *   npm run create-admin -- --email a@b.c --password '…' --first-name Ada --last-name Admin
 *   docker compose exec backend node dist/scripts/createAdmin.js --email … (same flags)
 *
 * For an existing email the role becomes "admin"; the password changes only if
 * --password is given. Uses MONGODB_URI like the server.
 */
import mongoose from "mongoose";

import { connectToDatabase } from "../config/db";
import { ApiError } from "../middleware/error.middleware";
import User from "../models/User";
import { getValidEmail, getValidPassword, hashPassword } from "../services/userAccount.service";

const readFlag = (name: string): string | undefined => {
  const index = process.argv.indexOf(`--${name}`);
  return index === -1 ? undefined : process.argv[index + 1];
};

const run = async (): Promise<void> => {
  const email = getValidEmail(readFlag("email"));
  const rawPassword = readFlag("password");
  const firstName = readFlag("first-name");
  const lastName = readFlag("last-name");

  await connectToDatabase();

  const existingUser = await User.findOne({ email });
  if (existingUser) {
    existingUser.role = "admin";
    if (rawPassword !== undefined) {
      existingUser.passwordHash = await hashPassword(getValidPassword(rawPassword));
    }
    await existingUser.save();
    console.log(`Promoted ${email} to admin${rawPassword !== undefined ? " and set a new password" : ""}.`);
    return;
  }

  if (!firstName || !lastName) {
    throw new ApiError(400, "A new admin needs --first-name and --last-name.");
  }

  await User.create({
    email,
    passwordHash: await hashPassword(getValidPassword(rawPassword)),
    role: "admin",
    firstName,
    lastName,
  });
  console.log(`Created admin ${email}.`);
};

run()
  .catch((error: unknown) => {
    console.error(error instanceof Error ? error.message : error);
    process.exitCode = 1;
  })
  .finally(() => {
    void mongoose.disconnect();
  });
