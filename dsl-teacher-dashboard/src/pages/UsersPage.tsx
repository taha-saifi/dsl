import { useEffect, useState } from "react";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import ResetPasswordDialog from "@/components/users/ResetPasswordDialog";
import StaffUserFormDialog from "@/components/users/StaffUserFormDialog";
import { listUsers } from "@/lib/resources/adminUsers";
import type { User, UserRole } from "@/types";

type Status = "loading" | "error" | "ready";
type RoleFilter = "staff" | "student" | "all";

const FILTERS: Record<RoleFilter, { label: string; roles?: UserRole[] }> = {
  staff: { label: "Teachers and admins", roles: ["teacher", "admin"] },
  student: { label: "Students", roles: ["student"] },
  all: { label: "Everyone" },
};

const ROLE_BADGE: Record<UserRole, "default" | "secondary" | "outline"> = {
  admin: "default",
  teacher: "secondary",
  student: "outline",
};

/** Admin only: the route sits behind RequireAdminRole. */
export default function UsersPage() {
  const [users, setUsers] = useState<User[]>([]);
  const [status, setStatus] = useState<Status>("loading");
  const [errorMessage, setErrorMessage] = useState<string | null>(null);
  const [filter, setFilter] = useState<RoleFilter>("staff");
  const [formOpen, setFormOpen] = useState(false);
  const [resetTarget, setResetTarget] = useState<User | null>(null);

  function fetchUsers(nextFilter: RoleFilter = filter) {
    setStatus("loading");
    setErrorMessage(null);
    listUsers(FILTERS[nextFilter].roles)
      .then((data) => {
        setUsers(data);
        setStatus("ready");
      })
      .catch((err) => {
        setErrorMessage(err instanceof Error ? err.message : "Request failed");
        setStatus("error");
      });
  }

  useEffect(() => {
    fetchUsers(filter);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [filter]);

  function handleCreated(created: User) {
    const roles = FILTERS[filter].roles;
    if (!roles || roles.includes(created.role)) {
      setUsers((prev) => [created, ...prev]);
    }
  }

  return (
    <div>
      <div className="mb-4 flex items-center justify-between gap-4">
        <h1 className="text-xl font-semibold text-slate-900">Users</h1>
        <div className="flex items-center gap-3">
          <Select
            value={filter}
            onValueChange={(next) => {
              if (next === "staff" || next === "student" || next === "all") {
                setFilter(next);
              }
            }}
          >
            <SelectTrigger className="w-52" aria-label="Show">
              <SelectValue>
                {(value: RoleFilter) => FILTERS[value].label}
              </SelectValue>
            </SelectTrigger>
            <SelectContent>
              {(Object.keys(FILTERS) as RoleFilter[]).map((key) => (
                <SelectItem key={key} value={key}>
                  {FILTERS[key].label}
                </SelectItem>
              ))}
            </SelectContent>
          </Select>
          <Button onClick={() => setFormOpen(true)}>Add User</Button>
        </div>
      </div>

      <p className="mb-4 text-sm text-slate-500">
        Add teachers and admins here. Students create their own accounts in
        the mobile app.
      </p>

      {status === "loading" && (
        <p className="text-sm text-slate-500">Loading users...</p>
      )}

      {status === "error" && (
        <div className="rounded-md border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-600">
          Failed to load users: {errorMessage}
          <Button
            variant="outline"
            size="sm"
            className="ml-3"
            onClick={() => fetchUsers()}
          >
            Retry
          </Button>
        </div>
      )}

      {status === "ready" && users.length === 0 && (
        <p className="text-sm text-slate-500">No users match this filter.</p>
      )}

      {status === "ready" && users.length > 0 && (
        <Table>
          <TableHeader>
            <TableRow>
              <TableHead>Name</TableHead>
              <TableHead>Email</TableHead>
              <TableHead>Role</TableHead>
              <TableHead>Joined</TableHead>
              <TableHead className="text-right">Actions</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {users.map((user) => (
              <TableRow key={user._id}>
                <TableCell className="font-medium text-slate-900">
                  {[user.firstName, user.lastName].filter(Boolean).join(" ") ||
                    "—"}
                </TableCell>
                <TableCell className="text-slate-600">{user.email}</TableCell>
                <TableCell>
                  <Badge variant={ROLE_BADGE[user.role]} className="capitalize">
                    {user.role}
                  </Badge>
                </TableCell>
                <TableCell className="text-slate-500">
                  {user.createdAt
                    ? new Date(user.createdAt).toLocaleDateString()
                    : "—"}
                </TableCell>
                <TableCell className="text-right">
                  <Button
                    variant="outline"
                    size="sm"
                    onClick={() => setResetTarget(user)}
                  >
                    Reset Password
                  </Button>
                </TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      )}

      <StaffUserFormDialog
        open={formOpen}
        onOpenChange={setFormOpen}
        onCreated={handleCreated}
      />
      <ResetPasswordDialog
        user={resetTarget}
        onOpenChange={(open) => {
          if (!open) setResetTarget(null);
        }}
      />
    </div>
  );
}
