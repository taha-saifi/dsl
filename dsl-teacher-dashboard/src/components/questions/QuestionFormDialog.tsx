import { useEffect, useMemo, useState, type FormEvent } from "react";
import { ArrowLeft } from "lucide-react";
import { Button } from "@/components/ui/button";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import QuestionTextField from "@/components/questions/QuestionTextField";
import QuestionTypeGlyph from "@/components/questions/QuestionTypeGlyph";
import QuestionTypePicker from "@/components/questions/QuestionTypePicker";
import ReferenceTypeQuestionFields, {
  REFERENCE_TYPE_CONFIG_FIELDS,
  isReferenceType,
} from "@/components/questions/ReferenceTypeQuestionFields";
import StructuralTypeQuestionFields, {
  STRUCTURAL_TYPE_LANGUAGE_FIELDS,
  isStructuralType,
} from "@/components/questions/StructuralTypeQuestionFields";
import QuestionPreview from "@/components/questions/preview/QuestionPreview";
import ShowAnswerToggle from "@/components/questions/preview/ShowAnswerToggle";
import {
  primeLearningItem,
  usePreviewSources,
} from "@/components/questions/preview/usePreviewSources";
import { ApiError } from "@/lib/api";
import type { LanguageOption } from "@/lib/languages";
import { buildPreviewModel } from "@/lib/questionPreview";
import { QUESTION_TYPE_INFO, questionTextLength } from "@/lib/questionTypes";
import {
  createQuestion,
  getQuestionTextDefaults,
  updateQuestion,
} from "@/lib/resources/questions";
import type {
  LearningItem,
  Question,
  QuestionItem,
  QuestionTextDefaults,
  QuestionType,
} from "@/types";

/** Used only if the defaults request fails; the server enforces the real limit. */
const FALLBACK_MAX_LENGTH = 300;

interface QuestionFormDialogProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  exerciseId: string;
  question?: Question;
  nextOrderIndex: number;
  /** Number of questions already in the exercise, for the preview's progress bar. */
  questionCount: number;
  onSaved: (question: Question) => void;
  /** Restricts every language field in the form to the parent course's own
   * source/target languages, per the course's data model. */
  languageOptions: LanguageOption[];
}

type Step = "type" | "details";

export default function QuestionFormDialog({
  open,
  onOpenChange,
  exerciseId,
  question,
  nextOrderIndex,
  questionCount,
  onSaved,
  languageOptions,
}: QuestionFormDialogProps) {
  const isEdit = Boolean(question);
  const [step, setStep] = useState<Step>("type");
  const [type, setType] = useState<QuestionType | null>(null);
  const [questionText, setQuestionText] = useState("");
  const [points, setPoints] = useState(10);
  const [config, setConfig] = useState<Record<string, unknown>>({});
  const [configError, setConfigError] = useState<string | null>(null);
  const [items, setItems] = useState<QuestionItem[]>([]);
  const [error, setError] = useState<string | null>(null);
  const [textError, setTextError] = useState<string | null>(null);
  const [submitting, setSubmitting] = useState(false);
  const [showAnswer, setShowAnswer] = useState(false);
  const [textDefaults, setTextDefaults] = useState<QuestionTextDefaults | null>(null);

  const { itemsById, mediaById } = usePreviewSources(items);

  // Populate everything from the existing question (or blank defaults) each
  // time the dialog opens — this is initialization, distinct from the
  // mid-session type-switch reset in handleTypeSelect below.
  useEffect(() => {
    if (!open) return;
    setStep(question ? "details" : "type");
    setType(question?.type ?? null);
    setQuestionText(question?.questionText ?? "");
    setPoints(question?.points ?? 10);
    setItems(
      question
        ? [...question.items].sort((a, b) => a.displayOrder - b.displayOrder)
        : [],
    );
    setConfig(question ? { ...question.config } : {});
    setConfigError(null);
    setError(null);
    setTextError(null);
    setSubmitting(false);
  }, [open, question]);

  useEffect(() => {
    if (!open || textDefaults) return;
    getQuestionTextDefaults()
      .then(setTextDefaults)
      .catch(() => {
        // The placeholder and preview fall back to generic copy; saving still works.
      });
  }, [open, textDefaults]);

  // A type switch on create: reset items/config rather than carrying over a
  // shape that may no longer be valid for the new type (e.g. choose_picture's
  // distractors have no home in "typing"). The server refuses type changes on
  // existing questions, so edit mode never reaches this.
  function handleTypeSelect(newType: QuestionType) {
    if (newType === type) return;
    setType(newType);
    setItems([]);
    setConfig({});
    setConfigError(null);
  }

  function handleItemResolved(item: LearningItem) {
    primeLearningItem(item);
  }

  const maxLength = textDefaults?.maxLength ?? FALLBACK_MAX_LENGTH;
  const defaultText = type && textDefaults ? textDefaults.defaults[type] : null;
  const textTooLong = questionTextLength(questionText) > maxLength;
  const previewText = questionText.trim() || defaultText || "";

  const previewModel = useMemo(
    () =>
      type
        ? buildPreviewModel({ type, config, items, text: previewText, itemsById, mediaById })
        : null,
    [type, config, items, previewText, itemsById, mediaById],
  );

  async function handleSubmit(e: FormEvent) {
    e.preventDefault();
    if (!type || textTooLong) return;
    setError(null);
    setTextError(null);
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
    const trimmedText = questionText.trim();

    setSubmitting(true);
    try {
      const saved =
        isEdit && question
          ? await updateQuestion(question._id, {
              points,
              config: parsedConfig,
              items: itemsPayload,
              questionText: trimmedText || null,
            })
          : await createQuestion({
              exerciseId,
              type,
              orderIndex: nextOrderIndex,
              points,
              config: parsedConfig,
              items: itemsPayload,
              ...(trimmedText ? { questionText: trimmedText } : {}),
            });
      onSaved(saved);
      onOpenChange(false);
    } catch (err) {
      if (err instanceof ApiError && err.code === "INVALID_QUESTION_TEXT") {
        setTextError(err.message);
      } else {
        setError(err instanceof Error ? err.message : "Something went wrong");
      }
    } finally {
      setSubmitting(false);
    }
  }

  const position = isEdit && question ? question.orderIndex + 1 : questionCount + 1;
  const total = isEdit ? Math.max(questionCount, 1) : questionCount + 1;
  const info = type ? QUESTION_TYPE_INFO[type] : null;

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      {step === "type" ? (
        <DialogContent className="gap-0 p-0 sm:max-w-3xl">
          <DialogHeader className="border-b border-slate-200 px-6 pt-5 pb-4">
            <DialogTitle className="text-base">New question</DialogTitle>
            <DialogDescription>
              Choose how students answer. The type can't be changed once the
              question is saved.
            </DialogDescription>
          </DialogHeader>
          <div className="max-h-[70vh] overflow-y-auto bg-slate-50/70 px-6 py-5">
            <QuestionTypePicker value={type} onChange={handleTypeSelect} />
          </div>
          <DialogFooter className="mx-0 mb-0 rounded-b-xl border-t border-slate-200 px-6 py-3">
            <Button type="button" variant="outline" onClick={() => onOpenChange(false)}>
              Cancel
            </Button>
            <Button type="button" disabled={!type} onClick={() => setStep("details")}>
              Continue
            </Button>
          </DialogFooter>
        </DialogContent>
      ) : (
        <DialogContent className="flex h-[min(54rem,calc(100dvh-2rem))] flex-col gap-0 p-0 sm:max-w-[min(70rem,calc(100vw-2rem))]">
          <form onSubmit={handleSubmit} className="flex min-h-0 flex-1 flex-col">
            <DialogHeader className="flex-row items-center gap-3 border-b border-slate-200 py-3 pr-12 pl-4">
              {!isEdit && (
                <Button
                  type="button"
                  variant="ghost"
                  size="icon-sm"
                  onClick={() => setStep("type")}
                  aria-label="Change question type"
                >
                  <ArrowLeft />
                </Button>
              )}
              {type && <QuestionTypeGlyph type={type} className="text-slate-200" />}
              <div className="flex min-w-0 flex-col">
                <DialogTitle className="text-base">
                  {isEdit ? "Edit question" : "New question"}
                  {info && <span className="font-normal text-slate-500"> ({info.label.toLowerCase()})</span>}
                </DialogTitle>
                <DialogDescription className="truncate text-xs">
                  {isEdit
                    ? "The type is fixed. To use a different type, create a new question."
                    : info?.description}
                </DialogDescription>
              </div>
            </DialogHeader>

            <div className="min-h-0 flex-1 overflow-y-auto lg:grid lg:grid-cols-[minmax(0,1fr)_22rem] lg:overflow-hidden">
              <div className="flex flex-col gap-5 px-6 py-5 lg:overflow-y-auto">
                {error && (
                  <div role="alert" className="rounded-md border border-red-200 bg-red-50 px-3 py-2 text-sm text-red-700">
                    {error}
                  </div>
                )}

                <div className="grid gap-4 sm:grid-cols-[minmax(0,1fr)_6.5rem]">
                  <QuestionTextField
                    value={questionText}
                    onChange={(value) => {
                      setQuestionText(value);
                      setTextError(null);
                    }}
                    defaultText={defaultText}
                    maxLength={maxLength}
                    serverError={textError}
                  />
                  <div className="flex flex-col gap-1.5">
                    <Label htmlFor="question-points">Points</Label>
                    <Input
                      id="question-points"
                      type="number"
                      required
                      value={points}
                      onChange={(e) => setPoints(Number(e.target.value))}
                      className="bg-white"
                    />
                  </div>
                </div>

                <div className="h-px bg-slate-200" />

                {configError && (
                  <p role="alert" className="text-sm text-red-600">
                    {configError}
                  </p>
                )}

                {type && isReferenceType(type) ? (
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
                  type &&
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

              <aside
                aria-label="Student preview"
                className="flex flex-col items-center gap-3 border-t border-slate-200 bg-slate-100/80 px-4 py-4 lg:overflow-y-auto lg:border-t-0 lg:border-l"
              >
                {previewModel && (
                  <QuestionPreview
                    model={previewModel}
                    position={position}
                    total={total}
                    showAnswer={showAnswer}
                    width={256}
                    actions={<ShowAnswerToggle checked={showAnswer} onChange={setShowAnswer} />}
                  />
                )}
              </aside>
            </div>

            <DialogFooter className="mx-0 mb-0 rounded-b-xl border-t border-slate-200 px-6 py-3">
              <Button type="button" variant="outline" onClick={() => onOpenChange(false)}>
                Cancel
              </Button>
              <Button type="submit" disabled={submitting || textTooLong}>
                {submitting ? "Saving..." : isEdit ? "Save changes" : "Create question"}
              </Button>
            </DialogFooter>
          </form>
        </DialogContent>
      )}
    </Dialog>
  );
}
