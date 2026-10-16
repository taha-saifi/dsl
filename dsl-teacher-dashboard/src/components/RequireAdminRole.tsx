import { Navigate, Outlet } from "react-router-dom";
import { useAuth } from "@/context/AuthContext";

/** Admin-only pages (Users). Teachers who open the URL go back to the
 * dashboard; the backend still enforces the role (403 FORBIDDEN_ROLE). */
export default function RequireAdminRole() {
  const { user } = useAuth();

  if (user?.role !== "admin") {
    return <Navigate to="/" replace />;
  }

  return <Outlet />;
}
