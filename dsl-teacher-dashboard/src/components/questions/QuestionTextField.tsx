import { cn } from "cn";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { questionTextLength } from "@/lib/questionTypes";

interface QuestionTextFieldProps {
  value: string;
  onChange: (value: string) => void;
  /** The type's default text, shown as the placeholder; `null` while loading. */
  defaultText: string | null;
  maxLength: number;
  /** A server error about this field (code `INVALID_QUESTION_TEXT`). */
  serverError: string | null;
}

export default function QuestionTextField({
  value,
  onChange,
  defaultText,
  maxLength,
  serverError,
}: QuestionTextFieldProps) {
  const length = questionTextLength(value);
  const over = length > maxLength;
  const error = over
    ? `Shorten this by ${length - maxLength} ${length - maxLength === 1 ? "character" : "characters"}.`
    : serverError;

  return (
    <div className="flex flex-col gap-1.5">
      <div className="flex items-baseline justify-between gap-3">
        <Label htmlFor="question-text">Question text</Label>
        <span
          id="question-text-count"
          className={cn(
            "text-xs tabular-nums",
            over ? "font-medium text-red-600" : length > maxLength * 0.9 ? "text-amber-600" : "text-slate-400",
          )}
        >
          {length}/{maxLength}
        </span>
      </div>
      <Textarea
        id="question-text"
        value={value}
        onChange={(e) => onChange(e.target.value)}
        placeholder={defaultText ?? ""}
        rows={2}
        aria-invalid={error ? true : undefined}
        aria-describedby="question-text-count question-text-help"
        className="min-h-[3.75rem] resize-none bg-white"
      />
      <p id="question-text-help" className={cn("text-xs", error ? "text-red-600" : "text-slate-500")}>
        {error ??
          (length === 0 && defaultText
            ? `Optional. Students see “${defaultText}” when this is empty.`
            : "Shown above the question in the student app.")}
      </p>
    </div>
  );
}
