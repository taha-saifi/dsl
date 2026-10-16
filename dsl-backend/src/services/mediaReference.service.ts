import { Types } from "mongoose";

import { ApiError } from "../middleware/error.middleware";
import Media, { type MediaType } from "../models/Media";

export const ensureMediaHasType = async (
  mediaId: Types.ObjectId,
  expectedType: Extract<MediaType, "image" | "audio">,
  fieldName: string,
): Promise<void> => {
  const media = await Media.findById(mediaId);
  if (!media) {
    throw new ApiError(404, "Media not found.", "MEDIA_NOT_FOUND");
  }
  if (media.type !== expectedType) {
    throw new ApiError(
      400,
      `${fieldName} must reference an ${expectedType} media item.`,
      "INVALID_MEDIA_TYPE",
    );
  }
};
