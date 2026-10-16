export class ApiError extends Error {
  status: number;
  /** The backend's machine-readable `error.code`, when it sent one. */
  code: string | undefined;

  constructor(status: number, message: string, code?: string) {
    super(message);
    this.name = "ApiError";
    this.status = status;
    this.code = code;
  }
}

async function handleResponse<T>(res: Response): Promise<T> {
  if (!res.ok) {
    const err = await res.json().catch(() => ({}));
    throw new ApiError(
      res.status,
      err?.error?.message || "Request failed",
      typeof err?.error?.code === "string" ? err.error.code : undefined,
    );
  }
  const json = await res.json();
  return json.data as T;
}

export async function apiRequest<T>(path: string, options: RequestInit = {}): Promise<T> {
  const token = localStorage.getItem("dsl_token");
  let res: Response;
  try {
    res = await fetch(`${import.meta.env.VITE_API_URL}${path}`, {
      ...options,
      headers: {
        "Content-Type": "application/json",
        ...(token ? { Authorization: `Bearer ${token}` } : {}),
        ...options.headers,
      },
    });
  } catch {
    throw new Error("Network error: could not reach the server.");
  }
  return handleResponse<T>(res);
}

/**
 * Like apiRequest, but for multipart/form-data uploads. No Content-Type header
 * is set — the browser needs to add its own multipart boundary automatically.
 */
export async function apiUpload<T>(path: string, formData: FormData): Promise<T> {
  const token = localStorage.getItem("dsl_token");
  let res: Response;
  try {
    res = await fetch(`${import.meta.env.VITE_API_URL}${path}`, {
      method: "POST",
      headers: {
        ...(token ? { Authorization: `Bearer ${token}` } : {}),
      },
      body: formData,
    });
  } catch {
    throw new Error("Network error: could not reach the server.");
  }
  return handleResponse<T>(res);
}
