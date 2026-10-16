import { model, Schema, Types } from "mongoose";

export type MediaType = "image" | "audio" | "video";

export interface IMedia {
  uploadedBy: Types.ObjectId;
  type: MediaType;
  url: string;
  filename: string;
  mimeType: string;
  sizeBytes: number;
  storageKey: string;
  createdAt: Date;
}

const mediaSchema = new Schema<IMedia>(
  {
    uploadedBy: {
      type: Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },
    type: {
      type: String,
      enum: ["image", "audio", "video"],
      required: true,
    },
    url: {
      type: String,
      required: true,
    },
    filename: {
      type: String,
      required: true,
    },
    mimeType: {
      type: String,
      required: true,
    },
    sizeBytes: {
      type: Number,
      required: true,
    },
    storageKey: {
      type: String,
      required: true,
    },
  },
  { timestamps: { createdAt: true, updatedAt: false } },
);

const Media = model<IMedia>("Media", mediaSchema);

export default Media;
