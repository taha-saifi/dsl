import {
  createContext,
  useContext,
  useEffect,
  useState,
  type ReactNode,
} from "react";
import { ApiError, apiRequest } from "@/lib/api";
import type { User } from "@/types";

const TOKEN_KEY = "dsl_token";

interface LoginResponse {
  token: string;
  user: User;
}

interface AuthContextValue {
  token: string | null;
  user: User | null;
  loading: boolean;
  /** True when the initial /me check failed to reach the server at all (as opposed to a real 401). */
  connectionError: boolean;
  login: (email: string, password: string) => Promise<void>;
  logout: () => void;
}

const AuthContext = createContext<AuthContextValue | undefined>(undefined);

export function AuthProvider({ children }: { children: ReactNode }) {
  const [token, setToken] = useState<string | null>(null);
  const [user, setUser] = useState<User | null>(null);
  const [loading, setLoading] = useState(true);
  const [connectionError, setConnectionError] = useState(false);

  useEffect(() => {
    const storedToken = localStorage.getItem(TOKEN_KEY);
    if (!storedToken) {
      setLoading(false);
      return;
    }

    setToken(storedToken);
    apiRequest<User>("/auth/me")
      .then((currentUser) => {
        setUser(currentUser);
      })
      .catch((err) => {
        // A real 401 means the token is invalid/expired — clear it. Any other
        // failure (e.g. the server being unreachable) shouldn't sign the user
        // out; keep the token and let protected pages surface their own errors.
        if (err instanceof ApiError && err.status === 401) {
          localStorage.removeItem(TOKEN_KEY);
          setToken(null);
          setUser(null);
        } else {
          setConnectionError(true);
        }
      })
      .finally(() => {
        setLoading(false);
      });
  }, []);

  async function login(email: string, password: string) {
    const { token: newToken, user: newUser } = await apiRequest<LoginResponse>(
      "/auth/login",
      {
        method: "POST",
        body: JSON.stringify({ email, password }),
      },
    );
    localStorage.setItem(TOKEN_KEY, newToken);
    setToken(newToken);
    setUser(newUser);
  }

  function logout() {
    localStorage.removeItem(TOKEN_KEY);
    setToken(null);
    setUser(null);
  }

  return (
    <AuthContext.Provider
      value={{ token, user, loading, connectionError, login, logout }}
    >
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  const context = useContext(AuthContext);
  if (!context) {
    throw new Error("useAuth must be used within an AuthProvider");
  }
  return context;
}
