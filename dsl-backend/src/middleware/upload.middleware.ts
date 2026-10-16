import type { Request } from "express";
import multer from "multer";

import { ApiError } from "./error.middleware";

const allowedMimeTypes = new Set([
  "image/jpeg",
  "image/png",
  "image/webp",
  "audio/mpeg",
  "audio/wav",
  "audio/mp4",
]);

const fileFilter = (_request: Request, file: Express.Multer.File, callback: multer.FileFilterCallback): void => {
  if (!allowedMimeTypes.has(file.mimetype)) {
    callback(new ApiError(400, "Unsupported file type.", "UNSUPPORTED_MEDIA_TYPE"));
    return;
  }

  callback(null, true);
};

export const upload = multer({
  storage: multer.memoryStorage(),
  limits: { fileSize: 10 * 1024 * 1024 },
  fileFilter,
});
