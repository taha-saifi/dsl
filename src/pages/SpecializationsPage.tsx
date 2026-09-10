import { useEffect, useState } from "react";
import { Link } from "react-router-dom";
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
import SpecializationFormDialog from "@/components/specializations/SpecializationFormDialog";
import {
  deleteSpecialization,
  listSpecializations,
} from "@/lib/resources/specializations";
import type { Specialization } from "@/types";

type Status = "loading" | "error" | "ready";

export default function SpecializationsPage() {
  const [specializations, setSpecializations] = useState<Specialization[]>([]);
  const [status, setStatus] = useState<Status>("loading");
  const [errorMessage, setErrorMessage] = useState<string | null>(null);

  const [formOpen, setFormOpen] = useState(false);
  const [editingSpecialization, setEditingSpecialization] = useState<
    Specialization | undefined
  >(undefined);

  const [deleteTarget, setDeleteTarget] = useState<Specialization | null>(
    null,
  );
  const [deleting, setDeleting] = useState(false);

  function fetchSpecializations() {
    setStatus("loading");
    setErrorMessage(null);
    listSpecializations()
      .then((data) => {
        setSpecializations(data);
        setStatus("ready");
      })
      .catch((err) => {
        setErrorMessage(err instanceof Error ? err.message : "Request failed");
        setStatus("error");
      });
  }

  useEffect(() => {
    fetchSpecializations();
  }, []);

  function openCreateDialog() {
    setEditingSpecialization(undefined);
    setFormOpen(true);
  }

  function openEditDialog(specialization: Specialization) {
    setEditingSpecialization(specialization);
    setFormOpen(true);
  }

  function handleSaved(saved: Specialization) {
    setSpecializations((prev) => {
      const exists = prev.some((s) => s._id === saved._id);
      if (exists) {
        return prev.map((s) => (s._id === saved._id ? saved : s));
      }
      return [...prev, saved];
    });
  }

  async function handleConfirmDelete() {
    if (!deleteTarget) return;
    const target = deleteTarget;
    setDeleting(true);
    try {
      await deleteSpecialization(target._id);
      setSpecializations((prev) => prev.filter((s) => s._id !== target._id));
    } catch (err) {
      toast.add({
        type: "error",
        title: "Could not delete specialization",
        description: err instanceof Error ? err.message : "Request failed",
      });
    } finally {
      setDeleting(false);
      setDeleteTarget(null);
    }
  }

  return (
    <div>
      <div className="mb-4 flex items-center justify-between">
        <h1 className="text-xl font-semibold text-slate-900">
          Specializations
        </h1>
        <Button onClick={openCreateDialog}>New Specialization</Button>
      </div>

      {status === "loading" && (
        <p className="text-sm text-slate-500">Loading specializations...</p>
      )}

      {status === "error" && (
        <div className="rounded-md border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-600">
          Failed to load specializations: {errorMessage}
          <Button
            variant="outline"
            size="sm"
            className="ml-3"
            onClick={fetchSpecializations}
          >
            Retry
          </Button>
        </div>
      )}

      {status === "ready" && specializations.length === 0 && (
        <p className="text-sm text-slate-500">No specializations yet.</p>
      )}

      {status === "ready" && specializations.length > 0 && (
        <Table>
          <TableHeader>
            <TableRow>
              <TableHead>Name</TableHead>
              <TableHead>Slug</TableHead>
              <TableHead className="text-right">Actions</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {specializations.map((specialization) => (
              <TableRow key={specialization._id}>
                <TableCell>
                  <Link
                    to={`/specializations/${specialization._id}/courses`}
                    className="font-medium text-cyan-700 hover:underline"
                  >
                    {specialization.name}
                  </Link>
                </TableCell>
                <TableCell className="text-slate-500">
                  {specialization.slug}
                </TableCell>
                <TableCell className="text-right">
                  <Button
                    variant="outline"
                    size="sm"
                    className="mr-2"
                    onClick={() => openEditDialog(specialization)}
                  >
                    Edit
                  </Button>
                  <Button
                    variant="destructive"
                    size="sm"
                    onClick={() => setDeleteTarget(specialization)}
                  >
                    Delete
                  </Button>
                </TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      )}

      <SpecializationFormDialog
        open={formOpen}
        onOpenChange={setFormOpen}
        specialization={editingSpecialization}
        onSaved={handleSaved}
      />

      <AlertDialog
        open={deleteTarget !== null}
        onOpenChange={(open) => {
          if (!open) setDeleteTarget(null);
        }}
      >
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>Delete specialization?</AlertDialogTitle>
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
