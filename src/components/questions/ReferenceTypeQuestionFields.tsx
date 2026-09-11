import { useState } from "react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import AttachLearningItemDialog from "@/components/units/AttachLearningItemDialog";
import TargetItemField from "@/components/questions/TargetItemField";
import type { LearningItem, QuestionItem, QuestionType } from "@/types";

export const REFERENCE_TYPES = [
  "choose_picture",
  "multiple_choice",
  "listening_transcribe",
  "listening_select",
  "typing",
] as const;

export type ReferenceQuestionType = (typeof REFERENCE_TYPES)[number];

export function isReferenceType(
  type: QuestionType,
): type is ReferenceQuestionType {
  return (REFERENCE_TYPES as readonly string[]).includes(type);
}

export interface ConfigFieldSpec {
  field: string;
  label: string;
}

/** Mirrors the backend's Phase 5b validation table for these 5 types. */
export const REFERENCE_TYPE_CONFIG_FIELDS: Record<
  ReferenceQuestionType,
  ConfigFieldSpec[]
> = {
  choose_picture: [{ field: "promptLanguage", label: "Prompt language" }],
  multiple_choice: [
    { field: "promptLanguage", label: "Prompt language" },
    { field: "answerLanguage", label: "Answer language" },
  ],
  listening_transcribe: [
    { field: "audioLanguage", label: "Audio language" },
    { field: "answerLanguage", label: "Answer language" },
  ],
  listening_select: [
    { field: "audioLanguage", label: "Audio language" },
    { field: "answerLanguage", label: "Answer language" },
  ],
  typing: [
    { field: "promptLanguage", label: "Prompt language" },
    { field: "answerLanguage", label: "Answer language" },
  ],
};

export const REFERENCE_TYPE_ALLOWS_DISTRACTORS: Record<
  ReferenceQuestionType,
  boolean
> = {
  choose_picture: true,
  multiple_choice: true,
  listening_transcribe: false,
  listening_select: true,
  typing: false,
};

interface ReferenceTypeQuestionFieldsProps {
  type: ReferenceQuestionType;
  config: Record<string, unknown>;
  onConfigChange: (config: Record<string, unknown>) => void;
  items: QuestionItem[];
  itemsById: Record<string, LearningItem>;
  onItemsChange: (items: QuestionItem[]) => void;
  onItemResolved: (item: LearningItem) => void;
}

export default function ReferenceTypeQuestionFields({
  type,
  config,
  onConfigChange,
  items,
  itemsById,
  onItemsChange,
  onItemResolved,
}: ReferenceTypeQuestionFieldsProps) {
  const [distractorPickerOpen, setDistractorPickerOpen] = useState(false);

  const target = items.find((it) => it.role === "target");
  const distractors = items.filter((it) => it.role === "distractor");
  const allowsDistractors = REFERENCE_TYPE_ALLOWS_DISTRACTORS[type];

  function itemLabel(learningItemId: string) {
    const item = itemsById[learningItemId];
    if (!item) return "Loading...";
    const firstTranslation = item.translations[0];
    return firstTranslation ? firstTranslation.text : "(no translations yet)";
  }

  function handleTargetSelect(selected: LearningItem) {
    onItemsChange([
      { learningItemId: selected._id, role: "target", displayOrder: 0 },
      ...distractors,
    ]);
    onItemResolved(selected);
  }

  function handleDistractorSelect(selected: LearningItem) {
    onItemsChange([
      ...items,
      {
        learningItemId: selected._id,
        role: "distractor",
        displayOrder: items.length,
      },
    ]);
    onItemResolved(selected);
    setDistractorPickerOpen(false);
  }

  function handleRemoveDistractor(learningItemId: string) {
    onItemsChange(items.filter((it) => it.learningItemId !== learningItemId));
  }

  const excludeIds = [
    ...(target ? [target.learningItemId] : []),
    ...distractors.map((d) => d.learningItemId),
  ];

  return (
    <div className="flex flex-col gap-4">
      <div className="flex gap-4">
        {REFERENCE_TYPE_CONFIG_FIELDS[type].map((spec) => (
          <div key={spec.field} className="flex flex-1 flex-col gap-1.5">
            <Label htmlFor={`question-config-${spec.field}`}>
              {spec.label}
            </Label>
            <Input
              id={`question-config-${spec.field}`}
              required
              maxLength={2}
              placeholder="en"
              value={String(config[spec.field] ?? "")}
              onChange={(e) =>
                onConfigChange({ ...config, [spec.field]: e.target.value })
              }
            />
          </div>
        ))}
      </div>

      <TargetItemField
        learningItem={target ? itemsById[target.learningItemId] : undefined}
        excludeIds={excludeIds}
        onSelect={handleTargetSelect}
      />

      {allowsDistractors && (
        <div className="flex flex-col gap-1.5">
          <div className="flex items-center justify-between">
            <Label>Distractors</Label>
            <Button
              type="button"
              variant="outline"
              size="sm"
              onClick={() => setDistractorPickerOpen(true)}
            >
              Add distractor
            </Button>
          </div>

          {distractors.length === 0 && (
            <p className="text-sm text-slate-500">No distractors yet.</p>
          )}

          {distractors.length > 0 && (
            <div className="rounded-md border border-slate-200">
              {distractors.map((d) => (
                <div
                  key={d.learningItemId}
                  className="flex items-center justify-between border-b border-slate-200 p-2 last:border-b-0"
                >
                  <span className="text-sm text-slate-900">
                    {itemLabel(d.learningItemId)}
                  </span>
                  <Button
                    type="button"
                    variant="outline"
                    size="sm"
                    onClick={() => handleRemoveDistractor(d.learningItemId)}
                  >
                    Remove
                  </Button>
                </div>
              ))}
            </div>
          )}

          <AttachLearningItemDialog
            open={distractorPickerOpen}
            onOpenChange={setDistractorPickerOpen}
            excludeIds={excludeIds}
            onSelect={handleDistractorSelect}
            title="Add Distractor"
            alreadyUsedLabel="used in this question"
          />
        </div>
      )}
    </div>
  );
}
