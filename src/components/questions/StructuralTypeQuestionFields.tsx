import { useEffect, useState } from "react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import AttachLearningItemDialog from "@/components/units/AttachLearningItemDialog";
import TargetItemField from "@/components/questions/TargetItemField";
import type { ConfigFieldSpec } from "@/components/questions/ReferenceTypeQuestionFields";
import { tokenize } from "@/lib/sentenceWords";
import type { LearningItem, QuestionItem, QuestionType, Translation } from "@/types";

export const STRUCTURAL_TYPES = [
  "fill_blank",
  "arrange_sentence",
  "matching",
] as const;

export type StructuralQuestionType = (typeof STRUCTURAL_TYPES)[number];

export function isStructuralType(
  type: QuestionType,
): type is StructuralQuestionType {
  return (STRUCTURAL_TYPES as readonly string[]).includes(type);
}

/** Mirrors the backend's Phase 5c validation table's language-code fields. */
export const STRUCTURAL_TYPE_LANGUAGE_FIELDS: Record<
  StructuralQuestionType,
  ConfigFieldSpec[]
> = {
  fill_blank: [
    { field: "promptLanguage", label: "Prompt language" },
    { field: "sentenceLanguage", label: "Sentence language" },
  ],
  arrange_sentence: [
    { field: "promptLanguage", label: "Prompt language" },
    { field: "sentenceLanguage", label: "Sentence language" },
  ],
  matching: [
    { field: "sourceLanguage", label: "Source language" },
    { field: "targetLanguage", label: "Target language" },
  ],
};

interface StructuralTypeQuestionFieldsProps {
  type: StructuralQuestionType;
  config: Record<string, unknown>;
  onConfigChange: (config: Record<string, unknown>) => void;
  items: QuestionItem[];
  itemsById: Record<string, LearningItem>;
  onItemsChange: (items: QuestionItem[]) => void;
  onItemResolved: (item: LearningItem) => void;
}

export default function StructuralTypeQuestionFields(
  props: StructuralTypeQuestionFieldsProps,
) {
  switch (props.type) {
    case "fill_blank":
      return <FillBlankFields {...props} />;
    case "arrange_sentence":
      return <ArrangeSentenceFields {...props} />;
    case "matching":
      return <MatchingFields {...props} />;
  }
}

function LanguageField({
  field,
  label,
  config,
  onConfigChange,
}: {
  field: string;
  label: string;
  config: Record<string, unknown>;
  onConfigChange: (config: Record<string, unknown>) => void;
}) {
  return (
    <div className="flex flex-1 flex-col gap-1.5">
      <Label htmlFor={`question-config-${field}`}>{label}</Label>
      <Input
        id={`question-config-${field}`}
        required
        maxLength={2}
        placeholder="en"
        value={String(config[field] ?? "")}
        onChange={(e) => onConfigChange({ ...config, [field]: e.target.value })}
      />
    </div>
  );
}

function findTranslation(
  item: LearningItem | undefined,
  language: string,
): Translation | undefined {
  if (!item || !language) return undefined;
  return item.translations.find(
    (t) => t.language.toLowerCase() === language.toLowerCase(),
  );
}

// ---------------------------------------------------------------------------
// fill_blank
// ---------------------------------------------------------------------------

function FillBlankFields({
  config,
  onConfigChange,
  items,
  itemsById,
  onItemsChange,
  onItemResolved,
}: StructuralTypeQuestionFieldsProps) {
  const target = items.find((it) => it.role === "target");
  const targetItem = target ? itemsById[target.learningItemId] : undefined;
  const sentenceLanguage = String(config.sentenceLanguage ?? "");
  const blankWord = String(config.blankWord ?? "");

  const sentenceTranslation = findTranslation(targetItem, sentenceLanguage);
  const tokens = sentenceTranslation ? tokenize(sentenceTranslation.text) : [];

  function handleTargetSelect(selected: LearningItem) {
    onItemsChange([
      { learningItemId: selected._id, role: "target", displayOrder: 0 },
    ]);
    onItemResolved(selected);
    // The previously-selected blank word belonged to the old sentence.
    onConfigChange({ ...config, blankWord: "" });
  }

  function handleTokenClick(token: string) {
    onConfigChange({ ...config, blankWord: token });
  }

  return (
    <div className="flex flex-col gap-4">
      <div className="flex gap-4">
        <LanguageField
          field="promptLanguage"
          label="Prompt language"
          config={config}
          onConfigChange={onConfigChange}
        />
        <LanguageField
          field="sentenceLanguage"
          label="Sentence language"
          config={config}
          onConfigChange={onConfigChange}
        />
      </div>

      <TargetItemField
        learningItem={targetItem}
        excludeIds={target ? [target.learningItemId] : []}
        onSelect={handleTargetSelect}
      />

      {!sentenceTranslation && (
        <p className="text-sm text-slate-500">
          {sentenceLanguage
            ? `Select a target item with a "${sentenceLanguage}" translation.`
            : "Enter a sentence language and select a target item to pick the blank word."}
        </p>
      )}

      {sentenceTranslation && (
        <div className="flex flex-col gap-1.5">
          <Label>Blank word</Label>
          <div className="flex flex-wrap gap-1 rounded-md border border-slate-200 p-2">
            {tokens.map((token, index) => {
              const isSelected =
                blankWord !== "" &&
                token.toLowerCase() === blankWord.toLowerCase();
              return (
                <button
                  key={`${token}-${index}`}
                  type="button"
                  onClick={() => handleTokenClick(token)}
                  className={
                    isSelected
                      ? "rounded bg-cyan-100 px-1.5 py-0.5 text-sm text-cyan-800"
                      : "rounded px-1.5 py-0.5 text-sm text-slate-700 hover:bg-slate-100"
                  }
                >
                  {token}
                </button>
              );
            })}
          </div>
          {blankWord && (
            <p className="text-xs text-slate-500">
              Selected blank word: "{blankWord}"
            </p>
          )}
        </div>
      )}
    </div>
  );
}

// ---------------------------------------------------------------------------
// arrange_sentence
// ---------------------------------------------------------------------------

function computeWordBlocksHint(sentenceWords: string[], wordBlocks: string[]) {
  const remaining = [...wordBlocks];
  const missing: string[] = [];
  for (const word of sentenceWords) {
    const idx = remaining.findIndex(
      (w) => w.toLowerCase() === word.toLowerCase(),
    );
    if (idx === -1) {
      missing.push(word);
    } else {
      remaining.splice(idx, 1);
    }
  }
  return { missing, hasExtra: remaining.length >= 1 };
}

function ArrangeSentenceFields({
  config,
  onConfigChange,
  items,
  itemsById,
  onItemsChange,
  onItemResolved,
}: StructuralTypeQuestionFieldsProps) {
  const target = items.find((it) => it.role === "target");
  const targetItem = target ? itemsById[target.learningItemId] : undefined;
  const sentenceLanguage = String(config.sentenceLanguage ?? "");
  const wordBlocks = Array.isArray(config.wordBlocks)
    ? (config.wordBlocks as string[])
    : [];
  const [extraWordInput, setExtraWordInput] = useState("");

  const sentenceTranslation = findTranslation(targetItem, sentenceLanguage);
  const sentenceWords = sentenceTranslation
    ? tokenize(sentenceTranslation.text)
    : [];

  // Auto-populate wordBlocks from the sentence, but only while it's still
  // empty — this covers a fresh create (nothing chosen yet) without ever
  // silently re-deriving over a teacher's already-saved/edited blocks
  // (which arrive non-empty from the stored question).
  useEffect(() => {
    if (wordBlocks.length > 0) return;
    if (!sentenceTranslation) return;
    const words = tokenize(sentenceTranslation.text);
    if (words.length > 0) {
      onConfigChange({ ...config, wordBlocks: words });
    }
    // Only re-run when the underlying sentence text itself changes.
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [sentenceTranslation?.text]);

  function handleTargetSelect(selected: LearningItem) {
    onItemsChange([
      { learningItemId: selected._id, role: "target", displayOrder: 0 },
    ]);
    onItemResolved(selected);
  }

  function handleRemoveBlock(index: number) {
    const next = [...wordBlocks];
    next.splice(index, 1);
    onConfigChange({ ...config, wordBlocks: next });
  }

  function handleAddExtraWord() {
    const word = extraWordInput.trim();
    if (!word) return;
    onConfigChange({ ...config, wordBlocks: [...wordBlocks, word] });
    setExtraWordInput("");
  }

  function handleResetFromSentence() {
    onConfigChange({ ...config, wordBlocks: sentenceWords });
  }

  const { missing, hasExtra } = computeWordBlocksHint(
    sentenceWords,
    wordBlocks,
  );
  const satisfied = sentenceWords.length > 0 && missing.length === 0 && hasExtra;

  return (
    <div className="flex flex-col gap-4">
      <div className="flex gap-4">
        <LanguageField
          field="promptLanguage"
          label="Prompt language"
          config={config}
          onConfigChange={onConfigChange}
        />
        <LanguageField
          field="sentenceLanguage"
          label="Sentence language"
          config={config}
          onConfigChange={onConfigChange}
        />
      </div>

      <TargetItemField
        learningItem={targetItem}
        excludeIds={target ? [target.learningItemId] : []}
        onSelect={handleTargetSelect}
      />

      {!sentenceTranslation && (
        <p className="text-sm text-slate-500">
          {sentenceLanguage
            ? `Select a target item with a "${sentenceLanguage}" translation.`
            : "Enter a sentence language and select a target item to build word blocks."}
        </p>
      )}

      <div className="flex flex-col gap-1.5">
        <div className="flex items-center justify-between">
          <Label>Word blocks</Label>
          {sentenceTranslation && (
            <Button
              type="button"
              variant="outline"
              size="sm"
              onClick={handleResetFromSentence}
            >
              Reset blocks from sentence
            </Button>
          )}
        </div>

        {wordBlocks.length === 0 && (
          <p className="text-sm text-slate-500">No word blocks yet.</p>
        )}

        {wordBlocks.length > 0 && (
          <div className="flex flex-wrap gap-1.5 rounded-md border border-slate-200 p-2">
            {wordBlocks.map((word, index) => (
              <span
                key={`${word}-${index}`}
                className="flex items-center gap-1 rounded-full bg-slate-100 py-0.5 pr-1 pl-2.5 text-sm text-slate-700"
              >
                {word}
                <button
                  type="button"
                  aria-label={`Remove ${word}`}
                  onClick={() => handleRemoveBlock(index)}
                  className="rounded-full px-1 text-slate-400 hover:bg-slate-200 hover:text-slate-600"
                >
                  ×
                </button>
              </span>
            ))}
          </div>
        )}

        <div className="flex gap-2">
          <Input
            placeholder="Add an extra word"
            value={extraWordInput}
            onChange={(e) => setExtraWordInput(e.target.value)}
          />
          <Button type="button" variant="outline" onClick={handleAddExtraWord}>
            Add extra word
          </Button>
        </div>

        {sentenceTranslation && (
          <p
            className={
              satisfied ? "text-sm text-emerald-600" : "text-sm text-amber-600"
            }
          >
            {missing.length > 0
              ? `Missing required word(s): ${missing.join(", ")}.`
              : !hasExtra
                ? "Needs at least one extra word not in the sentence."
                : "Covers the sentence with at least one extra word."}
          </p>
        )}
      </div>
    </div>
  );
}

// ---------------------------------------------------------------------------
// matching
// ---------------------------------------------------------------------------

function MatchingFields({
  config,
  onConfigChange,
  items,
  itemsById,
  onItemsChange,
  onItemResolved,
}: StructuralTypeQuestionFieldsProps) {
  const [pickerOpen, setPickerOpen] = useState(false);
  const sourceLanguage = String(config.sourceLanguage ?? "");
  const targetLanguage = String(config.targetLanguage ?? "");

  function handleAddPair(selected: LearningItem) {
    onItemsChange([
      ...items,
      {
        learningItemId: selected._id,
        role: "pair",
        displayOrder: items.length,
      },
    ]);
    onItemResolved(selected);
    setPickerOpen(false);
  }

  function handleRemovePair(learningItemId: string) {
    onItemsChange(items.filter((it) => it.learningItemId !== learningItemId));
  }

  const excludeIds = items.map((it) => it.learningItemId);

  return (
    <div className="flex flex-col gap-4">
      <div className="flex gap-4">
        <LanguageField
          field="sourceLanguage"
          label="Source language"
          config={config}
          onConfigChange={onConfigChange}
        />
        <LanguageField
          field="targetLanguage"
          label="Target language"
          config={config}
          onConfigChange={onConfigChange}
        />
      </div>

      <div className="flex flex-col gap-1.5">
        <div className="flex items-center justify-between">
          <Label>Pairs</Label>
          <Button
            type="button"
            variant="outline"
            size="sm"
            onClick={() => setPickerOpen(true)}
          >
            Add pair item
          </Button>
        </div>

        {items.length === 0 && (
          <p className="text-sm text-slate-500">No pairs yet.</p>
        )}

        {items.length > 0 && (
          <div className="rounded-md border border-slate-200">
            {items.map((it) => {
              const item = itemsById[it.learningItemId];
              const sourceTranslation = findTranslation(item, sourceLanguage);
              const targetTranslation = findTranslation(item, targetLanguage);
              return (
                <div
                  key={it.learningItemId}
                  className="flex items-center justify-between gap-2 border-b border-slate-200 p-2 last:border-b-0"
                >
                  <div className="flex flex-1 flex-col text-sm">
                    <span
                      className={
                        sourceTranslation ? "text-slate-900" : "text-amber-600"
                      }
                    >
                      {sourceTranslation
                        ? sourceTranslation.text
                        : `Missing "${sourceLanguage || "source"}" translation`}
                    </span>
                    <span
                      className={
                        targetTranslation ? "text-slate-500" : "text-amber-600"
                      }
                    >
                      {targetTranslation
                        ? targetTranslation.text
                        : `Missing "${targetLanguage || "target"}" translation`}
                    </span>
                  </div>
                  <Button
                    type="button"
                    variant="outline"
                    size="sm"
                    onClick={() => handleRemovePair(it.learningItemId)}
                  >
                    Remove
                  </Button>
                </div>
              );
            })}
          </div>
        )}

        {items.length < 2 && (
          <p className="text-sm text-amber-600">
            Needs at least 2 pair items.
          </p>
        )}
      </div>

      <AttachLearningItemDialog
        open={pickerOpen}
        onOpenChange={setPickerOpen}
        excludeIds={excludeIds}
        onSelect={handleAddPair}
        title="Add Pair Item"
        alreadyUsedLabel="already in this question"
      />
    </div>
  );
}
