import mongoose from "mongoose";

import { config } from "./config";

export const connectToDatabase = async (): Promise<void> => {
  if (!config.mongoDbUri) {
    console.error("MongoDB connection failed: MONGODB_URI is not configured.");
    process.exit(1);
  }

  try {
    await mongoose.connect(config.mongoDbUri);
    console.log("MongoDB Atlas connected successfully.");
  } catch (error: unknown) {
    const message = error instanceof Error ? error.message : "Unknown connection error";
    console.error(`MongoDB connection failed: ${message}`);
    process.exit(1);
  }
};
