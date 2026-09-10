import { useEffect, useRef, useState } from "react";
import { Button } from "@/components/ui/button";
import MediaPicker from "@/components/media/MediaPicker";
import { getMedia } from "@/lib/resources/media";
import type { Media } from "@/types";

interface MediaAttachFieldProps {
  mediaId?: string;
  mediaType: "image" | "audio";
  label: string;
  onChange: (mediaId: string | undefined) => void;
}

export default function MediaAttachField({
  mediaId,
  mediaType,
  label,
  onChange,
}: MediaAttachFieldProps) {
  const [media, setMedia] = useState<Media | null>(null);
  const [loading, setLoading] = useState(false);
  const [pickerOpen, setPickerOpen] = useState(false);
  // Tracks the id of the object we already hold locally (from a selection),
  // so the effect below doesn't kick off a redundant refetch for it — and so
  // a fetch already in flight for a since-changed id can be told to ignore
  // its (now stale) result instead of clobbering a later Remove/selection.
  const knownIdRef = useRef<string | undefined>(undefined);

  useEffect(() => {
    if (!mediaId) {
      setMedia(null);
      return;
    }
    if (mediaId === knownIdRef.current) {
      return;
    }
    let cancelled = false;
    setLoading(true);
    getMedia(mediaId)
      .then((fetched) => {
        if (cancelled) return;
        knownIdRef.current = fetched._id;
        setMedia(fetched);
      })
      .catch(() => {
        if (!cancelled) setMedia(null);
      })
      .finally(() => {
        if (!cancelled) setLoading(false);
      });
    return () => {
      cancelled = true;
    };
  }, [mediaId]);

  function handleSelect(selected: Media) {
    knownIdRef.current = selected._id;
    setMedia(selected);
    onChange(selected._id);
  }

  function handleRemove() {
    knownIdRef.current = undefined;
    setMedia(null);
    onChange(undefined);
  }

  return (
    <div>
      {media ? (
        <div className="flex items-center gap-3">
          {mediaType === "image" ? (
            <img
              src={media.url}
              alt={media.filename}
              className="size-16 rounded-md border border-slate-200 object-cover"
            />
          ) : (
            <audio controls src={media.url} className="h-8" />
          )}
          <div className="flex gap-2">
            <Button
              type="button"
              variant="outline"
              size="sm"
              onClick={() => setPickerOpen(true)}
            >
              Change
            </Button>
            <Button
              type="button"
              variant="outline"
              size="sm"
              onClick={handleRemove}
            >
              Remove
            </Button>
          </div>
        </div>
      ) : (
        <Button
          type="button"
          variant="outline"
          size="sm"
          disabled={loading}
          onClick={() => setPickerOpen(true)}
        >
          {loading ? "Loading..." : `Attach ${label}`}
        </Button>
      )}

      <MediaPicker
        open={pickerOpen}
        onOpenChange={setPickerOpen}
        mediaType={mediaType}
        onSelect={handleSelect}
      />
    </div>
  );
}
