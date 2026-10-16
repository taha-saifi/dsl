import { useState } from "react";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { toast } from "@/components/ui/toast";

interface PublishToggleProps {
  isPublished: boolean;
  onToggle: () => Promise<void>;
}

/** Publish/unpublish control shared by Course, Unit, and Exercise: a status
 * badge plus a button that requests the flip. The parent alone decides the
 * new isPublished value (by re-rendering this component with it) once the
 * backend genuinely confirms the change — this component never flips its
 * own badge optimistically, since the backend's publish gating can reject
 * the request with a 409 that the teacher needs to see and act on. */
export default function PublishToggle({
  isPublished,
  onToggle,
}: PublishToggleProps) {
  const [loading, setLoading] = useState(false);

  async function handleClick() {
    setLoading(true);
    try {
      await onToggle();
    } catch (err) {
      toast.add({
        type: "error",
        title: isPublished ? "Could not unpublish" : "Could not publish",
        description: err instanceof Error ? err.message : "Request failed",
      });
    } finally {
      setLoading(false);
    }
  }

  return (
    <div className="flex items-center gap-2">
      <Badge
        className={
          isPublished
            ? "bg-emerald-100 text-emerald-700"
            : "bg-slate-100 text-slate-500"
        }
      >
        {isPublished ? "Published" : "Draft"}
      </Badge>
      <Button
        type="button"
        variant="outline"
        size="sm"
        disabled={loading}
        onClick={handleClick}
      >
        {loading
          ? isPublished
            ? "Unpublishing..."
            : "Publishing..."
          : isPublished
            ? "Unpublish"
            : "Publish"}
      </Button>
    </div>
  );
}
