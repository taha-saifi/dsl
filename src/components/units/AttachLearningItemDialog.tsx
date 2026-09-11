import { ImageOff } from "lucide-react";
import { useEffect, useRef, useState } from "react";
import { Button } from "@/components/ui/button";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import { Input } from "@/components/ui/input";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { listLearningItems } from "@/lib/resources/learningItems";
import { getMedia } from "@/lib/resources/media";
import type { LearningItem } from "@/types";

type Status = "loading" | "error" | "ready";
type TypeFilter = "all" | LearningItem["type"];

interface AttachLearningItemDialogProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  excludeIds: string[];
  onSelect: (item: LearningItem) => void;
}

export default function AttachLearningItemDialog({
  open,
  onOpenChange,
  excludeIds,
  onSelect,
}: AttachLearningItemDialogProps) {
  const [items, setItems] = useState<LearningItem[]>([]);
  const [status, setStatus] = useState<Status>("loading");
  const [errorMessage, setErrorMessage] = useState<string | null>(null);

  const [typeFilter, setTypeFilter] = useState<TypeFilter>("all");
  const [searchInput, setSearchInput] = useState("");
  const [debouncedSearch, setDebouncedSearch] = useState("");

  const [imageUrls, setImageUrls] = useState<Record<string, string>>({});
  const resolvedOrPendingIds = useRef<Set<string>>(new Set());

  useEffect(() => {
    if (!open) return;
    const timeout = setTimeout(() => {
      setDebouncedSearch(searchInput.trim());
    }, 300);
    return () => clearTimeout(timeout);
  }, [searchInput, open]);

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
    if (!open) return;
    fetchItems();
  }, [open, typeFilter, debouncedSearch]);

  useEffect(() => {
    if (!open) return;
    setTypeFilter("all");
    setSearchInput("");
    setDebouncedSearch("");
  }, [open]);

  const visibleItems = items.filter((item) => !excludeIds.includes(item._id));

  useEffect(() => {
    const idsToResolve = [
      ...new Set(
        visibleItems
          .map((item) => item.imageMediaId)
          .filter(
            (id): id is string =>
              Boolean(id) && !resolvedOrPendingIds.current.has(id!),
          ),
      ),
    ];
    if (idsToResolve.length === 0) return;
    idsToResolve.forEach((id) => resolvedOrPendingIds.current.add(id));

    // Always apply the result, even if a later effect invocation (e.g. React
    // StrictMode's dev-only double-invoke on mount) has since re-run this —
    // it's a pure additive id->url cache, so a "late" write is never wrong.
    Promise.all(
      idsToResolve.map((id) =>
        getMedia(id)
          .then((media) => [id, media.url] as const)
          .catch(() => null),
      ),
    ).then((results) => {
      setImageUrls((prev) => {
        const next = { ...prev };
        for (const entry of results) {
          if (entry) next[entry[0]] = entry[1];
        }
        return next;
      });
    });
  }, [items]);

  const filtersActive = typeFilter !== "all" || debouncedSearch !== "";

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="sm:max-w-lg">
        <DialogHeader>
          <DialogTitle>Attach Learning Item</DialogTitle>
        </DialogHeader>

        <div className="flex items-center gap-3">
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
          />
        </div>

        {status === "loading" && (
          <p className="text-sm text-slate-500">Loading learning items...</p>
        )}

        {status === "error" && (
          <div className="rounded-md border border-red-200 bg-red-50 px-3 py-2 text-sm text-red-600">
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
              : "No learning items exist yet."}
          </p>
        )}

        {status === "ready" && items.length > 0 && visibleItems.length === 0 && (
          <p className="text-sm text-slate-500">
            Every learning item{filtersActive ? " matching your filter" : ""}{" "}
            is already attached to this unit.
          </p>
        )}

        {status === "ready" && visibleItems.length > 0 && (
          <div className="flex max-h-80 flex-col gap-1 overflow-y-auto">
            {visibleItems.map((item) => {
              const firstTranslation = item.translations[0];
              return (
                <button
                  key={item._id}
                  type="button"
                  onClick={() => onSelect(item)}
                  className="flex items-center gap-3 rounded-md border border-transparent p-2 text-left hover:border-slate-200 hover:bg-slate-50"
                >
                  {item.imageMediaId && imageUrls[item.imageMediaId] ? (
                    <img
                      src={imageUrls[item.imageMediaId]}
                      alt=""
                      className="size-10 shrink-0 rounded-md border border-slate-200 object-cover"
                    />
                  ) : (
                    <div className="flex size-10 shrink-0 items-center justify-center rounded-md border border-slate-200 bg-slate-50 text-slate-300">
                      <ImageOff className="size-5" />
                    </div>
                  )}
                  <div className="flex flex-col">
                    <span className="text-sm font-medium text-slate-900">
                      {firstTranslation ? (
                        firstTranslation.text
                      ) : (
                        <span className="font-normal text-slate-400">
                          (no translations yet)
                        </span>
                      )}
                    </span>
                    <span className="text-xs capitalize text-slate-500">
                      {item.type}
                    </span>
                  </div>
                </button>
              );
            })}
          </div>
        )}
      </DialogContent>
    </Dialog>
  );
}
