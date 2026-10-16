import { useSortable } from "@dnd-kit/sortable";
import { CSS } from "@dnd-kit/utilities";
import { Eye, GripVertical, Trash2 } from "lucide-react";
import { Button } from "@/components/ui/button";
import QuestionTypeGlyph from "@/components/questions/QuestionTypeGlyph";
import { QUESTION_TYPE_INFO } from "@/lib/questionTypes";
import type { Question } from "@/types";

interface SortableQuestionRowProps {
  question: Question;
  /** 1-based position in the exercise. */
  position: number;
  onEdit: (question: Question) => void;
  onPreview: (question: Question) => void;
  onDelete: (question: Question) => void;
}

export default function SortableQuestionRow({
  question,
  position,
  onEdit,
  onPreview,
  onDelete,
}: SortableQuestionRowProps) {
  const { attributes, listeners, setNodeRef, transform, transition, isDragging } =
    useSortable({ id: question._id });

  const style = {
    transform: CSS.Transform.toString(transform),
    transition,
  };
  const info = QUESTION_TYPE_INFO[question.type];
  const itemCount = question.items.length;

  return (
    <li
      ref={setNodeRef}
      style={style}
      className={
        "group flex items-center gap-3 border-b border-slate-200 bg-white py-2.5 pr-3 pl-2 last:border-b-0 " +
        (isDragging ? "relative z-10 shadow-lg ring-1 ring-cyan-600/30" : "hover:bg-slate-50/80")
      }
    >
      <button
        type="button"
        className="cursor-grab touch-none rounded p-1 text-slate-300 hover:text-slate-500 focus-visible:text-slate-600 focus-visible:ring-2 focus-visible:ring-cyan-500/40 focus-visible:outline-none active:cursor-grabbing"
        aria-label={`Drag to reorder question ${position}`}
        {...attributes}
        {...listeners}
      >
        <GripVertical className="size-4" />
      </button>

      <span className="w-5 text-right text-sm font-medium text-slate-400 tabular-nums">
        {position}
      </span>

      <QuestionTypeGlyph
        type={question.type}
        className="text-slate-200 [--glyph-accent:#06b6d4]"
      />

      <button
        type="button"
        onClick={() => onEdit(question)}
        className="flex min-w-0 flex-1 flex-col items-start gap-0.5 rounded text-left focus-visible:ring-2 focus-visible:ring-cyan-500/40 focus-visible:outline-none"
      >
        <span className="w-full truncate text-sm font-medium text-slate-900 group-hover:text-cyan-800">
          {question.displayText}
        </span>
        <span className="flex flex-wrap items-center gap-x-3 gap-y-0.5 text-xs text-slate-500">
          <span className="font-medium text-slate-600">{info.label}</span>
          <span>{question.points} points</span>
          <span>
            {itemCount} {itemCount === 1 ? "item" : "items"}
          </span>
          {!question.questionText && (
            <span className="text-slate-400 italic">Default text</span>
          )}
        </span>
      </button>

      <div className="flex shrink-0 items-center gap-1">
        <Button variant="ghost" size="sm" onClick={() => onPreview(question)}>
          <Eye data-icon="inline-start" />
          Preview
        </Button>
        <Button variant="outline" size="sm" onClick={() => onEdit(question)}>
          Edit
        </Button>
        <Button
          variant="ghost"
          size="icon-sm"
          className="text-slate-400 hover:bg-red-50 hover:text-red-600"
          onClick={() => onDelete(question)}
          aria-label={`Delete question ${position}`}
        >
          <Trash2 />
        </Button>
      </div>
    </li>
  );
}
