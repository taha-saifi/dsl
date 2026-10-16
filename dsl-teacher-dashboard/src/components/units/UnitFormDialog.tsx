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
import { createUnit, updateUnit } from "@/lib/resources/units";
import type { Unit } from "@/types";

interface UnitFormDialogProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  courseId: string;
  unit?: Unit;
  nextOrderIndex: number;
  onSaved: (unit: Unit) => void;
}

export default function UnitFormDialog({
  open,
  onOpenChange,
  courseId,
  unit,
  nextOrderIndex,
  onSaved,
}: UnitFormDialogProps) {
  const isEdit = Boolean(unit);
  const [name, setName] = useState("");
  const [error, setError] = useState<string | null>(null);
  const [submitting, setSubmitting] = useState(false);

  useEffect(() => {
    if (open) {
      setName(unit?.name ?? "");
      setError(null);
      setSubmitting(false);
    }
  }, [open, unit]);

  async function handleSubmit(e: FormEvent) {
    e.preventDefault();
    setError(null);
    setSubmitting(true);
    try {
      const trimmedName = name.trim();
      const saved =
        isEdit && unit
          ? await updateUnit(unit._id, { name: trimmedName })
          : await createUnit({
              courseId,
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
            <DialogTitle>{isEdit ? "Edit Unit" : "New Unit"}</DialogTitle>
          </DialogHeader>

          {error && (
            <div className="rounded-md bg-red-50 px-3 py-2 text-sm text-red-600">
              {error}
            </div>
          )}

          <div className="flex flex-col gap-4 py-2">
            <div className="flex flex-col gap-1.5">
              <Label htmlFor="unit-name">Name</Label>
              <Input
                id="unit-name"
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
