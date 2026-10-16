import { useMemo, useState } from "react";
import { ChevronLeft, ChevronRight, Pencil } from "lucide-react";
import { Button } from "@/components/ui/button";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import QuestionPreview from "@/components/questions/preview/QuestionPreview";
import ShowAnswerToggle from "@/components/questions/preview/ShowAnswerToggle";
import { usePreviewSources } from "@/components/questions/preview/usePreviewSources";
import { buildPreviewModel } from "@/lib/questionPreview";
import { QUESTION_TYPE_INFO } from "@/lib/questionTypes";
import type { Question } from "@/types";

interface QuestionPreviewDialogProps {
  /** The exercise's questions in order; the dialog steps through them. */
  questions: Question[];
  questionId: string | null;
  onQuestionIdChange: (id: string | null) => void;
  onEdit: (question: Question) => void;
}

export default function QuestionPreviewDialog({
  questions,
  questionId,
  onQuestionIdChange,
  onEdit,
}: QuestionPreviewDialogProps) {
  const [showAnswer, setShowAnswer] = useState(false);
  const index = questions.findIndex((q) => q._id === questionId);
  const question = index >= 0 ? questions[index] : undefined;
  const { itemsById, mediaById, loading } = usePreviewSources(question?.items ?? []);

  const model = useMemo(
    () =>
      question
        ? buildPreviewModel({
            type: question.type,
            config: question.config,
            items: question.items,
            text: question.displayText,
            itemsById,
            mediaById,
          })
        : null,
    [question, itemsById, mediaById],
  );

  const previous = index > 0 ? questions[index - 1] : undefined;
  const next = index >= 0 && index < questions.length - 1 ? questions[index + 1] : undefined;

  return (
    <Dialog open={question !== undefined} onOpenChange={(open) => !open && onQuestionIdChange(null)}>
      <DialogContent
        className="gap-4 p-5 sm:max-w-md"
        onKeyDown={(e) => {
          if (e.key === "ArrowLeft" && previous) onQuestionIdChange(previous._id);
          if (e.key === "ArrowRight" && next) onQuestionIdChange(next._id);
        }}
      >
        {question && model && (
          <>
            <DialogHeader className="pr-8">
              <DialogTitle>
                Question {index + 1} of {questions.length}
              </DialogTitle>
              <DialogDescription>
                {QUESTION_TYPE_INFO[question.type].label}, {question.points} points
                {loading && <span className="text-slate-400"> (loading items…)</span>}
              </DialogDescription>
            </DialogHeader>

            <QuestionPreview
              model={model}
              position={index + 1}
              total={questions.length}
              showAnswer={showAnswer}
              width={290}
              actions={<ShowAnswerToggle checked={showAnswer} onChange={setShowAnswer} />}
            />

            <div className="flex items-center justify-between gap-2 border-t border-slate-200 pt-3">
              <Button
                variant="outline"
                size="icon-sm"
                disabled={!previous}
                onClick={() => previous && onQuestionIdChange(previous._id)}
                aria-label="Previous question"
              >
                <ChevronLeft />
              </Button>
              <Button
                variant="outline"
                size="sm"
                onClick={() => {
                  onQuestionIdChange(null);
                  onEdit(question);
                }}
              >
                <Pencil data-icon="inline-start" />
                Edit question
              </Button>
              <Button
                variant="outline"
                size="icon-sm"
                disabled={!next}
                onClick={() => next && onQuestionIdChange(next._id)}
                aria-label="Next question"
              >
                <ChevronRight />
              </Button>
            </div>
          </>
        )}
      </DialogContent>
    </Dialog>
  );
}
