import { cn } from "cn";

/** Switches the preview between the unanswered screen and the solved one. */
export default function ShowAnswerToggle({
  checked,
  onChange,
}: {
  checked: boolean;
  onChange: (checked: boolean) => void;
}) {
  return (
    <label className="inline-flex cursor-pointer items-center gap-2 text-xs text-slate-600 select-none">
      <input
        type="checkbox"
        role="switch"
        checked={checked}
        onChange={(e) => onChange(e.target.checked)}
        className="peer sr-only"
      />
      <span
        aria-hidden="true"
        className={cn(
          "relative h-4 w-7 rounded-full transition-colors peer-focus-visible:ring-3 peer-focus-visible:ring-cyan-500/40",
          checked ? "bg-cyan-600" : "bg-slate-300",
        )}
      >
        <span
          className={cn(
            "absolute top-0.5 left-0.5 size-3 rounded-full bg-white shadow-sm transition-transform motion-reduce:transition-none",
            checked && "translate-x-3",
          )}
        />
      </span>
      Show answer
    </label>
  );
}
