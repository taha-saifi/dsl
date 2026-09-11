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
import AttachLearningItemDialog from "@/components/units/AttachLearningItemDialog";
import SortableQuestionItemRow from "@/components/questions/SortableQuestionItemRow";
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
  const [configText, setConfigText] = useState("{}");
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

  useEffect(() => {
    if (!open) return;
    setType(question?.type ?? "typing");
    setPoints(question?.points ?? 10);
    setConfigText(
      question ? JSON.stringify(question.config, null, 2) : "{}",
    );
    setConfigError(null);
    setItems(
      question
        ? [...question.items].sort((a, b) => a.displayOrder - b.displayOrder)
        : [],
    );
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

  function handleAddItem(learningItem: LearningItem) {
    setItems((prev) => [
      ...prev,
      {
        learningItemId: learningItem._id,
        role: "target",
        displayOrder: prev.length,
      },
    ]);
    setItemsById((prev) => ({ ...prev, [learningItem._id]: learningItem }));
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
    try {
      parsedConfig = JSON.parse(configText);
    } catch {
      setConfigError("Invalid JSON");
      return;
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
                    onValueChange={(value) => setType(value as QuestionType)}
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
                {configError && (
                  <p className="text-sm text-red-600">{configError}</p>
                )}
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
                            onRemove={() => handleRemoveItem(it.learningItemId)}
                          />
                        ))}
                      </SortableContext>
                    </div>
                  </DndContext>
                )}
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

      <AttachLearningItemDialog
        open={pickerOpen}
        onOpenChange={setPickerOpen}
        excludeIds={items.map((it) => it.learningItemId)}
        onSelect={handleAddItem}
        title="Add Item"
        alreadyUsedLabel="added to this question"
      />
    </Fragment>
  );
}
