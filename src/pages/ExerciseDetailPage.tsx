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
import QuestionFormDialog from "@/components/questions/QuestionFormDialog";
import SortableQuestionRow from "@/components/questions/SortableQuestionRow";
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
    return <p className="text-sm text-slate-500">Loading exercise...</p>;
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

      <div>
        <div className="mb-3 flex items-center justify-between">
          <h2 className="text-lg font-semibold text-slate-900">Questions</h2>
          <Button size="sm" onClick={openCreateQuestionDialog}>
            New Question
          </Button>
        </div>

        {questions.length === 0 && (
          <p className="text-sm text-slate-500">No questions yet.</p>
        )}

        {questions.length > 0 && (
          <DndContext
            sensors={sensors}
            collisionDetection={closestCenter}
            onDragEnd={handleQuestionDragEnd}
          >
            <div className="rounded-md border border-slate-200">
              <SortableContext
                items={questions.map((q) => q._id)}
                strategy={verticalListSortingStrategy}
              >
                {questions.map((question) => (
                  <SortableQuestionRow
                    key={question._id}
                    question={question}
                    onEdit={openEditQuestionDialog}
                    onDelete={setDeleteQuestionTarget}
                  />
                ))}
              </SortableContext>
            </div>
          </DndContext>
        )}
      </div>

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
        onSaved={handleQuestionSaved}
        languageOptions={questionLanguageOptions}
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
