import { Navigate, Outlet } from "react-router-dom";
import { useAuth } from "@/context/AuthContext";

export default function ProtectedRoute() {
  const { user, loading, token, connectionError } = useAuth();

  if (loading) {
    return (
      <div className="flex min-h-screen items-center justify-center text-slate-500">
        Loading...
      </div>
    );
  }

  // We couldn't verify the token because the server was unreachable, but we
  // still have one — render the app optimistically rather than forcing a
  // logout, and let the page's own data fetch surface the connection error.
  if (!user && token && connectionError) {
    return <Outlet />;
  }

  if (!user) {
    return <Navigate to="/login" replace />;
  }

  return <Outlet />;
}
