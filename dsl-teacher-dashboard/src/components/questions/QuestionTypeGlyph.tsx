import { cn } from "cn";
import type { QuestionType } from "@/types";

/**
 * A miniature of the student's screen for each question type. Neutral parts
 * use `currentColor`; the part the student acts on uses the accent.
 */
export default function QuestionTypeGlyph({
  type,
  className,
}: {
  type: QuestionType;
  className?: string;
}) {
  return (
    <svg
      viewBox="0 0 40 32"
      aria-hidden="true"
      className={cn("h-8 w-10 shrink-0 text-slate-300", className)}
    >
      {GLYPHS[type]}
    </svg>
  );
}

const ACCENT = "var(--glyph-accent, #0891b2)";

const Wave = ({ x, y }: { x: number; y: number }) => (
  <g fill="currentColor">
    {[3, 6, 9, 5, 8, 4, 7, 3].map((h, i) => (
      <rect key={i} x={x + i * 2.5} y={y - h / 2} width="1.4" height={h} rx="0.7" />
    ))}
  </g>
);

const GLYPHS: Record<QuestionType, React.ReactNode> = {
  choose_picture: (
    <>
      <rect x="3" y="2" width="16" height="13" rx="2.5" fill={ACCENT} />
      <rect x="21" y="2" width="16" height="13" rx="2.5" fill="currentColor" />
      <rect x="3" y="17" width="16" height="13" rx="2.5" fill="currentColor" />
      <rect x="21" y="17" width="16" height="13" rx="2.5" fill="currentColor" />
    </>
  ),
  multiple_choice: (
    <>
      <rect x="3" y="2" width="34" height="6" rx="2" fill="currentColor" />
      <rect x="3" y="10" width="34" height="6" rx="2" fill={ACCENT} />
      <rect x="3" y="18" width="34" height="6" rx="2" fill="currentColor" />
      <rect x="3" y="26" width="34" height="5" rx="2" fill="currentColor" opacity="0.6" />
    </>
  ),
  listening_select: (
    <>
      <circle cx="7" cy="7" r="4.5" fill={ACCENT} />
      <Wave x={15} y={7} />
      <rect x="3" y="15" width="34" height="7" rx="2" fill={ACCENT} />
      <rect x="3" y="24" width="34" height="7" rx="2" fill="currentColor" />
    </>
  ),
  typing: (
    <>
      <rect x="8" y="4" width="24" height="8" rx="2" fill="currentColor" />
      <rect x="3" y="18" width="34" height="11" rx="2.5" fill="none" stroke={ACCENT} strokeWidth="1.6" />
      <rect x="8" y="21" width="1.6" height="5" fill={ACCENT} />
    </>
  ),
  listening_transcribe: (
    <>
      <circle cx="7" cy="8" r="4.5" fill={ACCENT} />
      <Wave x={15} y={8} />
      <rect x="3" y="18" width="34" height="11" rx="2.5" fill="none" stroke={ACCENT} strokeWidth="1.6" />
      <rect x="8" y="21" width="1.6" height="5" fill={ACCENT} />
    </>
  ),
  fill_blank: (
    <>
      <rect x="3" y="6" width="8" height="5" rx="1.5" fill="currentColor" />
      <rect x="13" y="4" width="12" height="9" rx="2" fill="none" stroke={ACCENT} strokeWidth="1.6" strokeDasharray="2 1.5" />
      <rect x="27" y="6" width="10" height="5" rx="1.5" fill="currentColor" />
      <rect x="3" y="17" width="22" height="5" rx="1.5" fill="currentColor" />
      <rect x="27" y="17" width="7" height="5" rx="1.5" fill="currentColor" />
      <rect x="3" y="26" width="14" height="5" rx="1.5" fill="currentColor" opacity="0.6" />
    </>
  ),
  arrange_sentence: (
    <>
      <rect x="3" y="3" width="10" height="7" rx="2" fill={ACCENT} />
      <rect x="15" y="3" width="13" height="7" rx="2" fill={ACCENT} />
      <rect x="30" y="3" width="7" height="7" rx="2" fill="none" stroke="currentColor" strokeWidth="1.2" strokeDasharray="2 1.5" />
      <rect x="3" y="19" width="8" height="7" rx="2" fill="currentColor" />
      <rect x="13" y="19" width="14" height="7" rx="2" fill="currentColor" />
      <rect x="29" y="19" width="8" height="7" rx="2" fill="currentColor" />
    </>
  ),
  matching: (
    <>
      <rect x="3" y="3" width="13" height="7" rx="2" fill={ACCENT} />
      <rect x="3" y="13" width="13" height="7" rx="2" fill="currentColor" />
      <rect x="3" y="23" width="13" height="7" rx="2" fill="currentColor" />
      <rect x="24" y="3" width="13" height="7" rx="2" fill="currentColor" />
      <rect x="24" y="13" width="13" height="7" rx="2" fill={ACCENT} />
      <rect x="24" y="23" width="13" height="7" rx="2" fill="currentColor" />
      <path d="M16 6.5 L24 16.5" stroke={ACCENT} strokeWidth="1.6" strokeLinecap="round" />
    </>
  ),
};
