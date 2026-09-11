import { useSortable } from "@dnd-kit/sortable";
import { CSS } from "@dnd-kit/utilities";
import { GripVertical } from "lucide-react";
import { Link } from "react-router-dom";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import type { Exercise } from "@/types";

interface SortableExerciseRowProps {
  exercise: Exercise;
  onEdit: (exercise: Exercise) => void;
  onDelete: (exercise: Exercise) => void;
}

export default function SortableExerciseRow({
  exercise,
  onEdit,
  onDelete,
}: SortableExerciseRowProps) {
  const { attributes, listeners, setNodeRef, transform, transition, isDragging } =
    useSortable({ id: exercise._id });

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

      <div className="flex flex-1 items-center gap-2">
        <Link
          to={`/exercises/${exercise._id}`}
          className="font-medium text-cyan-700 hover:underline"
        >
          {exercise.name}
        </Link>
        <Badge
          className={
            exercise.isPublished
              ? "bg-emerald-100 text-emerald-700"
              : "bg-slate-100 text-slate-500"
          }
        >
          {exercise.isPublished ? "Published" : "Draft"}
        </Badge>
      </div>

      <Button variant="outline" size="sm" onClick={() => onEdit(exercise)}>
        Edit
      </Button>
      <Button variant="destructive" size="sm" onClick={() => onDelete(exercise)}>
        Delete
      </Button>
    </div>
  );
}
