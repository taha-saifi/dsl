import { useEffect, useState } from "react";
import { Button } from "@/components/ui/button";
import { apiRequest } from "@/lib/api";

type ConnectionStatus = "checking" | "connected" | "disconnected";

function App() {
  const [status, setStatus] = useState<ConnectionStatus>("checking");

  useEffect(() => {
    let cancelled = false;

    apiRequest<{ status: string }>("/health")
      .then(() => {
        if (!cancelled) setStatus("connected");
      })
      .catch(() => {
        if (!cancelled) setStatus("disconnected");
      });

    return () => {
      cancelled = true;
    };
  }, []);

  return (
    <div className="flex min-h-screen flex-col items-center justify-center gap-4 bg-slate-50">
      <h1 className="text-2xl font-semibold text-slate-900">
        DSL Teacher Dashboard
      </h1>
      <p
        className={
          status === "connected"
            ? "font-medium text-emerald-600"
            : status === "disconnected"
              ? "font-medium text-red-600"
              : "font-medium text-slate-500"
        }
      >
        {status === "checking"
          ? "Checking connection..."
          : status === "connected"
            ? "Connected"
            : "Not connected"}
      </p>
      <Button>Sample Button</Button>
    </div>
  );
}

export default App;
