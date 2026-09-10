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
import { Textarea } from "@/components/ui/textarea";
import { createCourse, updateCourse } from "@/lib/resources/courses";
import type { Course } from "@/types";

const LANGUAGE_PATTERN = /^[a-z]{2}$/i;

interface CourseFormDialogProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  specializationId: string;
  course?: Course;
  onSaved: (course: Course) => void;
}

export default function CourseFormDialog({
  open,
  onOpenChange,
  specializationId,
  course,
  onSaved,
}: CourseFormDialogProps) {
  const isEdit = Boolean(course);
  const [name, setName] = useState("");
  const [sourceLanguage, setSourceLanguage] = useState("");
  const [targetLanguage, setTargetLanguage] = useState("");
  const [description, setDescription] = useState("");
  const [error, setError] = useState<string | null>(null);
  const [submitting, setSubmitting] = useState(false);

  useEffect(() => {
    if (open) {
      setName(course?.name ?? "");
      setSourceLanguage(course?.sourceLanguage ?? "");
      setTargetLanguage(course?.targetLanguage ?? "");
      setDescription(course?.description ?? "");
      setError(null);
      setSubmitting(false);
    }
  }, [open, course]);

  async function handleSubmit(e: FormEvent) {
    e.preventDefault();
    setError(null);

    if (!LANGUAGE_PATTERN.test(sourceLanguage)) {
      setError("Source language must be a 2-letter code (e.g. en).");
      return;
    }
    if (!LANGUAGE_PATTERN.test(targetLanguage)) {
      setError("Target language must be a 2-letter code (e.g. fr).");
      return;
    }

    setSubmitting(true);
    try {
      const trimmedDescription = description.trim();
      const saved =
        isEdit && course
          ? await updateCourse(course._id, {
              name: name.trim(),
              sourceLanguage: sourceLanguage.toLowerCase(),
              targetLanguage: targetLanguage.toLowerCase(),
              description: trimmedDescription || undefined,
            })
          : await createCourse({
              specializationId,
              name: name.trim(),
              sourceLanguage: sourceLanguage.toLowerCase(),
              targetLanguage: targetLanguage.toLowerCase(),
              description: trimmedDescription || undefined,
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
            <DialogTitle>{isEdit ? "Edit Course" : "New Course"}</DialogTitle>
          </DialogHeader>

          {error && (
            <div className="rounded-md bg-red-50 px-3 py-2 text-sm text-red-600">
              {error}
            </div>
          )}

          <div className="flex flex-col gap-4 py-2">
            <div className="flex flex-col gap-1.5">
              <Label htmlFor="course-name">Name</Label>
              <Input
                id="course-name"
                required
                value={name}
                onChange={(e) => setName(e.target.value)}
              />
            </div>
            <div className="flex gap-4">
              <div className="flex flex-1 flex-col gap-1.5">
                <Label htmlFor="course-source-language">Source language</Label>
                <Input
                  id="course-source-language"
                  required
                  maxLength={2}
                  placeholder="en"
                  value={sourceLanguage}
                  onChange={(e) => setSourceLanguage(e.target.value)}
                />
              </div>
              <div className="flex flex-1 flex-col gap-1.5">
                <Label htmlFor="course-target-language">Target language</Label>
                <Input
                  id="course-target-language"
                  required
                  maxLength={2}
                  placeholder="fr"
                  value={targetLanguage}
                  onChange={(e) => setTargetLanguage(e.target.value)}
                />
              </div>
            </div>
            <div className="flex flex-col gap-1.5">
              <Label htmlFor="course-description">Description</Label>
              <Textarea
                id="course-description"
                value={description}
                onChange={(e) => setDescription(e.target.value)}
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
