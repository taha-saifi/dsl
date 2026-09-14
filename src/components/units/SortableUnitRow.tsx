import { useSortable } from "@dnd-kit/sortable";
import { CSS } from "@dnd-kit/utilities";
import { GripVertical } from "lucide-react";
import { Link } from "react-router-dom";
import PublishToggle from "@/components/PublishToggle";
import { Button } from "@/components/ui/button";
import { TableCell, TableRow } from "@/components/ui/table";
import type { Unit } from "@/types";

interface SortableUnitRowProps {
  unit: Unit;
  onEdit: (unit: Unit) => void;
  onDelete: (unit: Unit) => void;
  onTogglePublish: (unit: Unit) => Promise<void>;
}

export default function SortableUnitRow({
  unit,
  onEdit,
  onDelete,
  onTogglePublish,
}: SortableUnitRowProps) {
  const { attributes, listeners, setNodeRef, transform, transition, isDragging } =
    useSortable({ id: unit._id });

  const style = {
    transform: CSS.Transform.toString(transform),
    transition,
    opacity: isDragging ? 0.5 : 1,
  };

  return (
    <TableRow ref={setNodeRef} style={style}>
      <TableCell className="w-8">
        <button
          type="button"
          className="cursor-grab touch-none text-slate-400 hover:text-slate-600 active:cursor-grabbing"
          aria-label="Drag to reorder"
          {...attributes}
          {...listeners}
        >
          <GripVertical className="size-4" />
        </button>
      </TableCell>
      <TableCell>
        <Link
          to={`/units/${unit._id}`}
          className="font-medium text-cyan-700 hover:underline"
        >
          {unit.name}
        </Link>
      </TableCell>
      <TableCell>
        <PublishToggle
          isPublished={unit.isPublished}
          onToggle={() => onTogglePublish(unit)}
        />
      </TableCell>
      <TableCell className="text-right">
        <Button
          variant="outline"
          size="sm"
          className="mr-2"
          onClick={() => onEdit(unit)}
        >
          Edit
        </Button>
        <Button variant="destructive" size="sm" onClick={() => onDelete(unit)}>
          Delete
        </Button>
      </TableCell>
    </TableRow>
  );
}
