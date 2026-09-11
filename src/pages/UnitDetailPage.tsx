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
import ExerciseFormDialog from "@/components/exercises/ExerciseFormDialog";
import SortableExerciseRow from "@/components/exercises/SortableExerciseRow";
import AttachLearningItemDialog from "@/components/units/AttachLearningItemDialog";
import SortableAttachedItemRow from "@/components/units/SortableAttachedItemRow";
import UnitFormDialog from "@/components/units/UnitFormDialog";
import { ApiError } from "@/lib/api";
import { getCourse } from "@/lib/resources/courses";
import {
  deleteExercise,
  listExercises,
  reorderExercises,
} from "@/lib/resources/exercises";
import { getLearningItem } from "@/lib/resources/learningItems";
import { getMedia } from "@/lib/resources/media";
import {
  attachLearningItem,
  deleteUnit,
  detachLearningItem,
  getUnit,
  reorderUnitLearningItems,
} from "@/lib/resources/units";
import type { Course, Exercise, LearningItem, Unit } from "@/types";

type Status = "loading" | "not-found" | "error" | "ready";

export default function UnitDetailPage() {
  const { unitId } = useParams<{ unitId: string }>();
  const navigate = useNavigate();

  const [unit, setUnit] = useState<Unit | null>(null);
  const [course, setCourse] = useState<Course | null>(null);
  const [exercises, setExercises] = useState<Exercise[]>([]);
  const [status, setStatus] = useState<Status>("loading");
  const [errorMessage, setErrorMessage] = useState<string | null>(null);

  const [itemsById, setItemsById] = useState<Record<string, LearningItem>>({});
  const resolvedOrPendingItemIds = useRef<Set<string>>(new Set());

  const [imageUrls, setImageUrls] = useState<Record<string, string>>({});
  const resolvedOrPendingMediaIds = useRef<Set<string>>(new Set());

  const [editUnitOpen, setEditUnitOpen] = useState(false);
  const [deleteUnitOpen, setDeleteUnitOpen] = useState(false);
  const [deletingUnit, setDeletingUnit] = useState(false);

  const [attachDialogOpen, setAttachDialogOpen] = useState(false);
  const [detachTarget, setDetachTarget] = useState<LearningItem | null>(null);
  const [detaching, setDetaching] = useState(false);

  const [exerciseFormOpen, setExerciseFormOpen] = useState(false);
  const [editingExercise, setEditingExercise] = useState<Exercise | undefined>(
    undefined,
  );
  const [deleteExerciseTarget, setDeleteExerciseTarget] =
    useState<Exercise | null>(null);
  const [deletingExercise, setDeletingExercise] = useState(false);

  const sensors = useSensors(
    useSensor(PointerSensor, {
      activationConstraint: { distance: 5 },
    }),
  );

  function fetchData() {
    if (!unitId) return;
    setStatus("loading");
    setErrorMessage(null);
    getUnit(unitId)
      .then((unitData) =>
        Promise.all([
          getCourse(unitData.courseId),
          listExercises({ unitId: unitData._id }),
        ]).then(([courseData, exerciseList]) => {
          setUnit(unitData);
          setCourse(courseData);
          setExercises(exerciseList);
          setStatus("ready");
        }),
      )
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
  }, [unitId]);

  // Resolve each attached { learningItemId } into its real LearningItem.
  // Note: results are applied even if this particular effect invocation has
  // since been "cleaned up" (e.g. React StrictMode's dev-only double-invoke
  // of effects on mount, which re-runs this with a fresh-but-equivalent
  // `unit` reference before the first fetch lands). This is a pure additive
  // id->object cache, so applying a late result is always safe — unlike
  // MediaAttachField's fetch, there's no "remove" action a stale write could
  // wrongly resurrect. Discarding it here previously left ids stuck marked
  // as pending forever with no data ever applied.
  useEffect(() => {
    if (!unit) return;
    const idsToResolve = unit.learningItems
      .map((li) => li.learningItemId)
      .filter((id) => !resolvedOrPendingItemIds.current.has(id));
    if (idsToResolve.length === 0) return;
    idsToResolve.forEach((id) => resolvedOrPendingItemIds.current.add(id));

    Promise.all(
      idsToResolve.map((id) =>
        getLearningItem(id)
          .then((item) => [id, item] as const)
          .catch(() => null),
      ),
    ).then((results) => {
      setItemsById((prev) => {
        const next = { ...prev };
        for (const entry of results) {
          if (entry) next[entry[0]] = entry[1];
        }
        return next;
      });
    });
  }, [unit]);

  // Resolve each resolved item's imageMediaId into a real URL (same
  // always-apply reasoning as above).
  useEffect(() => {
    const idsToResolve = [
      ...new Set(
        Object.values(itemsById)
          .map((item) => item.imageMediaId)
          .filter(
            (id): id is string =>
              Boolean(id) && !resolvedOrPendingMediaIds.current.has(id!),
          ),
      ),
    ];
    if (idsToResolve.length === 0) return;
    idsToResolve.forEach((id) => resolvedOrPendingMediaIds.current.add(id));

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
  }, [itemsById]);

  function handleUnitSaved() {
    fetchData();
  }

  async function handleConfirmDeleteUnit() {
    if (!unit) return;
    setDeletingUnit(true);
    try {
      await deleteUnit(unit._id);
      navigate(`/courses/${unit.courseId}/units`);
    } catch (err) {
      toast.add({
        type: "error",
        title: "Could not delete unit",
        description: err instanceof Error ? err.message : "Request failed",
      });
    } finally {
      setDeletingUnit(false);
      setDeleteUnitOpen(false);
    }
  }

  async function handleAttachSelect(item: LearningItem) {
    if (!unit) return;
    const nextOrder =
      unit.learningItems.length > 0
        ? Math.max(...unit.learningItems.map((li) => li.order)) + 1
        : 0;
    try {
      const updatedUnit = await attachLearningItem(unit._id, {
        learningItemId: item._id,
        order: nextOrder,
      });
      setUnit(updatedUnit);
      setItemsById((prev) => ({ ...prev, [item._id]: item }));
      setAttachDialogOpen(false);
    } catch (err) {
      toast.add({
        type: "error",
        title: "Could not attach learning item",
        description: err instanceof Error ? err.message : "Request failed",
      });
    }
  }

  async function handleConfirmDetach() {
    if (!unit || !detachTarget) return;
    setDetaching(true);
    try {
      const updatedUnit = await detachLearningItem(unit._id, detachTarget._id);
      setUnit(updatedUnit);
    } catch (err) {
      toast.add({
        type: "error",
        title: "Could not detach learning item",
        description: err instanceof Error ? err.message : "Request failed",
      });
    } finally {
      setDetaching(false);
      setDetachTarget(null);
    }
  }

  async function handleDragEnd(event: DragEndEvent) {
    const { active, over } = event;
    if (!over || active.id === over.id || !unit) return;

    const attached = [...unit.learningItems].sort((a, b) => a.order - b.order);
    const oldIndex = attached.findIndex((li) => li.learningItemId === active.id);
    const newIndex = attached.findIndex((li) => li.learningItemId === over.id);
    if (oldIndex === -1 || newIndex === -1) return;

    const previousUnit = unit;
    const reordered = arrayMove(attached, oldIndex, newIndex).map((li, index) => ({
      ...li,
      order: index,
    }));
    setUnit({ ...unit, learningItems: reordered });

    try {
      const updatedUnit = await reorderUnitLearningItems(
        unit._id,
        reordered.map((li) => ({
          learningItemId: li.learningItemId,
          order: li.order,
        })),
      );
      setUnit(updatedUnit);
    } catch (err) {
      setUnit(previousUnit);
      toast.add({
        type: "error",
        title: "Could not reorder learning items",
        description: err instanceof Error ? err.message : "Request failed",
      });
    }
  }

  function openCreateExerciseDialog() {
    setEditingExercise(undefined);
    setExerciseFormOpen(true);
  }

  function openEditExerciseDialog(exercise: Exercise) {
    setEditingExercise(exercise);
    setExerciseFormOpen(true);
  }

  function handleExerciseSaved(saved: Exercise) {
    setExercises((prev) => {
      const exists = prev.some((e) => e._id === saved._id);
      if (exists) {
        return prev.map((e) => (e._id === saved._id ? saved : e));
      }
      return [...prev, saved].sort((a, b) => a.orderIndex - b.orderIndex);
    });
  }

  async function handleConfirmDeleteExercise() {
    if (!deleteExerciseTarget) return;
    const target = deleteExerciseTarget;
    setDeletingExercise(true);
    try {
      await deleteExercise(target._id);
      setExercises((prev) => prev.filter((e) => e._id !== target._id));
    } catch (err) {
      toast.add({
        type: "error",
        title: "Could not delete exercise",
        description: err instanceof Error ? err.message : "Request failed",
      });
    } finally {
      setDeletingExercise(false);
      setDeleteExerciseTarget(null);
    }
  }

  async function handleExerciseDragEnd(event: DragEndEvent) {
    const { active, over } = event;
    if (!over || active.id === over.id) return;

    const oldIndex = exercises.findIndex((e) => e._id === active.id);
    const newIndex = exercises.findIndex((e) => e._id === over.id);
    if (oldIndex === -1 || newIndex === -1) return;

    const previousExercises = exercises;
    const reordered = arrayMove(exercises, oldIndex, newIndex).map(
      (e, index) => ({ ...e, orderIndex: index }),
    );
    setExercises(reordered);

    try {
      const updatedExercises = await reorderExercises(
        reordered.map((e) => ({ id: e._id, orderIndex: e.orderIndex })),
      );
      setExercises([...updatedExercises].sort((a, b) => a.orderIndex - b.orderIndex));
    } catch (err) {
      setExercises(previousExercises);
      toast.add({
        type: "error",
        title: "Could not reorder exercises",
        description: err instanceof Error ? err.message : "Request failed",
      });
    }
  }

  if (status === "loading") {
    return <p className="text-sm text-slate-500">Loading unit...</p>;
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
          Unit not found.
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
          Failed to load unit: {errorMessage}
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

  if (!unit) return null;

  const attachedIds = unit.learningItems.map((li) => li.learningItemId);
  const attachedSorted = [...unit.learningItems].sort(
    (a, b) => a.order - b.order,
  );
  const resolvedAttached = attachedSorted
    .map((li) => itemsById[li.learningItemId])
    .filter((item): item is LearningItem => Boolean(item));
  const allResolved = resolvedAttached.length === attachedSorted.length;

  const nextExerciseOrderIndex =
    exercises.length > 0
      ? Math.max(...exercises.map((e) => e.orderIndex)) + 1
      : 0;

  return (
    <div className="flex flex-col gap-8">
      <div>
        {course && (
          <Link
            to={`/courses/${course._id}/units`}
            className="text-sm text-cyan-700 hover:underline"
          >
            ← Back to Units
          </Link>
        )}

        <div className="mt-2 flex items-center justify-between">
          <h1 className="text-xl font-semibold text-slate-900">
            {unit.name}
          </h1>
          <div className="flex gap-2">
            <Button
              variant="outline"
              size="sm"
              onClick={() => setEditUnitOpen(true)}
            >
              Edit
            </Button>
            <Button
              variant="destructive"
              size="sm"
              onClick={() => setDeleteUnitOpen(true)}
            >
              Delete
            </Button>
          </div>
        </div>
      </div>

      <div>
        <div className="mb-3 flex items-center justify-between">
          <h2 className="text-lg font-semibold text-slate-900">
            Attached Learning Items
          </h2>
          <Button size="sm" onClick={() => setAttachDialogOpen(true)}>
            Attach Learning Item
          </Button>
        </div>

        {attachedSorted.length === 0 && (
          <p className="text-sm text-slate-500">
            No learning items attached yet.
          </p>
        )}

        {attachedSorted.length > 0 && allResolved && (
          <DndContext
            sensors={sensors}
            collisionDetection={closestCenter}
            onDragEnd={handleDragEnd}
          >
            <div className="rounded-md border border-slate-200">
              <SortableContext
                items={resolvedAttached.map((item) => item._id)}
                strategy={verticalListSortingStrategy}
              >
                {resolvedAttached.map((item) => (
                  <SortableAttachedItemRow
                    key={item._id}
                    learningItem={item}
                    imageUrl={
                      item.imageMediaId
                        ? imageUrls[item.imageMediaId]
                        : undefined
                    }
                    onDetach={setDetachTarget}
                  />
                ))}
              </SortableContext>
            </div>
          </DndContext>
        )}
      </div>

      <div>
        <div className="mb-3 flex items-center justify-between">
          <h2 className="text-lg font-semibold text-slate-900">Exercises</h2>
          <Button size="sm" onClick={openCreateExerciseDialog}>
            New Exercise
          </Button>
        </div>

        {exercises.length === 0 && (
          <p className="text-sm text-slate-500">No exercises yet.</p>
        )}

        {exercises.length > 0 && (
          <DndContext
            sensors={sensors}
            collisionDetection={closestCenter}
            onDragEnd={handleExerciseDragEnd}
          >
            <div className="rounded-md border border-slate-200">
              <SortableContext
                items={exercises.map((e) => e._id)}
                strategy={verticalListSortingStrategy}
              >
                {exercises.map((exercise) => (
                  <SortableExerciseRow
                    key={exercise._id}
                    exercise={exercise}
                    onEdit={openEditExerciseDialog}
                    onDelete={setDeleteExerciseTarget}
                  />
                ))}
              </SortableContext>
            </div>
          </DndContext>
        )}
      </div>

      <UnitFormDialog
        open={editUnitOpen}
        onOpenChange={setEditUnitOpen}
        courseId={unit.courseId}
        unit={unit}
        nextOrderIndex={unit.orderIndex}
        onSaved={handleUnitSaved}
      />

      <AttachLearningItemDialog
        open={attachDialogOpen}
        onOpenChange={setAttachDialogOpen}
        excludeIds={attachedIds}
        onSelect={handleAttachSelect}
      />

      <ExerciseFormDialog
        open={exerciseFormOpen}
        onOpenChange={setExerciseFormOpen}
        unitId={unit._id}
        exercise={editingExercise}
        nextOrderIndex={nextExerciseOrderIndex}
        onSaved={handleExerciseSaved}
      />

      <AlertDialog open={deleteUnitOpen} onOpenChange={setDeleteUnitOpen}>
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>Delete unit?</AlertDialogTitle>
            <AlertDialogDescription>
              This will permanently delete "{unit.name}". This cannot be
              undone.
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel disabled={deletingUnit}>
              Cancel
            </AlertDialogCancel>
            <AlertDialogAction
              disabled={deletingUnit}
              onClick={handleConfirmDeleteUnit}
            >
              {deletingUnit ? "Deleting..." : "Delete"}
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>

      <AlertDialog
        open={detachTarget !== null}
        onOpenChange={(open) => {
          if (!open) setDetachTarget(null);
        }}
      >
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>Detach learning item?</AlertDialogTitle>
            <AlertDialogDescription>
              This only removes it from this unit — the learning item
              itself won't be deleted.
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel disabled={detaching}>Cancel</AlertDialogCancel>
            <AlertDialogAction
              disabled={detaching}
              onClick={handleConfirmDetach}
            >
              {detaching ? "Detaching..." : "Detach"}
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>

      <AlertDialog
        open={deleteExerciseTarget !== null}
        onOpenChange={(open) => {
          if (!open) setDeleteExerciseTarget(null);
        }}
      >
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>Delete exercise?</AlertDialogTitle>
            <AlertDialogDescription>
              This will permanently delete "{deleteExerciseTarget?.name}".
              This cannot be undone.
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel disabled={deletingExercise}>
              Cancel
            </AlertDialogCancel>
            <AlertDialogAction
              disabled={deletingExercise}
              onClick={handleConfirmDeleteExercise}
            >
              {deletingExercise ? "Deleting..." : "Delete"}
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </div>
  );
}
