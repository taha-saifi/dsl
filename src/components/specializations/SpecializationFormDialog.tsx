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
import {
  createSpecialization,
  updateSpecialization,
} from "@/lib/resources/specializations";
import type { Specialization } from "@/types";

interface SpecializationFormDialogProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  specialization?: Specialization;
  onSaved: (specialization: Specialization) => void;
}

export default function SpecializationFormDialog({
  open,
  onOpenChange,
  specialization,
  onSaved,
}: SpecializationFormDialogProps) {
  const isEdit = Boolean(specialization);
  const [name, setName] = useState("");
  const [iconUrl, setIconUrl] = useState("");
  const [error, setError] = useState<string | null>(null);
  const [submitting, setSubmitting] = useState(false);

  useEffect(() => {
    if (open) {
      setName(specialization?.name ?? "");
      setIconUrl(specialization?.iconUrl ?? "");
      setError(null);
      setSubmitting(false);
    }
  }, [open, specialization]);

  async function handleSubmit(e: FormEvent) {
    e.preventDefault();
    setError(null);
    setSubmitting(true);
    try {
      const input = { name: name.trim(), iconUrl: iconUrl.trim() || undefined };
      const saved =
        isEdit && specialization
          ? await updateSpecialization(specialization._id, input)
          : await createSpecialization(input);
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
              {isEdit ? "Edit Specialization" : "New Specialization"}
            </DialogTitle>
          </DialogHeader>

          {error && (
            <div className="rounded-md bg-red-50 px-3 py-2 text-sm text-red-600">
              {error}
            </div>
          )}

          <div className="flex flex-col gap-4 py-2">
            <div className="flex flex-col gap-1.5">
              <Label htmlFor="spec-name">Name</Label>
              <Input
                id="spec-name"
                required
                value={name}
                onChange={(e) => setName(e.target.value)}
              />
            </div>
            <div className="flex flex-col gap-1.5">
              <Label htmlFor="spec-icon-url">Icon URL</Label>
              <Input
                id="spec-icon-url"
                value={iconUrl}
                onChange={(e) => setIconUrl(e.target.value)}
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
