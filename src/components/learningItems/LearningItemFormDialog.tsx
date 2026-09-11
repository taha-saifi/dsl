import { useEffect, useState, type FormEvent } from "react";
import { Button } from "@/components/ui/button";
import {
  Dialog,
  DialogContent,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import { Label } from "@/components/ui/label";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import MediaAttachField from "@/components/media/MediaAttachField";
import {
  createLearningItem,
  updateLearningItem,
} from "@/lib/resources/learningItems";
import type { LearningItem } from "@/types";

interface LearningItemFormDialogProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  learningItem?: LearningItem;
  onSaved: (learningItem: LearningItem) => void;
}

export default function LearningItemFormDialog({
  open,
  onOpenChange,
  learningItem,
  onSaved,
}: LearningItemFormDialogProps) {
  const isEdit = Boolean(learningItem);
  const [type, setType] = useState<LearningItem["type"]>("word");
  const [imageMediaId, setImageMediaId] = useState<string | undefined>(
    undefined,
  );
  const [error, setError] = useState<string | null>(null);
  const [submitting, setSubmitting] = useState(false);

  useEffect(() => {
    if (open) {
      setType(learningItem?.type ?? "word");
      setImageMediaId(learningItem?.imageMediaId);
      setError(null);
      setSubmitting(false);
    }
  }, [open, learningItem]);

  async function handleSubmit(e: FormEvent) {
    e.preventDefault();
    setError(null);
    setSubmitting(true);
    try {
      const saved =
        isEdit && learningItem
          ? await updateLearningItem(learningItem._id, { type, imageMediaId })
          : await createLearningItem({ type, imageMediaId });
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
              {isEdit ? "Edit Learning Item" : "New Learning Item"}
            </DialogTitle>
          </DialogHeader>

          {error && (
            <div className="rounded-md bg-red-50 px-3 py-2 text-sm text-red-600">
              {error}
            </div>
          )}

          <div className="flex flex-col gap-4 py-2">
            <div className="flex flex-col gap-1.5">
              <Label htmlFor="learning-item-type">Type</Label>
              <Select
                value={type}
                onValueChange={(value) =>
                  setType(value as LearningItem["type"])
                }
              >
                <SelectTrigger id="learning-item-type" className="w-full">
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="word">Word</SelectItem>
                  <SelectItem value="phrase">Phrase</SelectItem>
                  <SelectItem value="sentence">Sentence</SelectItem>
                </SelectContent>
              </Select>
            </div>

            <div className="flex flex-col gap-1.5">
              <Label>Image</Label>
              <MediaAttachField
                mediaId={imageMediaId}
                mediaType="image"
                label="Image"
                onChange={setImageMediaId}
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
