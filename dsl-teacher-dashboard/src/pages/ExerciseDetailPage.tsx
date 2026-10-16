import {
  DndContext,
  PointerSensor,
  closestCenter,
  useSensor,
  useSensors,
  type DragEndEvent,
} from "@dnd-kit/core";
import {
  SortableContext,
  arrayMove,
  verticalListSortingStrategy,
} from "@dnd-kit/sortable";
import { useEffect, useState } from "react";
import { Link, useNavigate, useParams } from "react-router-dom";
import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
} from "@/components/ui/alert-dialog";
import { Button } from "@/components/ui/button";
import { toast } from "@/components/ui/toast";
import ExerciseFormDialog from "@/components/exercises/ExerciseFormDialog";
import { Plus } from "lucide-react";
import QuestionFormDialog from "@/components/questions/QuestionFormDialog";
import QuestionPreviewDialog from "@/components/questions/QuestionPreviewDialog";
import QuestionTypeGlyph from "@/components/questions/QuestionTypeGlyph";
import SortableQuestionRow from "@/components/questions/SortableQuestionRow";
import { resetPreviewCache } from "@/components/questions/preview/usePreviewSources";
import PublishToggle from "@/components/PublishToggle";
import { ApiError } from "@/lib/api";
import { languageOptionsFromCodes } from "@/lib/languages";
import { getCourse } from "@/lib/resources/courses";
import {
  deleteExercise,
  getExercise,
  updateExercise,
} from "@/lib/resources/exercises";
import {
  deleteQuestion,
  listQuestions,
  reorderQuestions,
} from "@/lib/resources/questions";
import { getUnit } from "@/lib/resources/units";
import type { Course, Exercise, Question, Unit } from "@/types";

type Status = "loading" | "not-found" | "error" | "ready";

export default function ExerciseDetailPage() {
  const { exerciseId } = useParams<{ exerciseId: string }>();
  const navigate = useNavigate();

  const [exercise, setExercise] = useState<Exercise | null>(null);
  const [unit, setUnit] = useState<Unit | null>(null);
  const [course, setCourse] = useState<Course | null>(null);
  const [questions, setQuestions] = useState<Question[]>([]);
  const [status, setStatus] = useState<Status>("loading");
  const [errorMessage, setErrorMessage] = useState<string | null>(null);

  const [editExerciseOpen, setEditExerciseOpen] = useState(false);
  const [deleteExerciseOpen, setDeleteExerciseOpen] = useState(false);
  const [deletingExercise, setDeletingExercise] = useState(false);

  const [questionFormOpen, setQuestionFormOpen] = useState(false);
  const [editingQuestion, setEditingQuestion] = useState<Question | undefined>(
    undefined,
  );
  const [deleteQuestionTarget, setDeleteQuestionTarget] =
    useState<Question | null>(null);
  const [deletingQuestion, setDeletingQuestion] = useState(false);
  const [previewQuestionId, setPreviewQuestionId] = useState<string | null>(
    null,
  );

  const sensors = useSensors(
    useSensor(PointerSensor, {
      activationConstraint: { distance: 5 },
    }),
  );

  function fetchData() {
    if (!exerciseId) return;
    setStatus("loading");
    setErrorMessage(null);
    getExercise(exerciseId)
      .then((exerciseData) =>
        getUnit(exerciseData.unitId).then((unitData) =>
          Promise.all([
            getCourse(unitData.courseId),
            listQuestions({ exerciseId: exerciseData._id }),
          ]).then(([courseData, questionList]) => {
            setExercise(exerciseData);
            setUnit(unitData);
            setCourse(courseData);
            setQuestions(questionList);
            setStatus("ready");
          }),
        ),
      )
      .catch((err) => {
        if (err instanceof ApiError && err.status === 404) {
          setStatus("not-found");
        } else {
          setErrorMessage(
            err instanceof Error ? err.message : "Request failed",
          );
          setStatus("error");
        }
      });
  }

  useEffect(() => {
    // Learning items may have been edited on another page since the last visit.
    resetPreviewCache();
    fetchData();
  }, [exerciseId]);

  function handleExerciseSaved() {
    fetchData();
  }

  async function handleToggleExercisePublish() {
    if (!exercise) return;
    const updated = await updateExercise(exercise._id, {
      isPublished: !exercise.isPublished,
    });
    setExercise(updated);
  }

  async function handleConfirmDeleteExercise() {
    if (!exercise) return;
    setDeletingExercise(true);
    try {
      await deleteExercise(exercise._id);
      navigate(`/units/${exercise.unitId}`);
    } catch (err) {
      toast.add({
        type: "error",
        title: "Could not delete exercise",
        description: err instanceof Error ? err.message : "Request failed",
      });
    } finally {
      setDeletingExercise(false);
      setDeleteExerciseOpen(false);
    }
  }

  function openCreateQuestionDialog() {
    setEditingQuestion(undefined);
    setQuestionFormOpen(true);
  }

  function openEditQuestionDialog(question: Question) {
    setEditingQuestion(question);
    setQuestionFormOpen(true);
  }

  function handleQuestionSaved(saved: Question) {
    setQuestions((prev) => {
      const exists = prev.some((q) => q._id === saved._id);
      if (exists) {
        return prev.map((q) => (q._id === saved._id ? saved : q));
      }
      return [...prev, saved].sort((a, b) => a.orderIndex - b.orderIndex);
    });
  }

  async function handleConfirmDeleteQuestion() {
    if (!deleteQuestionTarget) return;
    const target = deleteQuestionTarget;
    setDeletingQuestion(true);
    try {
      await deleteQuestion(target._id);
      setQuestions((prev) => prev.filter((q) => q._id !== target._id));
    } catch (err) {
      toast.add({
        type: "error",
        title: "Could not delete question",
        description: err instanceof Error ? err.message : "Request failed",
      });
    } finally {
      setDeletingQuestion(false);
      setDeleteQuestionTarget(null);
    }
  }

  async function handleQuestionDragEnd(event: DragEndEvent) {
    const { active, over } = event;
    if (!over || active.id === over.id) return;

    const oldIndex = questions.findIndex((q) => q._id === active.id);
    const newIndex = questions.findIndex((q) => q._id === over.id);
    if (oldIndex === -1 || newIndex === -1) return;

    const previousQuestions = questions;
    const reordered = arrayMove(questions, oldIndex, newIndex).map(
      (q, index) => ({ ...q, orderIndex: index }),
    );
    setQuestions(reordered);

    try {
      const updatedQuestions = await reorderQuestions(
        reordered.map((q) => ({ id: q._id, orderIndex: q.orderIndex })),
      );
      setQuestions(
        [...updatedQuestions].sort((a, b) => a.orderIndex - b.orderIndex),
      );
    } catch (err) {
      setQuestions(previousQuestions);
      toast.add({
        type: "error",
        title: "Could not reorder questions",
        description: err instanceof Error ? err.message : "Request failed",
      });
    }
  }

  if (status === "loading") {
    return <ExerciseDetailSkeleton />;
  }

  if (status === "not-found") {
    return (
      <div>
        <Link
          to="/specializations"
          className="text-sm text-cyan-700 hover:underline"
        >
          ← Back to Specializations
        </Link>
        <div className="mt-4 rounded-md border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-600">
          Exercise not found.
        </div>
      </div>
    );
  }

  if (status === "error") {
    return (
      <div>
        <Link
          to="/specializations"
          className="text-sm text-cyan-700 hover:underline"
        >
          ← Back to Specializations
        </Link>
        <div className="mt-4 rounded-md border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-600">
          Failed to load exercise: {errorMessage}
          <Button
            variant="outline"
            size="sm"
            className="ml-3"
            onClick={fetchData}
          >
            Retry
          </Button>
        </div>
      </div>
    );
  }

  if (!exercise || !course) return null;

  const nextQuestionOrderIndex =
    questions.length > 0
      ? Math.max(...questions.map((q) => q.orderIndex)) + 1
      : 0;

  const totalPoints = questions.reduce((sum, q) => sum + q.points, 0);

  const questionLanguageOptions = languageOptionsFromCodes([
    course.sourceLanguage,
    course.targetLanguage,
  ]);

  return (
    <div className="flex flex-col gap-8">
      <div>
        <Link
          to={`/units/${exercise.unitId}`}
          className="text-sm text-cyan-700 hover:underline"
        >
          ← Back to Unit
        </Link>

        <div className="mt-2 flex items-center justify-between">
          <div className="flex items-center gap-2">
            <h1 className="text-xl font-semibold text-slate-900">
              {exercise.name}
            </h1>
            <PublishToggle
              isPublished={exercise.isPublished}
              onToggle={handleToggleExercisePublish}
            />
          </div>
          <div className="flex gap-2">
            <Button
              variant="outline"
              size="sm"
              onClick={() => setEditExerciseOpen(true)}
            >
              Edit
            </Button>
            <Button
              variant="destructive"
              size="sm"
              onClick={() => setDeleteExerciseOpen(true)}
            >
              Delete
            </Button>
          </div>
        </div>
      </div>

      <section aria-labelledby="questions-heading">
        <div className="mb-3 flex items-end justify-between gap-4">
          <div>
            <h2
              id="questions-heading"
              className="text-lg font-semibold text-slate-900"
            >
              Questions
            </h2>
            {questions.length > 0 && (
              <p className="text-sm text-slate-500">
                {questions.length}{" "}
                {questions.length === 1 ? "question" : "questions"}, worth{" "}
                {totalPoints} points in total. Drag to change the order
                students see them in.
              </p>
            )}
          </div>
          {questions.length > 0 && (
            <Button size="sm" onClick={openCreateQuestionDialog}>
              <Plus data-icon="inline-start" />
              New question
            </Button>
          )}
        </div>

        {questions.length === 0 && (
          <div className="flex flex-col items-center gap-4 rounded-lg border border-dashed border-slate-300 bg-white px-6 py-12 text-center">
            <div className="flex gap-2 [--glyph-accent:#06b6d4]" aria-hidden="true">
              <QuestionTypeGlyph type="multiple_choice" className="text-slate-200" />
              <QuestionTypeGlyph type="listening_transcribe" className="text-slate-200" />
              <QuestionTypeGlyph type="matching" className="text-slate-200" />
            </div>
            <div className="flex max-w-sm flex-col gap-1">
              <p className="font-medium text-slate-900">
                This exercise has no questions yet
              </p>
              <p className="text-sm text-slate-500">
                Add a question to build the exercise. It can be published once
                it has at least one.
              </p>
            </div>
            <Button onClick={openCreateQuestionDialog}>
              <Plus data-icon="inline-start" />
              Add the first question
            </Button>
          </div>
        )}

        {questions.length > 0 && (
          <DndContext
            sensors={sensors}
            collisionDetection={closestCenter}
            onDragEnd={handleQuestionDragEnd}
          >
            <SortableContext
              items={questions.map((q) => q._id)}
              strategy={verticalListSortingStrategy}
            >
              <ol className="overflow-hidden rounded-lg border border-slate-200 bg-white">
                {questions.map((question, index) => (
                  <SortableQuestionRow
                    key={question._id}
                    question={question}
                    position={index + 1}
                    onEdit={openEditQuestionDialog}
                    onPreview={(q) => setPreviewQuestionId(q._id)}
                    onDelete={setDeleteQuestionTarget}
                  />
                ))}
              </ol>
            </SortableContext>
          </DndContext>
        )}
      </section>

      {unit && (
        <ExerciseFormDialog
          open={editExerciseOpen}
          onOpenChange={setEditExerciseOpen}
          unitId={unit._id}
          exercise={exercise}
          nextOrderIndex={exercise.orderIndex}
          onSaved={handleExerciseSaved}
        />
      )}

      <QuestionFormDialog
        open={questionFormOpen}
        onOpenChange={setQuestionFormOpen}
        exerciseId={exercise._id}
        question={editingQuestion}
        nextOrderIndex={nextQuestionOrderIndex}
        questionCount={questions.length}
        onSaved={handleQuestionSaved}
        languageOptions={questionLanguageOptions}
      />

      <QuestionPreviewDialog
        questions={questions}
        questionId={previewQuestionId}
        onQuestionIdChange={setPreviewQuestionId}
        onEdit={openEditQuestionDialog}
      />

      <AlertDialog
        open={deleteExerciseOpen}
        onOpenChange={setDeleteExerciseOpen}
      >
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>Delete exercise?</AlertDialogTitle>
            <AlertDialogDescription>
              This will permanently delete "{exercise.name}". This cannot be
              undone.
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel disabled={deletingExercise}>
              Cancel
            </AlertDialogCancel>
            <AlertDialogAction
              disabled={deletingExercise}
              onClick={handleConfirmDeleteExercise}
            >
              {deletingExercise ? "Deleting..." : "Delete"}
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>

      <AlertDialog
        open={deleteQuestionTarget !== null}
        onOpenChange={(open) => {
          if (!open) setDeleteQuestionTarget(null);
        }}
      >
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>Delete question?</AlertDialogTitle>
            <AlertDialogDescription>
              This will permanently delete this question. This cannot be
              undone.
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel disabled={deletingQuestion}>
              Cancel
            </AlertDialogCancel>
            <AlertDialogAction
              disabled={deletingQuestion}
              onClick={handleConfirmDeleteQuestion}
            >
              {deletingQuestion ? "Deleting..." : "Delete"}
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </div>
  );
}

function ExerciseDetailSkeleton() {
  return (
    <div className="flex animate-pulse flex-col gap-8 motion-reduce:animate-none" aria-busy="true">
      <span className="sr-only">Loading exercise…</span>
      <div className="flex flex-col gap-3">
        <div className="h-3.5 w-28 rounded bg-slate-200" />
        <div className="h-6 w-64 rounded bg-slate-200" />
      </div>
      <div className="flex flex-col gap-3">
        <div className="h-5 w-24 rounded bg-slate-200" />
        <div className="overflow-hidden rounded-lg border border-slate-200 bg-white">
          {[0, 1, 2].map((i) => (
            <div key={i} className="flex items-center gap-3 border-b border-slate-200 p-3 last:border-b-0">
              <div className="h-8 w-10 rounded bg-slate-100" />
              <div className="flex flex-1 flex-col gap-1.5">
                <div className="h-3.5 w-1/2 rounded bg-slate-200" />
                <div className="h-3 w-1/4 rounded bg-slate-100" />
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}
