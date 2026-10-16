import { useSortable } from "@dnd-kit/sortable";
import { CSS } from "@dnd-kit/utilities";
import { GripVertical, ImageOff } from "lucide-react";
import { Link } from "react-router-dom";
import { Button } from "@/components/ui/button";
import type { LearningItem } from "@/types";

interface SortableAttachedItemRowProps {
  learningItem: LearningItem;
  imageUrl?: string;
  onDetach: (learningItem: LearningItem) => void;
}

export default function SortableAttachedItemRow({
  learningItem,
  imageUrl,
  onDetach,
}: SortableAttachedItemRowProps) {
  const { attributes, listeners, setNodeRef, transform, transition, isDragging } =
    useSortable({ id: learningItem._id });

  const style = {
    transform: CSS.Transform.toString(transform),
    transition,
    opacity: isDragging ? 0.5 : 1,
  };

  const firstTranslation = learningItem.translations[0];

  return (
    <div
      ref={setNodeRef}
      style={style}
      className="flex items-center gap-3 border-b border-slate-200 p-3 last:border-b-0"
    >
      <button
        type="button"
        className="cursor-grab touch-none text-slate-400 hover:text-slate-600 active:cursor-grabbing"
        aria-label="Drag to reorder"
        {...attributes}
        {...listeners}
      >
        <GripVertical className="size-4" />
      </button>

      {imageUrl ? (
        <img
          src={imageUrl}
          alt=""
          className="size-10 shrink-0 rounded-md border border-slate-200 object-cover"
        />
      ) : (
        <div className="flex size-10 shrink-0 items-center justify-center rounded-md border border-slate-200 bg-slate-50 text-slate-300">
          <ImageOff className="size-5" />
        </div>
      )}

      <div className="flex flex-1 flex-col">
        <Link
          to={`/learning-items/${learningItem._id}`}
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
        <span className="text-xs capitalize text-slate-500">
          {learningItem.type}
        </span>
      </div>

      <Button
        variant="destructive"
        size="sm"
        onClick={() => onDetach(learningItem)}
      >
        Detach
      </Button>
    </div>
  );
}
