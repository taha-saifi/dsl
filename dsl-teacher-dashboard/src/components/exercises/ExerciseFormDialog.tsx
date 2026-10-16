import { useEffect, useState, type FormEvent } from "react";
import { Button } from "@/components/ui/button";
import {
  Dialog,
  DialogContent,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { createExercise, updateExercise } from "@/lib/resources/exercises";
import type { Exercise } from "@/types";

interface ExerciseFormDialogProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  unitId: string;
  exercise?: Exercise;
  nextOrderIndex: number;
  onSaved: (exercise: Exercise) => void;
}

export default function ExerciseFormDialog({
  open,
  onOpenChange,
  unitId,
  exercise,
  nextOrderIndex,
  onSaved,
}: ExerciseFormDialogProps) {
  const isEdit = Boolean(exercise);
  const [name, setName] = useState("");
  const [error, setError] = useState<string | null>(null);
  const [submitting, setSubmitting] = useState(false);

  useEffect(() => {
    if (open) {
      setName(exercise?.name ?? "");
      setError(null);
      setSubmitting(false);
    }
  }, [open, exercise]);

  async function handleSubmit(e: FormEvent) {
    e.preventDefault();
    setError(null);
    setSubmitting(true);
    try {
      const trimmedName = name.trim();
      const saved =
        isEdit && exercise
          ? await updateExercise(exercise._id, { name: trimmedName })
          : await createExercise({
              unitId,
              name: trimmedName,
              orderIndex: nextOrderIndex,
            });
      onSaved(saved);
      onOpenChange(false);
    } catch (err) {
      setError(err instanceof Error ? err.message : "Something went wrong");
    } finally {
      setSubmitting(false);
    }
  }

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent>
        <form onSubmit={handleSubmit}>
          <DialogHeader>
            <DialogTitle>
              {isEdit ? "Edit Exercise" : "New Exercise"}
            </DialogTitle>
          </DialogHeader>

          {error && (
            <div className="rounded-md bg-red-50 px-3 py-2 text-sm text-red-600">
              {error}
            </div>
          )}

          <div className="flex flex-col gap-4 py-2">
            <div className="flex flex-col gap-1.5">
              <Label htmlFor="exercise-name">Name</Label>
              <Input
                id="exercise-name"
                required
                value={name}
                onChange={(e) => setName(e.target.value)}
              />
            </div>
          </div>

          <DialogFooter>
            <Button type="submit" disabled={submitting}>
              {submitting ? "Saving..." : "Save"}
            </Button>
          </DialogFooter>
        </form>
      </DialogContent>
    </Dialog>
  );
}
