import type { ReactNode } from "react";
import { BrowserRouter, Navigate, Route, Routes } from "react-router-dom";
import AppShell from "@/components/layout/AppShell";
import PlaceholderPage from "@/components/PlaceholderPage";
import ProtectedRoute from "@/components/ProtectedRoute";
import { Toaster } from "@/components/ui/toast";
import { AuthProvider, useAuth } from "@/context/AuthContext";
import LoginPage from "@/pages/LoginPage";
import SpecializationsPage from "@/pages/SpecializationsPage";

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
            <Route element={<AppShell />}>
              <Route index element={<PlaceholderPage title="Dashboard" />} />
              <Route path="/specializations" element={<SpecializationsPage />} />
              <Route
                path="/specializations/:specializationId/courses"
                element={<PlaceholderPage title="Courses" />}
              />
              <Route
                path="/courses/:courseId/units"
                element={<PlaceholderPage title="Units" />}
              />
              <Route
                path="/units/:unitId"
                element={<PlaceholderPage title="Unit Detail" />}
              />
              <Route
                path="/learning-items"
                element={<PlaceholderPage title="Learning Items" />}
              />
              <Route
                path="/learning-items/:learningItemId"
                element={<PlaceholderPage title="Learning Item Detail" />}
              />
              <Route
                path="/exercises/:exerciseId"
                element={<PlaceholderPage title="Exercise Detail" />}
              />
            </Route>
          </Route>
        </Routes>
      </AuthProvider>
    </BrowserRouter>
  );
}

export default App;
