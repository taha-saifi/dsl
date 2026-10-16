import { useEffect, useRef, useState } from "react";
import { Button } from "@/components/ui/button";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import { Input } from "@/components/ui/input";
import { ApiError } from "@/lib/api";
import { listMedia, uploadMedia } from "@/lib/resources/media";
import type { Media } from "@/types";

const MAX_FILE_SIZE_BYTES = 10 * 1024 * 1024;

const ACCEPTED_MIME_TYPES: Record<"image" | "audio", string[]> = {
  image: ["image/jpeg", "image/png", "image/webp"],
  audio: ["audio/mpeg", "audio/wav", "audio/mp4"],
};

type ExistingStatus = "loading" | "error" | "ready";

interface MediaPickerProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  mediaType: "image" | "audio";
  onSelect: (media: Media) => void;
}

export default function MediaPicker({
  open,
  onOpenChange,
  mediaType,
  onSelect,
}: MediaPickerProps) {
  const fileInputRef = useRef<HTMLInputElement>(null);
  const [uploading, setUploading] = useState(false);
  const [uploadError, setUploadError] = useState<string | null>(null);

  const [existingStatus, setExistingStatus] = useState<ExistingStatus>("loading");
  const [existingItems, setExistingItems] = useState<Media[]>([]);
  const [existingError, setExistingError] = useState<string | null>(null);

  useEffect(() => {
    if (!open) return;
    setUploadError(null);
    setExistingStatus("loading");
    setExistingError(null);
    listMedia({ type: mediaType })
      .then((items) => {
        setExistingItems(items);
        setExistingStatus("ready");
      })
      .catch((err) => {
        setExistingError(err instanceof Error ? err.message : "Request failed");
        setExistingStatus("error");
      });
  }, [open, mediaType]);

  function retryExisting() {
    setExistingStatus("loading");
    setExistingError(null);
    listMedia({ type: mediaType })
      .then((items) => {
        setExistingItems(items);
        setExistingStatus("ready");
      })
      .catch((err) => {
        setExistingError(err instanceof Error ? err.message : "Request failed");
        setExistingStatus("error");
      });
  }

  async function handleFileChange(e: React.ChangeEvent<HTMLInputElement>) {
    const file = e.target.files?.[0];
    if (!file) return;
    setUploadError(null);

    const allowed = ACCEPTED_MIME_TYPES[mediaType];
    if (!allowed.includes(file.type)) {
      setUploadError("Unsupported file type.");
      if (fileInputRef.current) fileInputRef.current.value = "";
      return;
    }
    if (file.size > MAX_FILE_SIZE_BYTES) {
      setUploadError("File size must not exceed 10MB.");
      if (fileInputRef.current) fileInputRef.current.value = "";
      return;
    }

    setUploading(true);
    try {
      const media = await uploadMedia(file);
      onSelect(media);
      onOpenChange(false);
    } catch (err) {
      setUploadError(
        err instanceof ApiError || err instanceof Error
          ? err.message
          : "Upload failed",
      );
    } finally {
      setUploading(false);
      if (fileInputRef.current) fileInputRef.current.value = "";
    }
  }

  function handleSelectExisting(media: Media) {
    onSelect(media);
    onOpenChange(false);
  }

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="sm:max-w-lg">
        <DialogHeader>
          <DialogTitle>
            Choose {mediaType === "image" ? "an image" : "audio"}
          </DialogTitle>
        </DialogHeader>

        <div className="flex flex-col gap-2">
          <h3 className="text-sm font-medium text-slate-700">Upload new</h3>
          <Input
            ref={fileInputRef}
            type="file"
            accept={ACCEPTED_MIME_TYPES[mediaType].join(",")}
            disabled={uploading}
            onChange={handleFileChange}
          />
          {uploading && (
            <p className="text-sm text-slate-500">Uploading...</p>
          )}
          {uploadError && (
            <div className="rounded-md bg-red-50 px-3 py-2 text-sm text-red-600">
              {uploadError}
            </div>
          )}
        </div>

        <div className="flex flex-col gap-2">
          <h3 className="text-sm font-medium text-slate-700">
            Choose existing
          </h3>

          {existingStatus === "loading" && (
            <p className="text-sm text-slate-500">Loading...</p>
          )}

          {existingStatus === "error" && (
            <div className="rounded-md border border-red-200 bg-red-50 px-3 py-2 text-sm text-red-600">
              Failed to load media: {existingError}
              <Button
                variant="outline"
                size="sm"
                className="ml-3"
                onClick={retryExisting}
              >
                Retry
              </Button>
            </div>
          )}

          {existingStatus === "ready" && existingItems.length === 0 && (
            <p className="text-sm text-slate-500">
              No media uploaded yet — upload one above.
            </p>
          )}

          {existingStatus === "ready" && existingItems.length > 0 && (
            <div className="grid max-h-72 grid-cols-3 gap-2 overflow-y-auto">
              {existingItems.map((media) =>
                mediaType === "image" ? (
                  <button
                    key={media._id}
                    type="button"
                    onClick={() => handleSelectExisting(media)}
                    className="aspect-square overflow-hidden rounded-md border border-slate-200 hover:ring-2 hover:ring-cyan-500"
                  >
                    <img
                      src={media.url}
                      alt={media.filename}
                      className="size-full object-cover"
                    />
                  </button>
                ) : (
                  <button
                    key={media._id}
                    type="button"
                    onClick={() => handleSelectExisting(media)}
                    className="col-span-3 flex flex-col gap-1 rounded-md border border-slate-200 p-2 text-left hover:ring-2 hover:ring-cyan-500"
                  >
                    <span className="truncate text-sm text-slate-700">
                      {media.filename}
                    </span>
                    <audio
                      controls
                      src={media.url}
                      className="h-8 w-full"
                      onClick={(e) => e.stopPropagation()}
                    />
                  </button>
                ),
              )}
            </div>
          )}
        </div>
      </DialogContent>
    </Dialog>
  );
}
