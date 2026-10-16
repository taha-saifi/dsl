---
type: architecture
scope: cross-cutting
sources: [dsl-backend/src/controllers/auth.controller.ts, dsl-backend/src/middleware/auth.middleware.ts, dsl-backend/src/middleware/role.middleware.ts, dsl-backend/src/models/User.ts, dsl-backend/src/types/express.d.ts, dsl-teacher-dashboard/src/context/AuthContext.tsx, dsl-teacher-dashboard/src/components/ProtectedRoute.tsx, dsl-teacher-dashboard/src/components/RequireTeacherRole.tsx, dsl-teacher-dashboard/src/lib/api.ts]
updated: 2026-10-16
---
# Auth and roles (end to end)

## 1. Issuing (backend)
- `POST /api/auth/register` `{email, password, firstName?, lastName?}` → **201** `{data:{token, user}}`. Passwords are hashed with bcrypt (cost 12). The email is lowercased. An existing email gives 409 `EMAIL_IN_USE`.
- `POST /api/auth/login` `{email, password}` → 200 `{data:{token, user}}`. Bad credentials give 401 `INVALID_CREDENTIALS`.
- Token: `jwt.sign({ userId, role }, JWT_SECRET, { expiresIn: "7d" })` (`auth.controller.ts`). There are no refresh tokens.
- The `user` JSON never includes `passwordHash` or `__v` (the `toJSON` transform in `User.ts`).

> [!warning] Registration is open and the role defaults to `"teacher"`
> `User.role` defaults to `"teacher"` and register accepts no role field, so **anyone who calls register gets write access to all content**. No endpoint creates students or admins. See [[known-mismatches]].

## 2. Verifying (backend)
- `authenticate` (`auth.middleware.ts`) reads `Authorization: Bearer <token>`, verifies it, **loads the user from the database on every request**, and sets `req.user` (a hydrated `IUser`). Any failure gives 401 `UNAUTHORIZED`. Since the role comes from the database rather than the token claim, a role change takes effect immediately.
- `requireRole(...roles)` (`role.middleware.ts`) gives 403 `FORBIDDEN_ROLE` when `req.user.role` isn't in the list.
- **Policy:** every router except health/auth calls `router.use(authenticate)`, so every GET works for any logged-in role. Every POST/PATCH/DELETE (including reorder/attach/detach) adds `requireRole("teacher","admin")`.
- `GET /api/auth/me` → `{data: user}`. Note: this is the user object itself, not `{user}`.

## 3. Storing and sending (dashboard)
- `AuthContext.login` → `POST /auth/login` → `localStorage["dsl_token"]` = token, user kept in state.
- On load: if a token exists, call `GET /auth/me`.
  - A 401 removes the token (user is logged out).
  - Any other failure (e.g. a network error) sets `connectionError`, **keeps** the token, and lets pages show their own fetch errors.
- `apiRequest` / `apiUpload` attach `Authorization: Bearer` from localStorage on every call ([[api-client]]).
- A 401 on any later call does **not** log the user out; it only shows up as an error message.
- Route guards: `ProtectedRoute` (no user → `/login`) → `RequireTeacherRole` (role not teacher/admin → "teachers only" screen with Logout) → `AppShell`. See [[routing-and-pages]].
- Logout only clears localStorage and state; nothing is sent to the server.

Why localStorage: [[adr-jwt-in-localstorage]]. Not built yet: Google Sign-In (see [[roadmap]]).

Related: [[api-contract]], [[user]], [[error-codes]]. Back to [[architecture-index]].
