import { useSortable } from "@dnd-kit/sortable";
import { CSS } from "@dnd-kit/utilities";
import { GripVertical } from "lucide-react";
import { Button } from "@/components/ui/button";
import type { Question } from "@/types";

interface SortableQuestionRowProps {
  question: Question;
  onEdit: (question: Question) => void;
  onDelete: (question: Question) => void;
}

export default function SortableQuestionRow({
  question,
  onEdit,
  onDelete,
}: SortableQuestionRowProps) {
  const { attributes, listeners, setNodeRef, transform, transition, isDragging } =
    useSortable({ id: question._id });

  const style = {
    transform: CSS.Transform.toString(transform),
    transition,
    opacity: isDragging ? 0.5 : 1,
  };

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

      <button
        type="button"
        onClick={() => onEdit(question)}
        className="flex-1 text-left"
      >
        <span className="font-medium text-cyan-700 hover:underline">
          {question.type}
        </span>
        <span className="ml-2 text-sm text-slate-500">
          {question.points} points · {question.items.length}{" "}
          {question.items.length === 1 ? "item" : "items"}
        </span>
      </button>

      <Button variant="outline" size="sm" onClick={() => onEdit(question)}>
        Edit
      </Button>
      <Button
        variant="destructive"
        size="sm"
        onClick={() => onDelete(question)}
      >
        Delete
      </Button>
    </div>
  );
}
