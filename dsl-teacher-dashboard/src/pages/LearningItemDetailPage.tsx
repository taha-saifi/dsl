import { ImageOff } from "lucide-react";
import { useEffect, useRef, useState } from "react";
import { Link, useNavigate, useParams } from "react-router-dom";
import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
} from "@/components/ui/alert-dialog";
import { Button } from "@/components/ui/button";
import { toast } from "@/components/ui/toast";
import LearningItemFormDialog from "@/components/learningItems/LearningItemFormDialog";
import TranslationFormDialog from "@/components/learningItems/TranslationFormDialog";
import { ApiError } from "@/lib/api";
import {
  deleteLearningItem,
  getLearningItem,
  removeTranslation,
} from "@/lib/resources/learningItems";
import { getMedia } from "@/lib/resources/media";
import type { LearningItem, Translation } from "@/types";

type Status = "loading" | "not-found" | "error" | "ready";

export default function LearningItemDetailPage() {
  const { learningItemId } = useParams<{ learningItemId: string }>();
  const navigate = useNavigate();

  const [item, setItem] = useState<LearningItem | null>(null);
  const [status, setStatus] = useState<Status>("loading");
  const [errorMessage, setErrorMessage] = useState<string | null>(null);

  const [mediaUrls, setMediaUrls] = useState<Record<string, string>>({});
  const resolvedOrPendingIds = useRef<Set<string>>(new Set());

  const [editItemOpen, setEditItemOpen] = useState(false);
  const [deleteItemOpen, setDeleteItemOpen] = useState(false);
  const [deletingItem, setDeletingItem] = useState(false);

  const [translationDialogOpen, setTranslationDialogOpen] = useState(false);
  const [editingTranslation, setEditingTranslation] = useState<
    Translation | undefined
  >(undefined);
  const [removeTarget, setRemoveTarget] = useState<Translation | null>(null);
  const [removingTranslation, setRemovingTranslation] = useState(false);

  function fetchItem() {
    if (!learningItemId) return;
    setStatus("loading");
    setErrorMessage(null);
    getLearningItem(learningItemId)
      .then((data) => {
        setItem(data);
        setStatus("ready");
      })
      .catch((err) => {
        if (err instanceof ApiError && err.status === 404) {
          setStatus("not-found");
        } else {
          setErrorMessage(
            err instanceof Error ? err.message : "Request failed",
          );
          setStatus("error");
        }
      });
  }

  useEffect(() => {
    fetchItem();
  }, [learningItemId]);

  useEffect(() => {
    if (!item) return;
    const ids = [
      item.imageMediaId,
      ...item.translations.map((t) => t.audioMediaId),
    ].filter(
      (id): id is string =>
        Boolean(id) && !resolvedOrPendingIds.current.has(id!),
    );
    const uniqueIds = [...new Set(ids)];
    if (uniqueIds.length === 0) return;
    uniqueIds.forEach((id) => resolvedOrPendingIds.current.add(id));

    // Always apply the result, even if a later effect invocation (e.g. React
    // StrictMode's dev-only double-invoke on mount) has since re-run this —
    // it's a pure additive id->url cache, so a "late" write is never wrong.
    Promise.all(
      uniqueIds.map((id) =>
        getMedia(id)
          .then((media) => [id, media.url] as const)
          .catch(() => null),
      ),
    ).then((results) => {
      setMediaUrls((prev) => {
        const next = { ...prev };
        for (const entry of results) {
          if (entry) next[entry[0]] = entry[1];
        }
        return next;
      });
    });
  }, [item]);

  function handleItemSaved() {
    fetchItem();
  }

  async function handleConfirmDeleteItem() {
    if (!item) return;
    setDeletingItem(true);
    try {
      await deleteLearningItem(item._id);
      navigate("/learning-items");
    } catch (err) {
      toast.add({
        type: "error",
        title: "Could not delete learning item",
        description: err instanceof Error ? err.message : "Request failed",
      });
    } finally {
      setDeletingItem(false);
      setDeleteItemOpen(false);
    }
  }

  function openAddTranslation() {
    setEditingTranslation(undefined);
    setTranslationDialogOpen(true);
  }

  function openEditTranslation(translation: Translation) {
    setEditingTranslation(translation);
    setTranslationDialogOpen(true);
  }

  function handleTranslationSaved(updated: LearningItem) {
    setItem(updated);
  }

  async function handleConfirmRemoveTranslation() {
    if (!item || !removeTarget) return;
    setRemovingTranslation(true);
    try {
      const updated = await removeTranslation(item._id, removeTarget.language);
      setItem(updated);
    } catch (err) {
      toast.add({
        type: "error",
        title: "Could not remove translation",
        description: err instanceof Error ? err.message : "Request failed",
      });
    } finally {
      setRemovingTranslation(false);
      setRemoveTarget(null);
    }
  }

  if (status === "loading") {
    return <p className="text-sm text-slate-500">Loading learning item...</p>;
  }

  if (status === "not-found") {
    return (
      <div>
        <Link
          to="/learning-items"
          className="text-sm text-cyan-700 hover:underline"
        >
          ← Back to Learning Items
        </Link>
        <div className="mt-4 rounded-md border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-600">
          Learning item not found.
        </div>
      </div>
    );
  }

  if (status === "error") {
    return (
      <div>
        <Link
          to="/learning-items"
          className="text-sm text-cyan-700 hover:underline"
        >
          ← Back to Learning Items
        </Link>
        <div className="mt-4 rounded-md border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-600">
          Failed to load learning item: {errorMessage}
          <Button
            variant="outline"
            size="sm"
            className="ml-3"
            onClick={fetchItem}
          >
            Retry
          </Button>
        </div>
      </div>
    );
  }

  if (!item) return null;

  return (
    <div className="flex flex-col gap-8">
      <div>
        <Link
          to="/learning-items"
          className="text-sm text-cyan-700 hover:underline"
        >
          ← Back to Learning Items
        </Link>

        <div className="mt-2 flex items-start justify-between">
          <div className="flex items-center gap-4">
            {item.imageMediaId && mediaUrls[item.imageMediaId] ? (
              <img
                src={mediaUrls[item.imageMediaId]}
                alt=""
                className="size-16 rounded-md border border-slate-200 object-cover"
              />
            ) : (
              <div className="flex size-16 items-center justify-center rounded-md border border-slate-200 bg-slate-50 text-slate-300">
                <ImageOff className="size-6" />
              </div>
            )}
            <h1 className="text-xl font-semibold text-slate-900 capitalize">
              {item.type}
            </h1>
          </div>

          <div className="flex gap-2">
            <Button
              variant="outline"
              size="sm"
              onClick={() => setEditItemOpen(true)}
            >
              Edit
            </Button>
            <Button
              variant="destructive"
              size="sm"
              onClick={() => setDeleteItemOpen(true)}
            >
              Delete this item
            </Button>
          </div>
        </div>
      </div>

      <div>
        <div className="mb-3 flex items-center justify-between">
          <h2 className="text-lg font-semibold text-slate-900">
            Translations
          </h2>
          <Button size="sm" onClick={openAddTranslation}>
            Add Translation
          </Button>
        </div>

        {item.translations.length === 0 && (
          <p className="text-sm text-slate-500">No translations yet.</p>
        )}

        {item.translations.length > 0 && (
          <div className="flex flex-col divide-y divide-slate-200 rounded-md border border-slate-200">
            {item.translations.map((translation) => (
              <div
                key={translation.language}
                className="flex items-center justify-between gap-4 p-3"
              >
                <div className="flex flex-col gap-1">
                  <div className="flex items-center gap-2">
                    <span className="rounded bg-slate-100 px-1.5 py-0.5 text-xs font-medium uppercase text-slate-600">
                      {translation.language}
                    </span>
                    <span className="font-medium text-slate-900">
                      {translation.text}
                    </span>
                  </div>
                  {(translation.pronunciation || translation.ipa) && (
                    <p className="text-sm text-slate-500">
                      {translation.pronunciation}
                      {translation.pronunciation && translation.ipa
                        ? " · "
                        : ""}
                      {translation.ipa && `/${translation.ipa}/`}
                    </p>
                  )}
                  {translation.audioMediaId &&
                    mediaUrls[translation.audioMediaId] && (
                      <audio
                        controls
                        src={mediaUrls[translation.audioMediaId]}
                        className="h-8"
                      />
                    )}
                </div>

                <div className="flex shrink-0 gap-2">
                  <Button
                    variant="outline"
                    size="sm"
                    onClick={() => openEditTranslation(translation)}
                  >
                    Edit
                  </Button>
                  <Button
                    variant="destructive"
                    size="sm"
                    onClick={() => setRemoveTarget(translation)}
                  >
                    Remove
                  </Button>
                </div>
              </div>
            ))}
          </div>
        )}
      </div>

      <LearningItemFormDialog
        open={editItemOpen}
        onOpenChange={setEditItemOpen}
        learningItem={item}
        onSaved={handleItemSaved}
      />

      <TranslationFormDialog
        open={translationDialogOpen}
        onOpenChange={setTranslationDialogOpen}
        itemId={item._id}
        translation={editingTranslation}
        onSaved={handleTranslationSaved}
      />

      <AlertDialog open={deleteItemOpen} onOpenChange={setDeleteItemOpen}>
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>Delete learning item?</AlertDialogTitle>
            <AlertDialogDescription>
              This will permanently delete this item. This cannot be undone.
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel disabled={deletingItem}>
              Cancel
            </AlertDialogCancel>
            <AlertDialogAction
              disabled={deletingItem}
              onClick={handleConfirmDeleteItem}
            >
              {deletingItem ? "Deleting..." : "Delete"}
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>

      <AlertDialog
        open={removeTarget !== null}
        onOpenChange={(open) => {
          if (!open) setRemoveTarget(null);
        }}
      >
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>Remove translation?</AlertDialogTitle>
            <AlertDialogDescription>
              This will remove the "{removeTarget?.language}" translation.
              This cannot be undone.
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel disabled={removingTranslation}>
              Cancel
            </AlertDialogCancel>
            <AlertDialogAction
              disabled={removingTranslation}
              onClick={handleConfirmRemoveTranslation}
            >
              {removingTranslation ? "Removing..." : "Remove"}
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </div>
  );
}
