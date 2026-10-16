---
type: architecture
scope: cross-cutting
sources: [dsl-backend/src/controllers/auth.controller.ts, dsl-backend/src/controllers/adminUsers.controller.ts, dsl-backend/src/services/userAccount.service.ts, dsl-mobile/lib/core/auth/auth_controller.dart, dsl-mobile/lib/core/router/auth_redirect.dart, dsl-backend/src/middleware/auth.middleware.ts, dsl-backend/src/middleware/role.middleware.ts, dsl-backend/src/models/User.ts, dsl-backend/src/types/express.d.ts, dsl-teacher-dashboard/src/context/AuthContext.tsx, dsl-teacher-dashboard/src/components/ProtectedRoute.tsx, dsl-teacher-dashboard/src/components/RequireTeacherRole.tsx, dsl-teacher-dashboard/src/lib/api.ts]
updated: 2026-10-16
---
# Auth and roles (end to end)

## 1. Issuing (backend)
- `POST /api/auth/register` `{email, password, firstName, lastName, acceptedTerms?}` → **201** `{data:{token, user}}` with **`role: "student"`** (a `role` in the body is ignored). Password 8–128 characters, email format checked, both names required (400 `VALIDATION_ERROR`). `acceptedTerms: true` sets `termsAcceptedAt`. Passwords are hashed with bcrypt (cost 12) in `userAccount.service.ts`. The email is lowercased. An existing email gives 409 `EMAIL_IN_USE`.
- **Admin only** (`/api/admin/users`, `requireRole("admin")`): list users (`?role=`), create a teacher or admin, and reset any user's password (`PATCH /:id/password`; there's no email provider, so this is account recovery). The first admin comes from `npm run create-admin` ([[user]]).
- `POST /api/auth/login` `{email, password}` → 200 `{data:{token, user}}`. Bad credentials give 401 `INVALID_CREDENTIALS`.
- Token: `jwt.sign({ userId, role }, JWT_SECRET, { expiresIn: "7d" })` (`auth.controller.ts`). There are no refresh tokens.
- The `user` JSON never includes `passwordHash` or `__v` (the `toJSON` transform in `User.ts`).

> [!note] Registration creates students only (since 2026-10-16)
> Before, `User.role` defaulted to `"teacher"`, so anyone who registered could write content. Existing accounts kept their stored role.

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
- Route guards: `ProtectedRoute` (no user → `/login`) → `RequireTeacherRole` (role not teacher/admin → "teachers only" screen with Logout) → `AppShell`; the Users page adds `RequireAdminRole` (teacher → `/`). See [[routing-and-pages]].
- Logout only clears localStorage and state; nothing is sent to the server.

Why localStorage: [[adr-jwt-in-localstorage]]. Not built yet: Google Sign-In (see [[roadmap]]).

## 4. Storing and sending (mobile)
- The JWT is in `flutter_secure_storage` (`dsl-mobile/lib/core/storage/token_storage.dart`); `AuthInterceptor` attaches it.
- `AuthController` (`lib/core/auth/auth_controller.dart`) states: restoring → signed out / signed in / **unverified**. On launch: no token → signed out; `GET /auth/me` OK → signed in; 401 → token cleared, signed out with "Your session has ended"; network/timeout/5xx → unverified, **token kept**, a retry screen with Log out.
- Unlike the dashboard, **a 401 on any later call also signs out** (the interceptor clears the token and the router goes to Sign In). A 401 on a request sent without a token (wrong password) doesn't.
- One go_router `redirect` (`lib/core/router/auth_redirect.dart`): signed out → Welcome; teacher/admin → "This app is for students" with Log out; student → Home. Logout clears the token only; nothing is sent to the server.

Related: [[api-contract]], [[user]], [[error-codes]]. Back to [[architecture-index]].
