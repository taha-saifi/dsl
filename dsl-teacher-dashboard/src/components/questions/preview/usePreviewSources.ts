import { useEffect, useState } from "react";
import { getLearningItem } from "@/lib/resources/learningItems";
import { getMedia } from "@/lib/resources/media";
import type { LearningItem, Media, QuestionItem } from "@/types";

/*
 * Page-lifetime caches, so flipping between previews or re-rendering the form
 * on every keystroke doesn't refetch the same learning items and images.
 */
const itemRequests = new Map<string, Promise<LearningItem | null>>();
const mediaRequests = new Map<string, Promise<Media | null>>();

function loadItem(id: string) {
  let request = itemRequests.get(id);
  if (!request) {
    request = getLearningItem(id).catch(() => {
      itemRequests.delete(id);
      return null;
    });
    itemRequests.set(id, request);
  }
  return request;
}

function loadMedia(id: string) {
  let request = mediaRequests.get(id);
  if (!request) {
    request = getMedia(id).catch(() => {
      mediaRequests.delete(id);
      return null;
    });
    mediaRequests.set(id, request);
  }
  return request;
}

/** Drops cached items and media, e.g. when a page mounts after edits elsewhere. */
export function resetPreviewCache() {
  itemRequests.clear();
  mediaRequests.clear();
}

/** Seeds the cache with an item the caller already has (e.g. just picked in a dialog). */
export function primeLearningItem(item: LearningItem) {
  itemRequests.set(item._id, Promise.resolve(item));
}

/**
 * Resolves the learning items a question references, plus their images
 * (choose_picture is the only renderer that shows them). Missing or failing
 * ids are simply left out; the preview shows a placeholder for them.
 */
export function usePreviewSources(items: QuestionItem[]) {
  const [itemsById, setItemsById] = useState<Record<string, LearningItem>>({});
  const [mediaById, setMediaById] = useState<Record<string, Media>>({});
  const [resolvedKey, setResolvedKey] = useState("");

  const idsKey = items.map((it) => it.learningItemId).join(",");

  useEffect(() => {
    const ids = idsKey ? idsKey.split(",") : [];
    let cancelled = false;

    Promise.all(ids.map(loadItem)).then(async (loaded) => {
      const found = loaded.filter((item): item is LearningItem => item !== null);
      const imageIds = found.flatMap((item) => (item.imageMediaId ? [item.imageMediaId] : []));
      const media = (await Promise.all(imageIds.map(loadMedia))).filter(
        (m): m is Media => m !== null,
      );
      if (cancelled) return;
      setItemsById(Object.fromEntries(found.map((item) => [item._id, item])));
      setMediaById(Object.fromEntries(media.map((m) => [m._id, m])));
      setResolvedKey(idsKey);
    });

    return () => {
      cancelled = true;
    };
  }, [idsKey]);

  return { itemsById, mediaById, loading: idsKey !== resolvedKey };
}
