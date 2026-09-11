import { ImageOff } from "lucide-react";
import { useEffect, useRef, useState } from "react";
import { Link } from "react-router-dom";
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
import { Input } from "@/components/ui/input";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import { toast } from "@/components/ui/toast";
import LearningItemFormDialog from "@/components/learningItems/LearningItemFormDialog";
import { getMedia } from "@/lib/resources/media";
import {
  deleteLearningItem,
  listLearningItems,
} from "@/lib/resources/learningItems";
import type { LearningItem } from "@/types";

type Status = "loading" | "error" | "ready";
type TypeFilter = "all" | LearningItem["type"];

export default function LearningItemsPage() {
  const [items, setItems] = useState<LearningItem[]>([]);
  const [status, setStatus] = useState<Status>("loading");
  const [errorMessage, setErrorMessage] = useState<string | null>(null);

  const [typeFilter, setTypeFilter] = useState<TypeFilter>("all");
  const [searchInput, setSearchInput] = useState("");
  const [debouncedSearch, setDebouncedSearch] = useState("");

  const [formOpen, setFormOpen] = useState(false);
  const [editingItem, setEditingItem] = useState<LearningItem | undefined>(
    undefined,
  );

  const [deleteTarget, setDeleteTarget] = useState<LearningItem | null>(null);
  const [deleting, setDeleting] = useState(false);

  const [imageUrls, setImageUrls] = useState<Record<string, string>>({});
  const resolvedOrPendingIds = useRef<Set<string>>(new Set());

  useEffect(() => {
    const idsToResolve = [
      ...new Set(
        items
          .map((item) => item.imageMediaId)
          .filter(
            (id): id is string =>
              Boolean(id) && !resolvedOrPendingIds.current.has(id!),
          ),
      ),
    ];
    if (idsToResolve.length === 0) return;
    idsToResolve.forEach((id) => resolvedOrPendingIds.current.add(id));

    let cancelled = false;
    Promise.all(
      idsToResolve.map((id) =>
        getMedia(id)
          .then((media) => [id, media.url] as const)
          .catch(() => null),
      ),
    ).then((results) => {
      if (cancelled) return;
      setImageUrls((prev) => {
        const next = { ...prev };
        for (const entry of results) {
          if (entry) next[entry[0]] = entry[1];
        }
        return next;
      });
    });

    return () => {
      cancelled = true;
    };
  }, [items]);

  useEffect(() => {
    const timeout = setTimeout(() => {
      setDebouncedSearch(searchInput.trim());
    }, 300);
    return () => clearTimeout(timeout);
  }, [searchInput]);

  function fetchItems() {
    setStatus("loading");
    setErrorMessage(null);
    listLearningItems({
      type: typeFilter === "all" ? undefined : typeFilter,
      search: debouncedSearch || undefined,
    })
      .then((data) => {
        setItems(data);
        setStatus("ready");
      })
      .catch((err) => {
        setErrorMessage(err instanceof Error ? err.message : "Request failed");
        setStatus("error");
      });
  }

  useEffect(() => {
    fetchItems();
  }, [typeFilter, debouncedSearch]);

  function openCreateDialog() {
    setEditingItem(undefined);
    setFormOpen(true);
  }

  function openEditDialog(item: LearningItem) {
    setEditingItem(item);
    setFormOpen(true);
  }

  function handleSaved(saved: LearningItem) {
    setItems((prev) => {
      const exists = prev.some((i) => i._id === saved._id);
      if (exists) {
        return prev.map((i) => (i._id === saved._id ? saved : i));
      }
      return [saved, ...prev];
    });
  }

  async function handleConfirmDelete() {
    if (!deleteTarget) return;
    const target = deleteTarget;
    setDeleting(true);
    try {
      await deleteLearningItem(target._id);
      setItems((prev) => prev.filter((i) => i._id !== target._id));
    } catch (err) {
      toast.add({
        type: "error",
        title: "Could not delete learning item",
        description: err instanceof Error ? err.message : "Request failed",
      });
    } finally {
      setDeleting(false);
      setDeleteTarget(null);
    }
  }

  const filtersActive = typeFilter !== "all" || debouncedSearch !== "";

  return (
    <div>
      <div className="mb-4 flex items-center justify-between">
        <h1 className="text-xl font-semibold text-slate-900">
          Learning Items
        </h1>
        <Button onClick={openCreateDialog}>New Learning Item</Button>
      </div>

      <div className="mb-4 flex items-center gap-3">
        <Select
          value={typeFilter}
          onValueChange={(value) => setTypeFilter(value as TypeFilter)}
        >
          <SelectTrigger className="w-36">
            <SelectValue />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="all">All</SelectItem>
            <SelectItem value="word">Word</SelectItem>
            <SelectItem value="phrase">Phrase</SelectItem>
            <SelectItem value="sentence">Sentence</SelectItem>
          </SelectContent>
        </Select>

        <Input
          placeholder="Search translations..."
          value={searchInput}
          onChange={(e) => setSearchInput(e.target.value)}
          className="max-w-xs"
        />
      </div>

      {status === "loading" && (
        <p className="text-sm text-slate-500">Loading learning items...</p>
      )}

      {status === "error" && (
        <div className="rounded-md border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-600">
          Failed to load learning items: {errorMessage}
          <Button
            variant="outline"
            size="sm"
            className="ml-3"
            onClick={fetchItems}
          >
            Retry
          </Button>
        </div>
      )}

      {status === "ready" && items.length === 0 && (
        <p className="text-sm text-slate-500">
          {filtersActive
            ? "No items match your search/filter."
            : "No learning items yet."}
        </p>
      )}

      {status === "ready" && items.length > 0 && (
        <Table>
          <TableHeader>
            <TableRow>
              <TableHead className="w-16">Image</TableHead>
              <TableHead>Type</TableHead>
              <TableHead>Text</TableHead>
              <TableHead className="text-right">Actions</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {items.map((item) => {
              const firstTranslation = item.translations[0];
              return (
                <TableRow key={item._id}>
                  <TableCell>
                    {item.imageMediaId && imageUrls[item.imageMediaId] ? (
                      <img
                        src={imageUrls[item.imageMediaId]}
                        alt=""
                        className="size-10 rounded-md border border-slate-200 object-cover"
                      />
                    ) : (
                      <div className="flex size-10 items-center justify-center rounded-md border border-slate-200 bg-slate-50 text-slate-300">
                        <ImageOff className="size-5" />
                      </div>
                    )}
                  </TableCell>
                  <TableCell className="capitalize text-slate-700">
                    {item.type}
                  </TableCell>
                  <TableCell>
                    <Link
                      to={`/learning-items/${item._id}`}
                      className="font-medium text-cyan-700 hover:underline"
                    >
                      {firstTranslation ? (
                        firstTranslation.text
                      ) : (
                        <span className="font-normal text-slate-400">
                          (no translations yet)
                        </span>
                      )}
                    </Link>
                  </TableCell>
                  <TableCell className="text-right">
                    <Button
                      variant="outline"
                      size="sm"
                      className="mr-2"
                      onClick={() => openEditDialog(item)}
                    >
                      Edit
                    </Button>
                    <Button
                      variant="destructive"
                      size="sm"
                      onClick={() => setDeleteTarget(item)}
                    >
                      Delete
                    </Button>
                  </TableCell>
                </TableRow>
              );
            })}
          </TableBody>
        </Table>
      )}

      <LearningItemFormDialog
        open={formOpen}
        onOpenChange={setFormOpen}
        learningItem={editingItem}
        onSaved={handleSaved}
      />

      <AlertDialog
        open={deleteTarget !== null}
        onOpenChange={(open) => {
          if (!open) setDeleteTarget(null);
        }}
      >
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>Delete learning item?</AlertDialogTitle>
            <AlertDialogDescription>
              This will permanently delete this item. This cannot be undone.
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel disabled={deleting}>Cancel</AlertDialogCancel>
            <AlertDialogAction
              disabled={deleting}
              onClick={handleConfirmDelete}
            >
              {deleting ? "Deleting..." : "Delete"}
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </div>
  );
}
