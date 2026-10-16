import type { ReactNode } from "react";
import { BrowserRouter, Navigate, Route, Routes } from "react-router-dom";
import AppShell from "@/components/layout/AppShell";
import ProtectedRoute from "@/components/ProtectedRoute";
import RequireAdminRole from "@/components/RequireAdminRole";
import RequireTeacherRole from "@/components/RequireTeacherRole";
import { Toaster } from "@/components/ui/toast";
import { AuthProvider, useAuth } from "@/context/AuthContext";
import CoursesPage from "@/pages/CoursesPage";
import DashboardHomePage from "@/pages/DashboardHomePage";
import ExerciseDetailPage from "@/pages/ExerciseDetailPage";
import LearningItemDetailPage from "@/pages/LearningItemDetailPage";
import LearningItemsPage from "@/pages/LearningItemsPage";
import LoginPage from "@/pages/LoginPage";
import SpecializationsPage from "@/pages/SpecializationsPage";
import UnitDetailPage from "@/pages/UnitDetailPage";
import UnitsPage from "@/pages/UnitsPage";
import UsersPage from "@/pages/UsersPage";

function RedirectIfAuthenticated({ children }: { children: ReactNode }) {
  const { user, loading } = useAuth();

  if (loading) {
    return (
      <div className="flex min-h-screen items-center justify-center text-slate-500">
        Loading...
      </div>
    );
  }

  if (user) {
    return <Navigate to="/" replace />;
  }

  return <>{children}</>;
}

function App() {
  return (
    <BrowserRouter>
      <AuthProvider>
        <Toaster />
        <Routes>
          <Route
            path="/login"
            element={
              <RedirectIfAuthenticated>
                <LoginPage />
              </RedirectIfAuthenticated>
            }
          />
          <Route element={<ProtectedRoute />}>
            <Route element={<RequireTeacherRole />}>
              <Route element={<AppShell />}>
                <Route index element={<DashboardHomePage />} />
                <Route path="/specializations" element={<SpecializationsPage />} />
                <Route
                  path="/specializations/:specializationId/courses"
                  element={<CoursesPage />}
                />
                <Route path="/courses/:courseId/units" element={<UnitsPage />} />
                <Route path="/units/:unitId" element={<UnitDetailPage />} />
                <Route path="/learning-items" element={<LearningItemsPage />} />
                <Route
                  path="/learning-items/:learningItemId"
                  element={<LearningItemDetailPage />}
                />
                <Route
                  path="/exercises/:exerciseId"
                  element={<ExerciseDetailPage />}
                />
                <Route element={<RequireAdminRole />}>
                  <Route path="/users" element={<UsersPage />} />
                </Route>
              </Route>
            </Route>
          </Route>
        </Routes>
      </AuthProvider>
    </BrowserRouter>
  );
}

export default App;
