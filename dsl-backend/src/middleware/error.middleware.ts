import type { ErrorRequestHandler } from "express";
import multer from "multer";
import mongoose from "mongoose";

export class ApiError extends Error {
  public readonly statusCode: number;
  public readonly code: string | undefined;

  public constructor(statusCode: number, message: string, code?: string) {
    super(message);
    this.name = "ApiError";
    this.statusCode = statusCode;
    this.code = code;
  }
}

const isDuplicateKeyError = (error: unknown): boolean =>
  typeof error === "object" && error !== null && "code" in error && error.code === 11000;

export const errorHandler: ErrorRequestHandler = (error: unknown, _request, response, _next) => {
  if (error instanceof ApiError) {
    response.status(error.statusCode).json({
      error: { message: error.message, ...(error.code ? { code: error.code } : {}) },
    });
    return;
  }

  if (isDuplicateKeyError(error)) {
    response.status(409).json({
      error: { message: "A record with that value already exists.", code: "DUPLICATE_RESOURCE" },
    });
    return;
  }

  if (error instanceof mongoose.Error.ValidationError) {
    const validationError = Object.values(error.errors)[0];
    response.status(400).json({
      error: {
        message: validationError?.message ?? "Validation failed.",
        code: "VALIDATION_ERROR",
      },
    });
    return;
  }

  if (error instanceof multer.MulterError) {
    const isFileTooLarge = error.code === "LIMIT_FILE_SIZE";
    response.status(400).json({
      error: {
        message: isFileTooLarge ? "File size must not exceed 10MB." : "Invalid file upload.",
        code: isFileTooLarge ? "FILE_TOO_LARGE" : "INVALID_FILE_UPLOAD",
      },
    });
    return;
  }

  console.error("Unhandled application error:", error);
  response.status(500).json({
    error: { message: "Internal server error.", code: "INTERNAL_SERVER_ERROR" },
  });
};
