import { Outlet, useNavigate } from "react-router-dom";
import { Button } from "@/components/ui/button";
import { useAuth } from "@/context/AuthContext";

/** Sits between ProtectedRoute and AppShell in the route tree, gating the
 * entire authenticated app to teacher/admin roles. ProtectedRoute already
 * handles the loading/redirect-to-login cases above this — the one case it
 * still lets through with a null user is an unreachable-backend connection
 * error (a token is present but /me couldn't be verified); there's no role
 * to gate on yet in that case, so let it pass through and leave the page's
 * own fetch to surface the connection error, same as everywhere else. */
export default function RequireTeacherRole() {
  const { user, logout } = useAuth();
  const navigate = useNavigate();

  function handleLogout() {
    logout();
    navigate("/login");
  }

  if (!user) {
    return <Outlet />;
  }

  if (user.role !== "teacher" && user.role !== "admin") {
    return (
      <div className="flex min-h-screen flex-col items-center justify-center gap-4 text-center">
        <p className="text-slate-600">This dashboard is for teachers only.</p>
        <Button variant="outline" onClick={handleLogout}>
          Logout
        </Button>
      </div>
    );
  }

  return <Outlet />;
}
