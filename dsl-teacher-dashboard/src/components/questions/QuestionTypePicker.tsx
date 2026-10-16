import { cn } from "cn";
import QuestionTypeGlyph from "@/components/questions/QuestionTypeGlyph";
import {
  QUESTION_FAMILIES,
  QUESTION_TYPES_BY_FAMILY,
  QUESTION_TYPE_INFO,
} from "@/lib/questionTypes";
import type { QuestionType } from "@/types";

interface QuestionTypePickerProps {
  value: QuestionType | null;
  onChange: (type: QuestionType) => void;
}

/**
 * The 8 question types as visual cards, grouped by what the student does.
 * Native radio inputs give it arrow-key navigation and form semantics.
 */
export default function QuestionTypePicker({ value, onChange }: QuestionTypePickerProps) {
  return (
    <fieldset className="flex flex-col gap-5">
      <legend className="sr-only">Question type</legend>
      {QUESTION_FAMILIES.map((family) => (
        <div key={family.family} className="flex flex-col gap-2">
          <div className="flex items-baseline gap-2">
            <h3 className="text-sm font-semibold text-slate-900">{family.title}</h3>
            <p className="text-xs text-slate-500">{family.hint}</p>
          </div>
          <div className="grid grid-cols-1 gap-2 sm:grid-cols-3">
            {QUESTION_TYPES_BY_FAMILY[family.family].map((type) => {
              const info = QUESTION_TYPE_INFO[type];
              const checked = value === type;
              return (
                <label
                  key={type}
                  className={cn(
                    "group relative flex cursor-pointer gap-3 rounded-lg border bg-white p-3 transition-colors",
                    "has-focus-visible:ring-3 has-focus-visible:ring-cyan-500/40",
                    checked
                      ? "border-cyan-600 bg-cyan-50/60 [--glyph-accent:#0891b2]"
                      : "border-slate-200 hover:border-slate-300 hover:bg-slate-50 [--glyph-accent:#94a3b8]",
                  )}
                >
                  <input
                    type="radio"
                    name="question-type"
                    value={type}
                    checked={checked}
                    onChange={() => onChange(type)}
                    className="sr-only"
                  />
                  <QuestionTypeGlyph
                    type={type}
                    className={cn(
                      "mt-0.5 transition-colors",
                      checked ? "text-cyan-200" : "text-slate-200 group-hover:[--glyph-accent:#0891b2]",
                    )}
                  />
                  <span className="flex flex-col gap-0.5">
                    <span className={cn("text-sm font-medium", checked ? "text-cyan-900" : "text-slate-900")}>
                      {info.label}
                    </span>
                    <span className="text-xs leading-snug text-slate-500">{info.description}</span>
                  </span>
                </label>
              );
            })}
          </div>
        </div>
      ))}
    </fieldset>
  );
}
