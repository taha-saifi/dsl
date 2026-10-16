import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import { Button } from "@/components/ui/button";
import { useAuth } from "@/context/AuthContext";
import { listCourses } from "@/lib/resources/courses";
import { listExercises } from "@/lib/resources/exercises";
import { listSpecializations } from "@/lib/resources/specializations";
import { listUnits } from "@/lib/resources/units";
import type { Course, Exercise, Specialization, Unit } from "@/types";

type Status = "loading" | "error" | "ready";

export default function DashboardHomePage() {
  const { user } = useAuth();
  const navigate = useNavigate();

  const [specializations, setSpecializations] = useState<Specialization[]>([]);
  const [courses, setCourses] = useState<Course[]>([]);
  const [units, setUnits] = useState<Unit[]>([]);
  const [exercises, setExercises] = useState<Exercise[]>([]);
  const [status, setStatus] = useState<Status>("loading");
  const [errorMessage, setErrorMessage] = useState<string | null>(null);

  function fetchData() {
    setStatus("loading");
    setErrorMessage(null);
    Promise.all([listSpecializations(), listCourses(), listUnits(), listExercises()])
      .then(([specializationList, courseList, unitList, exerciseList]) => {
        setSpecializations(specializationList);
        setCourses(courseList);
        setUnits(unitList);
        setExercises(exerciseList);
        setStatus("ready");
      })
      .catch((err) => {
        setErrorMessage(err instanceof Error ? err.message : "Request failed");
        setStatus("error");
      });
  }

  useEffect(() => {
    fetchData();
  }, []);

  if (status === "loading") {
    return <p className="text-sm text-slate-500">Loading dashboard...</p>;
  }

  if (status === "error") {
    return (
      <div className="rounded-md border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-600">
        Failed to load dashboard: {errorMessage}
        <Button
          variant="outline"
          size="sm"
          className="ml-3"
          onClick={fetchData}
        >
          Retry
        </Button>
      </div>
    );
  }

  if (specializations.length === 0) {
    return (
      <div className="flex flex-col items-center justify-center gap-4 py-24 text-center">
        <p className="text-lg text-slate-600">
          Get started by creating your first specialization.
        </p>
        <Button onClick={() => navigate("/specializations")}>
          Go to Specializations
        </Button>
      </div>
    );
  }

  const publishedCourses = courses.filter((c) => c.isPublished).length;
  const publishedUnits = units.filter((u) => u.isPublished).length;
  const publishedExercises = exercises.filter((e) => e.isPublished).length;

  return (
    <div>
      <h1 className="text-xl font-semibold text-slate-900">
        Welcome, {user?.firstName}
      </h1>

      <div className="mt-6 grid grid-cols-2 gap-4 sm:grid-cols-4">
        <StatCard label="Specializations" total={specializations.length} />
        <StatCard
          label="Courses"
          total={courses.length}
          publishedCount={publishedCourses}
        />
        <StatCard
          label="Units"
          total={units.length}
          publishedCount={publishedUnits}
        />
        <StatCard
          label="Exercises"
          total={exercises.length}
          publishedCount={publishedExercises}
        />
      </div>
    </div>
  );
}

interface StatCardProps {
  label: string;
  total: number;
  publishedCount?: number;
}

function StatCard({ label, total, publishedCount }: StatCardProps) {
  return (
    <div className="rounded-md border border-slate-200 bg-white p-4">
      <p className="text-sm text-slate-500">{label}</p>
      <p className="mt-1 text-2xl font-semibold text-slate-900">{total}</p>
      {Boolean(publishedCount) && (
        <p className="mt-1 text-xs text-emerald-600">
          {publishedCount} published
        </p>
      )}
    </div>
  );
}
