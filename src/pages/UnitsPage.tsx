import {
  DndContext,
  PointerSensor,
  closestCenter,
  useSensor,
  useSensors,
  type DragEndEvent,
} from "@dnd-kit/core";
import {
  SortableContext,
  arrayMove,
  verticalListSortingStrategy,
} from "@dnd-kit/sortable";
import { useEffect, useState } from "react";
import { Link, useParams } from "react-router-dom";
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
import {
  Table,
  TableBody,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import { toast } from "@/components/ui/toast";
import SortableUnitRow from "@/components/units/SortableUnitRow";
import UnitFormDialog from "@/components/units/UnitFormDialog";
import { ApiError } from "@/lib/api";
import { getCourse } from "@/lib/resources/courses";
import { deleteUnit, listUnits, reorderUnits } from "@/lib/resources/units";
import type { Course, Unit } from "@/types";

type Status = "loading" | "not-found" | "error" | "ready";

export default function UnitsPage() {
  const { courseId } = useParams<{ courseId: string }>();

  const [course, setCourse] = useState<Course | null>(null);
  const [units, setUnits] = useState<Unit[]>([]);
  const [status, setStatus] = useState<Status>("loading");
  const [errorMessage, setErrorMessage] = useState<string | null>(null);

  const [formOpen, setFormOpen] = useState(false);
  const [editingUnit, setEditingUnit] = useState<Unit | undefined>(undefined);

  const [deleteTarget, setDeleteTarget] = useState<Unit | null>(null);
  const [deleting, setDeleting] = useState(false);

  const sensors = useSensors(
    useSensor(PointerSensor, {
      activationConstraint: { distance: 5 },
    }),
  );

  function fetchData() {
    if (!courseId) return;
    setStatus("loading");
    setErrorMessage(null);
    Promise.all([getCourse(courseId), listUnits({ courseId })])
      .then(([courseData, unitList]) => {
        setCourse(courseData);
        setUnits(unitList);
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
    fetchData();
  }, [courseId]);

  function openCreateDialog() {
    setEditingUnit(undefined);
    setFormOpen(true);
  }

  function openEditDialog(unit: Unit) {
    setEditingUnit(unit);
    setFormOpen(true);
  }

  function handleSaved(saved: Unit) {
    setUnits((prev) => {
      const exists = prev.some((u) => u._id === saved._id);
      if (exists) {
        return prev.map((u) => (u._id === saved._id ? saved : u));
      }
      return [...prev, saved].sort((a, b) => a.orderIndex - b.orderIndex);
    });
  }

  async function handleConfirmDelete() {
    if (!deleteTarget) return;
    const target = deleteTarget;
    setDeleting(true);
    try {
      await deleteUnit(target._id);
      setUnits((prev) => prev.filter((u) => u._id !== target._id));
    } catch (err) {
      toast.add({
        type: "error",
        title: "Could not delete unit",
        description: err instanceof Error ? err.message : "Request failed",
      });
    } finally {
      setDeleting(false);
      setDeleteTarget(null);
    }
  }

  async function handleDragEnd(event: DragEndEvent) {
    const { active, over } = event;
    if (!over || active.id === over.id || !courseId) return;

    const oldIndex = units.findIndex((u) => u._id === active.id);
    const newIndex = units.findIndex((u) => u._id === over.id);
    if (oldIndex === -1 || newIndex === -1) return;

    const previousUnits = units;
    const reordered = arrayMove(units, oldIndex, newIndex).map((u, index) => ({
      ...u,
      orderIndex: index,
    }));
    setUnits(reordered);

    try {
      const saved = await reorderUnits(
        courseId,
        reordered.map((u) => ({ id: u._id, orderIndex: u.orderIndex })),
      );
      setUnits([...saved].sort((a, b) => a.orderIndex - b.orderIndex));
    } catch (err) {
      setUnits(previousUnits);
      toast.add({
        type: "error",
        title: "Could not reorder units",
        description: err instanceof Error ? err.message : "Request failed",
      });
    }
  }

  if (status === "loading") {
    return <p className="text-sm text-slate-500">Loading units...</p>;
  }

  if (status === "not-found") {
    return (
      <div>
        <Link
          to="/specializations"
          className="text-sm text-cyan-700 hover:underline"
        >
          ← Back to Specializations
        </Link>
        <div className="mt-4 rounded-md border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-600">
          Course not found.
        </div>
      </div>
    );
  }

  if (status === "error") {
    return (
      <div>
        <Link
          to="/specializations"
          className="text-sm text-cyan-700 hover:underline"
        >
          ← Back to Specializations
        </Link>
        <div className="mt-4 rounded-md border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-600">
          Failed to load units: {errorMessage}
          <Button
            variant="outline"
            size="sm"
            className="ml-3"
            onClick={fetchData}
          >
            Retry
          </Button>
        </div>
      </div>
    );
  }

  const nextOrderIndex =
    units.length > 0
      ? Math.max(...units.map((u) => u.orderIndex)) + 1
      : 0;

  return (
    <div>
      {course && (
        <Link
          to={`/specializations/${course.specializationId}/courses`}
          className="text-sm text-cyan-700 hover:underline"
        >
          ← Back to Courses
        </Link>
      )}

      <div className="mt-2 mb-4 flex items-center justify-between">
        <h1 className="text-xl font-semibold text-slate-900">
          {course?.name} — Units
        </h1>
        <Button onClick={openCreateDialog}>New Unit</Button>
      </div>

      {units.length === 0 && (
        <p className="text-sm text-slate-500">No units yet.</p>
      )}

      {units.length > 0 && (
        <DndContext
          sensors={sensors}
          collisionDetection={closestCenter}
          onDragEnd={handleDragEnd}
        >
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead className="w-8" />
                <TableHead>Name</TableHead>
                <TableHead className="text-right">Actions</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              <SortableContext
                items={units.map((u) => u._id)}
                strategy={verticalListSortingStrategy}
              >
                {units.map((unit) => (
                  <SortableUnitRow
                    key={unit._id}
                    unit={unit}
                    onEdit={openEditDialog}
                    onDelete={setDeleteTarget}
                  />
                ))}
              </SortableContext>
            </TableBody>
          </Table>
        </DndContext>
      )}

      {courseId && (
        <UnitFormDialog
          open={formOpen}
          onOpenChange={setFormOpen}
          courseId={courseId}
          unit={editingUnit}
          nextOrderIndex={nextOrderIndex}
          onSaved={handleSaved}
        />
      )}

      <AlertDialog
        open={deleteTarget !== null}
        onOpenChange={(open) => {
          if (!open) setDeleteTarget(null);
        }}
      >
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>Delete unit?</AlertDialogTitle>
            <AlertDialogDescription>
              This will permanently delete "{deleteTarget?.name}". This
              cannot be undone.
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
