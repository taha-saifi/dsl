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
import { Fragment, useEffect, useRef, useState, type FormEvent } from "react";
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
import { Textarea } from "@/components/ui/textarea";
import ReferenceTypeQuestionFields, {
  REFERENCE_TYPE_CONFIG_FIELDS,
  isReferenceType,
} from "@/components/questions/ReferenceTypeQuestionFields";
import SortableQuestionItemRow from "@/components/questions/SortableQuestionItemRow";
import AttachLearningItemDialog from "@/components/units/AttachLearningItemDialog";
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

const LANGUAGE_PATTERN = /^[a-z]{2}$/i;

interface QuestionFormDialogProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  exerciseId: string;
  question?: Question;
  nextOrderIndex: number;
  onSaved: (question: Question) => void;
}

export default function QuestionFormDialog({
  open,
  onOpenChange,
  exerciseId,
  question,
  nextOrderIndex,
  onSaved,
}: QuestionFormDialogProps) {
  const isEdit = Boolean(question);
  const [type, setType] = useState<QuestionType>("typing");
  const [points, setPoints] = useState(10);

  // Structural types (fill_blank/arrange_sentence/matching): raw JSON textarea.
  const [configText, setConfigText] = useState("{}");
  // Reference types: one plain string per config field (see the table).
  const [structuredConfig, setStructuredConfig] = useState<
    Record<string, string>
  >({});

  const [configError, setConfigError] = useState<string | null>(null);
  const [items, setItems] = useState<QuestionItem[]>([]);
  const [error, setError] = useState<string | null>(null);
  const [submitting, setSubmitting] = useState(false);
  const [pickerOpen, setPickerOpen] = useState(false);

  const [itemsById, setItemsById] = useState<Record<string, LearningItem>>({});
  const resolvedOrPendingIds = useRef<Set<string>>(new Set());

  const sensors = useSensors(
    useSensor(PointerSensor, {
      activationConstraint: { distance: 5 },
    }),
  );

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
    if (question && isReferenceType(initialType)) {
      const fields = REFERENCE_TYPE_CONFIG_FIELDS[initialType];
      const initial: Record<string, string> = {};
      for (const spec of fields) {
        const value = question.config[spec.field];
        initial[spec.field] = typeof value === "string" ? value : "";
      }
      setStructuredConfig(initial);
      setConfigText("{}");
    } else {
      setStructuredConfig({});
      setConfigText(question ? JSON.stringify(question.config, null, 2) : "{}");
    }
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
  // (e.g. choose_picture's distractors have no home in "typing").
  function handleTypeSelect(newType: QuestionType) {
    setType(newType);
    setItems([]);
    setStructuredConfig({});
    setConfigText("{}");
    setConfigError(null);
  }

  function handleItemResolved(item: LearningItem) {
    setItemsById((prev) => ({ ...prev, [item._id]: item }));
  }

  function handleAddItem(learningItem: LearningItem) {
    setItems((prev) => [
      ...prev,
      {
        learningItemId: learningItem._id,
        role: "target",
        displayOrder: prev.length,
      },
    ]);
    handleItemResolved(learningItem);
    setPickerOpen(false);
  }

  function handleRemoveItem(learningItemId: string) {
    setItems((prev) => prev.filter((it) => it.learningItemId !== learningItemId));
  }

  function handleRoleChange(learningItemId: string, role: QuestionItem["role"]) {
    setItems((prev) =>
      prev.map((it) =>
        it.learningItemId === learningItemId ? { ...it, role } : it,
      ),
    );
  }

  function handleItemDragEnd(event: DragEndEvent) {
    const { active, over } = event;
    if (!over || active.id === over.id) return;
    setItems((prev) => {
      const oldIndex = prev.findIndex((it) => it.learningItemId === active.id);
      const newIndex = prev.findIndex((it) => it.learningItemId === over.id);
      if (oldIndex === -1 || newIndex === -1) return prev;
      return arrayMove(prev, oldIndex, newIndex);
    });
  }

  async function handleSubmit(e: FormEvent) {
    e.preventDefault();
    setError(null);
    setConfigError(null);

    let parsedConfig: Record<string, unknown>;

    if (isReferenceType(type)) {
      const fields = REFERENCE_TYPE_CONFIG_FIELDS[type];
      for (const spec of fields) {
        const value = structuredConfig[spec.field] ?? "";
        if (!LANGUAGE_PATTERN.test(value)) {
          setConfigError(`${spec.label} must be a 2-letter code (e.g. en).`);
          return;
        }
      }
      parsedConfig = Object.fromEntries(
        fields.map((spec) => [
          spec.field,
          structuredConfig[spec.field].toLowerCase(),
        ]),
      );
    } else {
      try {
        parsedConfig = JSON.parse(configText);
      } catch {
        setConfigError("Invalid JSON");
        return;
      }
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
    <Fragment>
      <Dialog open={open} onOpenChange={onOpenChange}>
        <DialogContent className="sm:max-w-lg">
          <form onSubmit={handleSubmit}>
            <DialogHeader>
              <DialogTitle>
                {isEdit ? "Edit Question" : "New Question"}
              </DialogTitle>
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
                    onValueChange={(value) =>
                      handleTypeSelect(value as QuestionType)
                    }
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

              {configError && (
                <p className="text-sm text-red-600">{configError}</p>
              )}

              {isReferenceType(type) ? (
                <ReferenceTypeQuestionFields
                  type={type}
                  config={structuredConfig}
                  onConfigChange={setStructuredConfig}
                  items={items}
                  itemsById={itemsById}
                  onItemsChange={setItems}
                  onItemResolved={handleItemResolved}
                />
              ) : (
                <>
                  <div className="flex flex-col gap-1.5">
                    <Label htmlFor="question-config">Config (JSON)</Label>
                    <Textarea
                      id="question-config"
                      rows={5}
                      className="font-mono text-xs"
                      value={configText}
                      onChange={(e) => {
                        setConfigText(e.target.value);
                        setConfigError(null);
                      }}
                    />
                  </div>

                  <div className="flex flex-col gap-1.5">
                    <div className="flex items-center justify-between">
                      <Label>Items</Label>
                      <Button
                        type="button"
                        variant="outline"
                        size="sm"
                        onClick={() => setPickerOpen(true)}
                      >
                        Add Item
                      </Button>
                    </div>

                    {items.length === 0 && (
                      <p className="text-sm text-slate-500">No items yet.</p>
                    )}

                    {items.length > 0 && (
                      <DndContext
                        sensors={sensors}
                        collisionDetection={closestCenter}
                        onDragEnd={handleItemDragEnd}
                      >
                        <div className="rounded-md border border-slate-200">
                          <SortableContext
                            items={items.map((it) => it.learningItemId)}
                            strategy={verticalListSortingStrategy}
                          >
                            {items.map((it) => (
                              <SortableQuestionItemRow
                                key={it.learningItemId}
                                item={it}
                                learningItem={itemsById[it.learningItemId]}
                                onRoleChange={(role) =>
                                  handleRoleChange(it.learningItemId, role)
                                }
                                onRemove={() =>
                                  handleRemoveItem(it.learningItemId)
                                }
                              />
                            ))}
                          </SortableContext>
                        </div>
                      </DndContext>
                    )}
                  </div>
                </>
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

      {!isReferenceType(type) && (
        <AttachLearningItemDialog
          open={pickerOpen}
          onOpenChange={setPickerOpen}
          excludeIds={items.map((it) => it.learningItemId)}
          onSelect={handleAddItem}
          title="Add Item"
          alreadyUsedLabel="added to this question"
        />
      )}
    </Fragment>
  );
}
