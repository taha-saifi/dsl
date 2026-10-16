import { randomUUID } from "crypto";
import path from "path";

import { DeleteObjectCommand, PutObjectCommand } from "@aws-sdk/client-s3";
import type { Request, Response } from "express";

import { config } from "../config/config";
import { publicMediaUrl, s3Client } from "../config/storage";
import { ApiError } from "../middleware/error.middleware";
import Media, { type MediaType } from "../models/Media";
import { getRequiredString, getRouteObjectId } from "../utils/requestValidation";

const mediaTypes = new Set<MediaType>(["image", "audio", "video"]);

const getMediaTypeFilter = (value: unknown): MediaType => {
  const type = getRequiredString(value, "type");
  if (!mediaTypes.has(type as MediaType)) {
    throw new ApiError(400, "type must be image, audio, or video.", "VALIDATION_ERROR");
  }

  return type as MediaType;
};

const uploadToStorage = async (file: Express.Multer.File): Promise<{ url: string; key: string }> => {
  const extension = path.extname(file.originalname);
  const key = `${randomUUID()}${extension}`;

  await s3Client.send(
    new PutObjectCommand({
      Bucket: config.minioBucket,
      Key: key,
      Body: file.buffer,
      ContentType: file.mimetype,
    }),
  );

  const url = publicMediaUrl(key);
  return { url, key };
};

const getMediaType = (mimeType: string): Extract<MediaType, "image" | "audio"> =>
  mimeType.startsWith("image/") ? "image" : "audio";

export const uploadMedia = async (request: Request, response: Response): Promise<void> => {
  if (!request.file) {
    throw new ApiError(400, "A file is required.", "FILE_REQUIRED");
  }
  if (!request.user) {
    throw new ApiError(401, "Unauthorized.", "UNAUTHORIZED");
  }

  const uploaded = await uploadToStorage(request.file);
  const media = await Media.create({
    uploadedBy: request.user._id,
    type: getMediaType(request.file.mimetype),
    url: uploaded.url,
    filename: request.file.originalname,
    mimeType: request.file.mimetype,
    sizeBytes: request.file.size,
    storageKey: uploaded.key,
  });

  response.status(201).json({ data: media });
};

export const list = async (request: Request, response: Response): Promise<void> => {
  const typeQuery = request.query.type;
  const filter: { type?: MediaType } = {};
  if (typeQuery !== undefined) {
    filter.type = getMediaTypeFilter(typeQuery);
  }

  const media = await Media.find(filter).sort({ createdAt: -1 });
  response.status(200).json({ data: media });
};

export const getById = async (request: Request, response: Response): Promise<void> => {
  const mediaId = getRouteObjectId(request.params.id, "Media");
  const media = await Media.findById(mediaId);
  if (!media) {
    throw new ApiError(404, "Media not found.", "MEDIA_NOT_FOUND");
  }

  response.status(200).json({ data: media });
};

export const remove = async (request: Request, response: Response): Promise<void> => {
  const mediaId = getRouteObjectId(request.params.id, "Media");
  const media = await Media.findById(mediaId);
  if (!media) {
    throw new ApiError(404, "Media not found.", "MEDIA_NOT_FOUND");
  }

  try {
    await s3Client.send(
      new DeleteObjectCommand({
        Bucket: config.minioBucket,
        Key: media.storageKey,
      }),
    );
  } catch (_error: unknown) {
    throw new ApiError(
      500,
      "Storage deletion failed; the media record was preserved.",
      "STORAGE_DELETE_FAILED",
    );
  }

  await media.deleteOne();
  response.status(200).json({ data: { id: media.id } });
};
