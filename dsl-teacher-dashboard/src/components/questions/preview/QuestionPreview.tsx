import "@fontsource-variable/inter";
import type { CSSProperties, ReactNode } from "react";
import { cn } from "cn";
import { LANGUAGES } from "@/lib/languages";
import type { PreviewOption, QuestionPreviewModel } from "@/lib/questionPreview";
import type { QuestionType } from "@/types";

/*
 * Static student-app mock. It mirrors the Figma question screens cached in
 * docs/assets/mobile-screens/ (tokens: docs/mobile/figma-question-screens.md).
 *
 * The mobile tokens exist only as CSS variables on the mock's root element,
 * so nothing here can leak into the dashboard theme. The mock takes no input:
 * pointer-events are off and it's hidden from assistive tech; the visible
 * "Preview" label and the sr-only summary stand in for it.
 */

const SCREEN_W = 393;
const SCREEN_H = 852;
const BEZEL = 11;

const TOKENS = {
  "--mp-bg": "#F4F4F5",
  "--mp-card": "#FFFFFF",
  "--mp-ink": "#1E1B4B",
  "--mp-ink-soft": "#35325D",
  "--mp-muted": "#94A3B8",
  "--mp-line": "#E4E4E7",
  "--mp-cyan": "#06B8D4",
  "--mp-cyan-tint": "rgb(6 184 212 / 0.14)",
  "--mp-cyan-line": "#3AC3DB",
  "--mp-amber": "#F5B02A",
  "--mp-amber-ink": "#C98A0C",
  "--mp-amber-tint": "rgb(245 176 42 / 0.16)",
  "--mp-violet": "#8B5CF6",
  "--mp-violet-tint": "rgb(139 92 246 / 0.16)",
  "--mp-green": "#22C55E",
  "--mp-green-ink": "#16A34A",
  "--mp-green-tint": "rgb(34 197 94 / 0.13)",
  "--mp-green-line": "#B9E6CA",
  "--mp-heart": "#EF4444",
  "--mp-bezel": "#1E1B4B",
} as CSSProperties;

type BadgeTone = "cyan" | "amber" | "violet" | "green";

/** Badge copy and tint per type, as on the Figma screens (typing has no frame; it borrows cyan). */
const BADGES: Record<QuestionType, { label: string; tone: BadgeTone }> = {
  matching: { label: "Matching pairs", tone: "cyan" },
  choose_picture: { label: "Choose picture", tone: "amber" },
  listening_transcribe: { label: "Listening", tone: "violet" },
  listening_select: { label: "Listening", tone: "violet" },
  arrange_sentence: { label: "Reorder words", tone: "amber" },
  fill_blank: { label: "Fill in blank", tone: "green" },
  multiple_choice: { label: "Multiple choice", tone: "violet" },
  typing: { label: "Typing", tone: "cyan" },
};

const BADGE_CLASSES: Record<BadgeTone, string> = {
  cyan: "bg-(--mp-cyan-tint) text-(--mp-cyan)",
  amber: "bg-(--mp-amber-tint) text-(--mp-amber-ink)",
  violet: "bg-(--mp-violet-tint) text-(--mp-violet)",
  green: "bg-(--mp-green-tint) text-(--mp-green-ink)",
};

export interface QuestionPreviewProps {
  model: QuestionPreviewModel;
  /** 1-based position in the exercise, for the progress bar. */
  position: number;
  total: number;
  /** Render the solved state (correct option selected, input filled in). */
  showAnswer?: boolean;
  /** Rendered width of the device in CSS px; the screen is scaled to fit. */
  width?: number;
  /** Dashboard controls shown next to the "Preview" label (outside the mock). */
  actions?: ReactNode;
  className?: string;
}

export default function QuestionPreview({
  model,
  position,
  total,
  showAnswer = false,
  width = 300,
  actions,
  className,
}: QuestionPreviewProps) {
  const deviceW = SCREEN_W + BEZEL * 2;
  const deviceH = SCREEN_H + BEZEL * 2;
  const scale = width / deviceW;
  const badge = BADGES[model.type];

  return (
    <figure className={cn("flex flex-col items-center gap-2", className)}>
      <div className="flex items-center justify-between gap-3" style={{ width }}>
        <figcaption className="flex items-center gap-1.5 text-xs font-medium text-slate-500">
          <span className="size-1.5 rounded-full bg-cyan-500" aria-hidden="true" />
          Preview
          <span className="sr-only">
            : how students will see this question. “{model.text}”
          </span>
        </figcaption>
        {actions}
      </div>

      <div style={{ width, height: deviceH * scale }} className="shrink-0">
        <div
          aria-hidden="true"
          inert
          className="pointer-events-none origin-top-left select-none"
          style={{
            ...TOKENS,
            width: deviceW,
            height: deviceH,
            transform: `scale(${scale})`,
          }}
        >
          <div className="relative size-full rounded-[64px] bg-(--mp-bezel) p-[11px] shadow-[0_24px_48px_-24px_rgb(30_27_75/0.55)]">
            <div className="relative flex size-full flex-col overflow-hidden rounded-[54px] bg-(--mp-bg) font-['Inter_Variable',Inter,sans-serif] text-(--mp-ink) antialiased">
              <StatusBar />
              <TopBar position={position} total={total} />
              <div className="flex min-h-0 flex-1 flex-col px-4 pt-[9px]">
                <span
                  className={cn(
                    "self-start rounded-full px-3 py-[5px] text-[11px] leading-[14px] font-semibold tracking-[0.02em] uppercase",
                    BADGE_CLASSES[badge.tone],
                  )}
                >
                  {badge.label}
                </span>
                <Body model={model} showAnswer={showAnswer} />
              </div>
              <div className="px-6 pt-3 pb-[34px]">
                <div className="flex h-[54px] items-center justify-center rounded-full bg-(--mp-cyan) text-[16px] font-semibold text-(--mp-ink)">
                  Check Answer
                </div>
              </div>
              <div className="absolute bottom-2 left-1/2 h-[5px] w-[134px] -translate-x-1/2 rounded-full bg-(--mp-ink)" />
            </div>
          </div>
        </div>
      </div>
    </figure>
  );
}

function StatusBar() {
  return (
    <div className="relative flex h-[54px] shrink-0 items-center justify-between px-8 pt-1 text-[16px] font-semibold">
      <span>9:41</span>
      <div className="absolute top-[11px] left-1/2 h-[37px] w-[126px] -translate-x-1/2 rounded-full bg-black" />
      <div className="flex items-center gap-1.5">
        <svg width="18" height="12" viewBox="0 0 18 12" fill="currentColor">
          <rect x="0" y="8" width="3" height="4" rx="1" />
          <rect x="5" y="5.5" width="3" height="6.5" rx="1" />
          <rect x="10" y="3" width="3" height="9" rx="1" />
          <rect x="15" y="0" width="3" height="12" rx="1" />
        </svg>
        <svg width="25" height="12" viewBox="0 0 25 12" fill="none">
          <rect x="0.5" y="0.5" width="21" height="11" rx="3.5" stroke="currentColor" opacity="0.4" />
          <rect x="2" y="2" width="16" height="8" rx="2" fill="currentColor" />
          <rect x="23" y="4" width="1.5" height="4" rx="0.75" fill="currentColor" opacity="0.4" />
        </svg>
      </div>
    </div>
  );
}

function TopBar({ position, total }: { position: number; total: number }) {
  const progress = total > 0 ? Math.min(1, position / total) : 0;
  return (
    <div className="shrink-0">
      <div className="flex h-[44px] items-center gap-3 px-4">
        <span className="flex size-7 items-center justify-center text-[15px] font-semibold text-(--mp-ink-soft)">
          X
        </span>
        <div className="h-1.5 flex-1 overflow-hidden rounded-full bg-(--mp-line)">
          <div className="h-full rounded-full bg-(--mp-cyan)" style={{ width: `${progress * 100}%` }} />
        </div>
        <span className="min-w-8 text-right text-[12px] font-semibold text-(--mp-cyan)">
          {position}/{total}
        </span>
      </div>
      <div className="flex gap-1 px-5 pb-2">
        {[0, 1, 2].map((i) => (
          <span key={i} className="size-2.5 rounded-full bg-(--mp-heart)" />
        ))}
      </div>
      <div className="h-px bg-(--mp-line)" />
    </div>
  );
}

function Title({ children }: { children: ReactNode }) {
  return (
    <h3 className="mt-2.5 mb-4 px-2 text-center text-[18px] leading-[24px] font-semibold text-balance text-(--mp-ink)">
      {children}
    </h3>
  );
}

/** Stand-in for content the teacher hasn't supplied yet. */
function Missing({ children, className }: { children: ReactNode; className?: string }) {
  return (
    <div
      className={cn(
        "flex items-center justify-center rounded-2xl border-[1.5px] border-dashed border-(--mp-muted)/60 px-4 py-3 text-center text-[13px] text-(--mp-muted)",
        className,
      )}
    >
      {children}
    </div>
  );
}

function languageName(code: string) {
  return LANGUAGES.find((l) => l.code === code)?.label ?? code.toUpperCase();
}

function Body({ model, showAnswer }: { model: QuestionPreviewModel; showAnswer: boolean }) {
  switch (model.type) {
    case "choose_picture":
      return (
        <>
          <Title>{model.text}</Title>
          {model.prompt ? (
            <p className="-mt-2 mb-4 text-center text-[22px] leading-[30px] font-bold">{model.prompt}</p>
          ) : (
            <Missing className="-mt-1 mb-4">Pick a target item with a prompt translation</Missing>
          )}
          {model.options.length === 0 ? (
            <Missing className="h-[180px]">Add a target and distractors</Missing>
          ) : (
            <div className="grid grid-cols-2 gap-3">
              {model.options.slice(0, 6).map((option) => (
                <PictureTile key={option.key} option={option} selected={showAnswer && option.correct} />
              ))}
            </div>
          )}
        </>
      );

    case "multiple_choice":
      return (
        <>
          <div className="mt-2.5 mb-3.5 rounded-2xl bg-(--mp-card) px-4 py-3.5">
            <p className="text-[15px] leading-[20px] font-semibold text-(--mp-ink)">{model.text}</p>
            {model.prompt ? (
              <p className="mt-1 text-[22px] leading-[28px] font-bold text-(--mp-cyan)">{model.prompt}</p>
            ) : (
              <p className="mt-1 text-[13px] text-(--mp-muted)">Pick a target item with a prompt translation</p>
            )}
          </div>
          <OptionList options={model.options} showAnswer={showAnswer} />
        </>
      );

    case "listening_select":
      return (
        <>
          <Title>{model.text}</Title>
          <AudioCard hasAudio={model.hasAudio} compact />
          <div className="mt-3.5">
            <OptionList options={model.options} showAnswer={showAnswer} />
          </div>
        </>
      );

    case "listening_transcribe":
      return (
        <>
          <Title>{model.text}</Title>
          <AudioCard hasAudio={model.hasAudio} />
          <AnswerInput
            label={`Type what you heard${model.answerLanguage ? ` in ${languageName(model.answerLanguage)}` : ""}:`}
            answer={model.answer}
            showAnswer={showAnswer}
          />
        </>
      );

    case "typing":
      return (
        <>
          <Title>{model.text}</Title>
          <div className="flex min-h-[96px] items-center justify-center rounded-2xl border border-(--mp-cyan-line)/40 bg-(--mp-card) px-4 py-4">
            {model.prompt ? (
              <p className="text-center text-[26px] leading-[32px] font-bold">{model.prompt}</p>
            ) : (
              <p className="text-[13px] text-(--mp-muted)">Pick a target item with a prompt translation</p>
            )}
          </div>
          <AnswerInput
            label={`Type it in ${model.answerLanguage ? languageName(model.answerLanguage) : "the answer language"}:`}
            answer={model.answer}
            showAnswer={showAnswer}
          />
        </>
      );

    case "fill_blank":
      return (
        <>
          <Title>{model.text}</Title>
          {model.sentence ? (
            <div className="rounded-2xl border border-(--mp-cyan-line)/40 bg-(--mp-card) px-3 py-4 text-[17px] leading-[30px]">
              {model.sentence.before}
              <span
                className={cn(
                  "mx-0.5 inline-flex h-[26px] min-w-[62px] items-center justify-center rounded-lg px-2 align-middle text-[15px] leading-none font-semibold",
                  showAnswer
                    ? "border border-(--mp-cyan-line) bg-(--mp-cyan-tint) text-(--mp-cyan)"
                    : "border-[1.5px] border-dashed border-(--mp-cyan-line)",
                )}
              >
                {showAnswer ? model.answer : ""}
              </span>
              {model.sentence.after}
            </div>
          ) : (
            <Missing className="h-24">Pick a target sentence and its blank word</Missing>
          )}
          {model.hint && <HintCard label="Translation">{model.hint}</HintCard>}
          <AnswerInput label="Type the missing word:" answer={model.answer} showAnswer={showAnswer} />
        </>
      );

    case "arrange_sentence":
      return (
        <>
          <Title>{model.text}</Title>
          {model.hint ? (
            <HintCard label="Translate:" first>
              {model.hint}
            </HintCard>
          ) : (
            <Missing>Pick a target sentence with a prompt translation</Missing>
          )}
          <p className="mt-3 mb-2 text-[12px] text-(--mp-muted)">Your sentence:</p>
          <div className="flex min-h-[40px] flex-wrap gap-1.5">
            {model.answerWords.length === 0 ? (
              <span className="h-10 w-[62px] rounded-xl border-[1.5px] border-dashed border-(--mp-line)" />
            ) : (
              model.answerWords.map((word, i) =>
                showAnswer ? (
                  <WordChip key={i} word={word} tone="selected" />
                ) : (
                  <span key={i} className="flex h-10 w-[62px] items-center justify-center rounded-xl bg-(--mp-card)/60">
                    <span className="h-0.5 w-10 rounded-full bg-(--mp-line)" />
                  </span>
                ),
              )
            )}
          </div>
          <div className="mx-2 mt-3.5 h-px bg-(--mp-line)" />
          <p className="my-2 text-center text-[12px] text-(--mp-muted)">Tap words below to add them</p>
          <div className="flex flex-wrap justify-center gap-1.5">
            {model.bank.length === 0 ? (
              <Missing className="w-full">Word blocks appear here</Missing>
            ) : (
              model.bank.map((word, i) => <WordChip key={`${word}-${i}`} word={word} tone="bank" />)
            )}
          </div>
        </>
      );

    case "matching": {
      const rightOrder = showAnswer ? model.pairs.map((_, i) => i) : model.targetOrder;
      return (
        <>
          <Title>{model.text}</Title>
          {model.pairs.length === 0 ? (
            <Missing className="h-40">Add at least 2 pair items</Missing>
          ) : (
            <>
              <div className="mb-1.5 grid grid-cols-2 gap-3 px-1 text-[10px] font-semibold tracking-[0.04em] text-(--mp-muted) uppercase">
                <span>{model.sourceLanguage ? languageName(model.sourceLanguage) : "Terms"}</span>
                <span>{model.targetLanguage ? languageName(model.targetLanguage) : "Meanings"}</span>
              </div>
              <div className="grid grid-cols-2 gap-x-3 gap-y-2.5">
                {model.pairs.slice(0, 6).flatMap((pair, row) => {
                  const right = model.pairs[rightOrder[row] ?? row];
                  return [
                    <MatchCard key={`s-${pair.key}`} text={pair.source} matched={showAnswer} bold />,
                    <MatchCard key={`t-${right?.key ?? row}`} text={right?.target ?? null} matched={showAnswer} />,
                  ];
                })}
              </div>
              <p className="mt-3 text-center text-[12px] text-(--mp-muted)">
                Tap a term, then tap its matching translation
              </p>
            </>
          )}
        </>
      );
    }
  }
}

function PictureTile({ option, selected }: { option: PreviewOption; selected: boolean }) {
  return (
    <div
      className={cn(
        "relative rounded-2xl p-3",
        selected ? "border-2 border-(--mp-cyan-line) bg-(--mp-cyan-tint)" : "border-2 border-transparent bg-(--mp-card)",
      )}
    >
      <div className="aspect-[136/110] overflow-hidden rounded-xl bg-(--mp-bg)">
        {option.imageUrl ? (
          <img src={option.imageUrl} alt="" className="size-full object-cover" />
        ) : (
          <div className="flex size-full items-center justify-center text-[11px] text-(--mp-muted)">No image</div>
        )}
      </div>
      <span
        className={cn(
          "absolute top-2 right-2 flex size-[22px] items-center justify-center rounded-full border-2 bg-(--mp-card)",
          selected ? "border-(--mp-cyan)" : "border-(--mp-line)",
        )}
      >
        {selected && <span className="size-3 rounded-full bg-(--mp-cyan)" />}
      </span>
    </div>
  );
}

function OptionList({ options, showAnswer }: { options: PreviewOption[]; showAnswer: boolean }) {
  if (options.length === 0) {
    return <Missing className="h-[140px]">Add a target and distractors</Missing>;
  }
  return (
    <div className="flex flex-col gap-2.5">
      {options.slice(0, 5).map((option, i) => {
        const selected = showAnswer && option.correct;
        return (
          <div
            key={option.key}
            className={cn(
              "flex h-[62px] items-center gap-3 rounded-2xl px-3",
              selected ? "border-2 border-(--mp-cyan-line) bg-(--mp-cyan-tint)" : "border-2 border-transparent bg-(--mp-card)",
            )}
          >
            <span
              className={cn(
                "flex size-[30px] shrink-0 items-center justify-center rounded-full text-[13px] font-semibold",
                selected
                  ? "border border-(--mp-cyan-line) bg-(--mp-cyan)/35 text-(--mp-cyan)"
                  : "border border-(--mp-line) text-(--mp-muted)",
              )}
            >
              {String.fromCharCode(65 + i)}
            </span>
            <span
              className={cn(
                "flex-1 truncate text-[15px]",
                selected ? "font-semibold text-(--mp-ink)" : "text-(--mp-ink-soft)",
                option.text === null && "text-(--mp-muted) italic",
              )}
            >
              {option.text ?? "Missing translation"}
            </span>
            <span
              className={cn(
                "flex size-[26px] items-center justify-center rounded-full border-2",
                selected ? "border-(--mp-cyan)" : "border-(--mp-line)",
              )}
            >
              {selected && <span className="size-3.5 rounded-full bg-(--mp-cyan)" />}
            </span>
          </div>
        );
      })}
    </div>
  );
}

function AudioCard({ hasAudio, compact = false }: { hasAudio: boolean; compact?: boolean }) {
  const bars = [8, 14, 22, 16, 10, 28, 20, 12, 36, 18, 8, 30, 16, 38, 24, 12, 20, 14, 30, 18, 10, 22, 16];
  return (
    <div className="rounded-2xl border border-(--mp-cyan-line)/40 bg-(--mp-card) px-3 pt-4 pb-2.5">
      <div className="flex items-center gap-4">
        <span className="flex size-[50px] shrink-0 items-center justify-center rounded-full border-2 border-(--mp-cyan-line) bg-(--mp-cyan-tint)">
          <span className="size-[18px] rounded-[4px] bg-(--mp-cyan)" />
        </span>
        <div className={cn("flex h-10 flex-1 items-center gap-[3px]", !hasAudio && "opacity-30")}>
          {bars.slice(0, compact ? 20 : 23).map((h, i) => (
            <span key={i} className="w-[5px] rounded-full bg-(--mp-cyan)" style={{ height: h, opacity: 0.45 + (h / 38) * 0.55 }} />
          ))}
        </div>
      </div>
      <p className="mt-2 text-center text-[12px] text-(--mp-ink-soft)">
        {hasAudio ? "Tap to replay audio" : "No recording on the target's audio translation"}
      </p>
    </div>
  );
}

function AnswerInput({ label, answer, showAnswer }: { label: string; answer: string | null; showAnswer: boolean }) {
  return (
    <div className="mt-4 px-2">
      <p className="mb-1.5 text-[12px] text-(--mp-muted)">{label}</p>
      <div className="flex h-[54px] items-center rounded-xl border-2 border-(--mp-cyan-line) bg-(--mp-card) px-4 text-[15px]">
        {showAnswer ? (
          answer ? (
            <span className="font-medium">{answer}</span>
          ) : (
            <span className="text-(--mp-muted) italic">Missing answer translation</span>
          )
        ) : (
          <span className="h-[22px] w-0.5 rounded-full bg-(--mp-cyan)" />
        )}
      </div>
    </div>
  );
}

function HintCard({ label, children, first = false }: { label: string; children: ReactNode; first?: boolean }) {
  return (
    <div className={cn("rounded-xl border border-(--mp-amber)/45 bg-(--mp-card) px-2.5 py-2", !first && "mt-3")}>
      <p className="text-[10px] font-medium text-(--mp-amber-ink)">{label}</p>
      <p className="text-[13px] leading-[18px] text-(--mp-ink)">{children}</p>
    </div>
  );
}

function WordChip({ word, tone }: { word: string; tone: "bank" | "selected" }) {
  return (
    <span
      className={cn(
        "flex h-10 items-center rounded-xl px-3.5 text-[14px]",
        tone === "selected"
          ? "border-2 border-(--mp-cyan-line) bg-(--mp-cyan-tint) font-semibold text-(--mp-cyan)"
          : "bg-(--mp-card) text-(--mp-ink)",
      )}
    >
      {word}
    </span>
  );
}

function MatchCard({ text, matched, bold = false }: { text: string | null; matched: boolean; bold?: boolean }) {
  return (
    <div
      className={cn(
        "flex h-[62px] items-center justify-center rounded-2xl px-2 text-center text-[14px] leading-[18px]",
        matched ? "border-2 border-(--mp-green) bg-(--mp-green-tint) text-(--mp-green-ink)" : "border-2 border-transparent bg-(--mp-card)",
        bold && "font-semibold",
        text === null && "text-[12px] text-(--mp-muted) italic",
      )}
    >
      {text ?? "Missing translation"}
    </div>
  );
}
