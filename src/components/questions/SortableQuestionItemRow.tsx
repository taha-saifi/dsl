import { useSortable } from "@dnd-kit/sortable";
import { CSS } from "@dnd-kit/utilities";
import { GripVertical } from "lucide-react";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { Button } from "@/components/ui/button";
import type { LearningItem, QuestionItem } from "@/types";

interface SortableQuestionItemRowProps {
  item: QuestionItem;
  learningItem?: LearningItem;
  onRoleChange: (role: QuestionItem["role"]) => void;
  onRemove: () => void;
}

export default function SortableQuestionItemRow({
  item,
  learningItem,
  onRoleChange,
  onRemove,
}: SortableQuestionItemRowProps) {
  const { attributes, listeners, setNodeRef, transform, transition, isDragging } =
    useSortable({ id: item.learningItemId });

  const style = {
    transform: CSS.Transform.toString(transform),
    transition,
    opacity: isDragging ? 0.5 : 1,
  };

  const firstTranslation = learningItem?.translations[0];

  return (
    <div
      ref={setNodeRef}
      style={style}
      className="flex items-center gap-3 border-b border-slate-200 p-2 last:border-b-0"
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

      <span className="flex-1 truncate text-sm text-slate-900">
        {learningItem ? (
          firstTranslation ? (
            firstTranslation.text
          ) : (
            <span className="text-slate-400">(no translations yet)</span>
          )
        ) : (
          <span className="text-slate-400">Loading...</span>
        )}
      </span>

      <Select
        value={item.role}
        onValueChange={(value) => onRoleChange(value as QuestionItem["role"])}
      >
        <SelectTrigger className="w-28" size="sm">
          <SelectValue />
        </SelectTrigger>
        <SelectContent>
          <SelectItem value="target">target</SelectItem>
          <SelectItem value="distractor">distractor</SelectItem>
          <SelectItem value="pair">pair</SelectItem>
        </SelectContent>
      </Select>

      <Button type="button" variant="outline" size="sm" onClick={onRemove}>
        Remove
      </Button>
    </div>
  );
}
