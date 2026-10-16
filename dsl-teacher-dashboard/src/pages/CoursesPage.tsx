import { useEffect, useState } from "react";
import { Link, useParams } from "react-router-dom";
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
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import { toast } from "@/components/ui/toast";
import CourseFormDialog from "@/components/courses/CourseFormDialog";
import PublishToggle from "@/components/PublishToggle";
import { ApiError } from "@/lib/api";
import { deleteCourse, listCourses, updateCourse } from "@/lib/resources/courses";
import { getSpecialization } from "@/lib/resources/specializations";
import type { Course, Specialization } from "@/types";

type Status = "loading" | "not-found" | "error" | "ready";

export default function CoursesPage() {
  const { specializationId } = useParams<{ specializationId: string }>();

  const [specialization, setSpecialization] = useState<Specialization | null>(
    null,
  );
  const [courses, setCourses] = useState<Course[]>([]);
  const [status, setStatus] = useState<Status>("loading");
  const [errorMessage, setErrorMessage] = useState<string | null>(null);

  const [formOpen, setFormOpen] = useState(false);
  const [editingCourse, setEditingCourse] = useState<Course | undefined>(
    undefined,
  );

  const [deleteTarget, setDeleteTarget] = useState<Course | null>(null);
  const [deleting, setDeleting] = useState(false);

  function fetchData() {
    if (!specializationId) return;
    setStatus("loading");
    setErrorMessage(null);
    Promise.all([
      getSpecialization(specializationId),
      listCourses({ specializationId }),
    ])
      .then(([specializationData, courseList]) => {
        setSpecialization(specializationData);
        setCourses(courseList);
        setStatus("ready");
      })
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
  }, [specializationId]);

  function openCreateDialog() {
    setEditingCourse(undefined);
    setFormOpen(true);
  }

  function openEditDialog(course: Course) {
    setEditingCourse(course);
    setFormOpen(true);
  }

  function handleSaved(saved: Course) {
    setCourses((prev) => {
      const exists = prev.some((c) => c._id === saved._id);
      if (exists) {
        return prev.map((c) => (c._id === saved._id ? saved : c));
      }
      return [...prev, saved];
    });
  }

  async function handleTogglePublish(course: Course) {
    const updated = await updateCourse(course._id, {
      isPublished: !course.isPublished,
    });
    setCourses((prev) => prev.map((c) => (c._id === updated._id ? updated : c)));
  }

  async function handleConfirmDelete() {
    if (!deleteTarget) return;
    const target = deleteTarget;
    setDeleting(true);
    try {
      await deleteCourse(target._id);
      setCourses((prev) => prev.filter((c) => c._id !== target._id));
    } catch (err) {
      toast.add({
        type: "error",
        title: "Could not delete course",
        description: err instanceof Error ? err.message : "Request failed",
      });
    } finally {
      setDeleting(false);
      setDeleteTarget(null);
    }
  }

  if (status === "loading") {
    return <p className="text-sm text-slate-500">Loading courses...</p>;
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
          Specialization not found.
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
          Failed to load courses: {errorMessage}
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

  return (
    <div>
      <Link
        to="/specializations"
        className="text-sm text-cyan-700 hover:underline"
      >
        ← Back to Specializations
      </Link>

      <div className="mt-2 mb-4 flex items-center justify-between">
        <h1 className="text-xl font-semibold text-slate-900">
          {specialization?.name} — Courses
        </h1>
        <Button onClick={openCreateDialog}>New Course</Button>
      </div>

      {courses.length === 0 && (
        <p className="text-sm text-slate-500">No courses yet.</p>
      )}

      {courses.length > 0 && (
        <Table>
          <TableHeader>
            <TableRow>
              <TableHead>Name</TableHead>
              <TableHead>Languages</TableHead>
              <TableHead>Description</TableHead>
              <TableHead>Status</TableHead>
              <TableHead className="text-right">Actions</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {courses.map((course) => (
              <TableRow key={course._id}>
                <TableCell>
                  <Link
                    to={`/courses/${course._id}/units`}
                    className="font-medium text-cyan-700 hover:underline"
                  >
                    {course.name}
                  </Link>
                </TableCell>
                <TableCell className="text-slate-500">
                  {course.sourceLanguage} → {course.targetLanguage}
                </TableCell>
                <TableCell
                  className="max-w-xs truncate text-slate-500"
                  title={course.description}
                >
                  {course.description || "—"}
                </TableCell>
                <TableCell>
                  <PublishToggle
                    isPublished={course.isPublished}
                    onToggle={() => handleTogglePublish(course)}
                  />
                </TableCell>
                <TableCell className="text-right">
                  <Button
                    variant="outline"
                    size="sm"
                    className="mr-2"
                    onClick={() => openEditDialog(course)}
                  >
                    Edit
                  </Button>
                  <Button
                    variant="destructive"
                    size="sm"
                    onClick={() => setDeleteTarget(course)}
                  >
                    Delete
                  </Button>
                </TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      )}

      {specializationId && (
        <CourseFormDialog
          open={formOpen}
          onOpenChange={setFormOpen}
          specializationId={specializationId}
          course={editingCourse}
          onSaved={handleSaved}
        />
      )}

      <AlertDialog
        open={deleteTarget !== null}
        onOpenChange={(open) => {
          if (!open) setDeleteTarget(null);
        }}
      >
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>Delete course?</AlertDialogTitle>
            <AlertDialogDescription>
              This will permanently delete "{deleteTarget?.name}". This
              cannot be undone.
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel disabled={deleting}>Cancel</AlertDialogCancel>
            <AlertDialogAction
              disabled={deleting}
              onClick={handleConfirmDelete}
            >
              {deleting ? "Deleting..." : "Delete"}
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </div>
  );
}
