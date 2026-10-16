import { useEffect, useRef, useState, type FormEvent } from "react";
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
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import ReferenceTypeQuestionFields, {
  REFERENCE_TYPE_CONFIG_FIELDS,
  isReferenceType,
} from "@/components/questions/ReferenceTypeQuestionFields";
import StructuralTypeQuestionFields, {
  STRUCTURAL_TYPE_LANGUAGE_FIELDS,
  isStructuralType,
} from "@/components/questions/StructuralTypeQuestionFields";
import type { LanguageOption } from "@/lib/languages";
import { getLearningItem } from "@/lib/resources/learningItems";
import { createQuestion, updateQuestion } from "@/lib/resources/questions";
import type { LearningItem, Question, QuestionItem, QuestionType } from "@/types";

const QUESTION_TYPES: QuestionType[] = [
  "choose_picture",
  "multiple_choice",
  "listening_transcribe",
  "listening_select",
  "typing",
  "fill_blank",
  "arrange_sentence",
  "matching",
];

interface QuestionFormDialogProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  exerciseId: string;
  question?: Question;
  nextOrderIndex: number;
  onSaved: (question: Question) => void;
  /** Restricts every language field in the form to the parent course's own
   * source/target languages, per the course's data model. */
  languageOptions: LanguageOption[];
}

export default function QuestionFormDialog({
  open,
  onOpenChange,
  exerciseId,
  question,
  nextOrderIndex,
  onSaved,
  languageOptions,
}: QuestionFormDialogProps) {
  const isEdit = Boolean(question);
  const [type, setType] = useState<QuestionType>("typing");
  const [points, setPoints] = useState(10);
  const [config, setConfig] = useState<Record<string, unknown>>({});
  const [configError, setConfigError] = useState<string | null>(null);
  const [items, setItems] = useState<QuestionItem[]>([]);
  const [error, setError] = useState<string | null>(null);
  const [submitting, setSubmitting] = useState(false);

  const [itemsById, setItemsById] = useState<Record<string, LearningItem>>({});
  const resolvedOrPendingIds = useRef<Set<string>>(new Set());

  // Populate everything from the existing question (or blank defaults) each
  // time the dialog opens — this is initialization, distinct from the
  // mid-session type-switch reset in handleTypeSelect below.
  useEffect(() => {
    if (!open) return;
    const initialType = question?.type ?? "typing";
    setType(initialType);
    setPoints(question?.points ?? 10);
    setItems(
      question
        ? [...question.items].sort((a, b) => a.displayOrder - b.displayOrder)
        : [],
    );
    setConfig(question ? { ...question.config } : {});
    setConfigError(null);
    setError(null);
    setSubmitting(false);
  }, [open, question]);

  // Resolve each item's learningItemId into its real LearningItem, for display.
  useEffect(() => {
    const idsToResolve = items
      .map((it) => it.learningItemId)
      .filter((id) => !resolvedOrPendingIds.current.has(id));
    if (idsToResolve.length === 0) return;
    idsToResolve.forEach((id) => resolvedOrPendingIds.current.add(id));

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
  }, [items]);

  // A user-driven type switch mid-session: reset items/config rather than
  // carrying over a shape that may no longer be valid for the new type
  // (e.g. choose_picture's distractors have no home in "typing", and a
  // fill_blank's blankWord/arrange_sentence's wordBlocks have no meaning
  // once the type is no longer one of those).
  function handleTypeSelect(newType: QuestionType) {
    setType(newType);
    setItems([]);
    setConfig({});
    setConfigError(null);
  }

  function handleItemResolved(item: LearningItem) {
    setItemsById((prev) => ({ ...prev, [item._id]: item }));
  }

  async function handleSubmit(e: FormEvent) {
    e.preventDefault();
    setError(null);
    setConfigError(null);

    const languageFields = isReferenceType(type)
      ? REFERENCE_TYPE_CONFIG_FIELDS[type]
      : isStructuralType(type)
        ? STRUCTURAL_TYPE_LANGUAGE_FIELDS[type]
        : [];

    const parsedConfig: Record<string, unknown> = { ...config };
    for (const spec of languageFields) {
      const value = String(config[spec.field] ?? "");
      if (!value) {
        setConfigError(`Select a ${spec.label.toLowerCase()}.`);
        return;
      }
      parsedConfig[spec.field] = value.toLowerCase();
    }

    const itemsPayload: QuestionItem[] = items.map((it, index) => ({
      learningItemId: it.learningItemId,
      role: it.role,
      displayOrder: index,
    }));

    setSubmitting(true);
    try {
      const saved =
        isEdit && question
          ? await updateQuestion(question._id, {
              type,
              points,
              config: parsedConfig,
              items: itemsPayload,
            })
          : await createQuestion({
              exerciseId,
              type,
              orderIndex: nextOrderIndex,
              points,
              config: parsedConfig,
              items: itemsPayload,
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
      <DialogContent className="sm:max-w-lg">
        <form onSubmit={handleSubmit}>
          <DialogHeader>
            <DialogTitle>{isEdit ? "Edit Question" : "New Question"}</DialogTitle>
          </DialogHeader>

          {error && (
            <div className="rounded-md bg-red-50 px-3 py-2 text-sm text-red-600">
              {error}
            </div>
          )}

          <div className="flex max-h-[70vh] flex-col gap-4 overflow-y-auto py-2">
            <div className="flex gap-4">
              <div className="flex flex-1 flex-col gap-1.5">
                <Label htmlFor="question-type">Type</Label>
                <Select
                  value={type}
                  onValueChange={(value) => handleTypeSelect(value as QuestionType)}
                >
                  <SelectTrigger id="question-type" className="w-full">
                    <SelectValue />
                  </SelectTrigger>
                  <SelectContent>
                    {QUESTION_TYPES.map((t) => (
                      <SelectItem key={t} value={t}>
                        {t}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>
              <div className="flex w-28 flex-col gap-1.5">
                <Label htmlFor="question-points">Points</Label>
                <Input
                  id="question-points"
                  type="number"
                  required
                  value={points}
                  onChange={(e) => setPoints(Number(e.target.value))}
                />
              </div>
            </div>

            {configError && <p className="text-sm text-red-600">{configError}</p>}

            {isReferenceType(type) ? (
              <ReferenceTypeQuestionFields
                type={type}
                config={config}
                onConfigChange={setConfig}
                items={items}
                itemsById={itemsById}
                onItemsChange={setItems}
                onItemResolved={handleItemResolved}
                languageOptions={languageOptions}
              />
            ) : (
              isStructuralType(type) && (
                <StructuralTypeQuestionFields
                  type={type}
                  config={config}
                  onConfigChange={setConfig}
                  items={items}
                  itemsById={itemsById}
                  onItemsChange={setItems}
                  onItemResolved={handleItemResolved}
                  languageOptions={languageOptions}
                />
              )
            )}
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
