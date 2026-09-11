import { useState } from "react";
import { Button } from "@/components/ui/button";
import { Label } from "@/components/ui/label";
import AttachLearningItemDialog from "@/components/units/AttachLearningItemDialog";
import type { LearningItem } from "@/types";

interface TargetItemFieldProps {
  label?: string;
  learningItem?: LearningItem;
  excludeIds: string[];
  onSelect: (item: LearningItem) => void;
}

/** The single-target slot pattern shared by every question form that has a
 * "Target" concept: a resolved item preview with a "Change" button, or a
 * "Select target item" button before anything is chosen. */
export default function TargetItemField({
  label = "Target",
  learningItem,
  excludeIds,
  onSelect,
}: TargetItemFieldProps) {
  const [pickerOpen, setPickerOpen] = useState(false);

  const firstTranslation = learningItem?.translations[0];
  const itemLabel = learningItem
    ? firstTranslation
      ? firstTranslation.text
      : "(no translations yet)"
    : null;

  function handleSelect(item: LearningItem) {
    onSelect(item);
    setPickerOpen(false);
  }

  return (
    <div className="flex flex-col gap-1.5">
      <Label>{label}</Label>
      {learningItem ? (
        <div className="flex items-center justify-between rounded-md border border-slate-200 p-2">
          <span className="text-sm text-slate-900">{itemLabel}</span>
          <Button
            type="button"
            variant="outline"
            size="sm"
            onClick={() => setPickerOpen(true)}
          >
            Change
          </Button>
        </div>
      ) : (
        <Button
          type="button"
          variant="outline"
          size="sm"
          onClick={() => setPickerOpen(true)}
        >
          Select target item
        </Button>
      )}

      <AttachLearningItemDialog
        open={pickerOpen}
        onOpenChange={setPickerOpen}
        excludeIds={excludeIds}
        onSelect={handleSelect}
        title="Select Target Item"
        alreadyUsedLabel="used in this question"
      />
    </div>
  );
}
