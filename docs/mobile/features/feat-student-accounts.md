---
type: feature
scope: cross-cutting
sources: [dsl-backend/src/controllers/auth.controller.ts, dsl-backend/src/models/User.ts]
updated: 2026-10-16
---
# Feature: student accounts and sign-in (MVP)

**Size:** M · **Depends on:** Slice 0 (scaffold) · **Changes [[api-contract]]:** yes

## Goal
A student creates an account, signs in, stays signed in, and signs out.

## Figma screens
[[figma-screen-inventory]]: Splash `55:5`, Login `55:40`, Sign Up `55:68`. The Google button and "Forgot Password?" are hidden in the MVP ([[feat-google-sign-in]], [[feat-password-reset]]).

## Mobile scope
- Splash → Login or Sign Up. Sign Up collects first name, last name, email, password, confirm password and terms; the confirm field and terms box are client-side only.
- On success: store the JWT in secure storage, then go to Home. On launch, read the token and call `GET /auth/me`.
- Error model as in the dashboard: only a real 401 clears the token; network errors keep it ([[auth-and-roles]]).
- A teacher or admin who logs into the app sees a "students only" screen. This mirrors the dashboard's `RequireTeacherRole`.

## Backend changes
- **Breaking (behavior):** `POST /auth/register` creates **students**. `User.role` default becomes `"student"`. This fixed the old known mismatch "anyone who registers becomes a teacher".
  - The dashboard has no register page, so nothing there breaks.
  - Teachers and admins need another way in (see questions).
- **Additive:** password validation, minimum 8 characters (the Figma helper text), as 400 `VALIDATION_ERROR`.
- **Additive, admin only** (`requireRole("admin")`):
  - `POST /admin/users` `{email, password, firstName, lastName, role: "teacher"|"admin"}` → 201 `User`.
  - `GET /admin/users?role=`.
  - `PATCH /admin/users/:id/password` `{password}` (admin-set reset; no email provider yet).
- **Additive:** optional `termsAcceptedAt`, set when the body sends `acceptedTerms: true`.

## Database changes
- `users.role` default changes. **Existing users keep their stored role**: Mongoose defaults only apply on insert, so no migration is needed.
- New optional `termsAcceptedAt: Date`.

## Dashboard changes
- Admin-only **Users** page: list teachers and admins, add a teacher, reset a password. It's hidden for teachers.
- `RequireTeacherRole` already blocks students.

## Built (2026-10-16)
Slice 1 shipped as described above, with these details settled while building:
- Register **requires** `firstName` and `lastName` and checks the email format; a `role` in the body is ignored.
- `GET /admin/users?role=` takes a comma list (`teacher,admin`); omitted = every role. Admins can reset any user's password, students included.
- First admin: `npm run create-admin` in `dsl-backend/` ([[user]]).
- App: a 401 on any call with a token signs the student out to Sign In ("Your session has ended"); offline at launch shows a retry screen and keeps the token ([[auth-and-roles]]). The "Step 1 of 4" bar from Figma waits for onboarding (Slice 2).

## Decisions (2026-10-16)
- Q1 → **An admin-only endpoint lets an admin add teachers** (and other admins). The first admin comes from a seed script.
- Q2 → **First and last name** stay as two fields (`firstName`, `lastName`). The Sign Up form shows two inputs instead of Figma's single "Full name".
- Q3 → Store `termsAcceptedAt` (proposed default).
- Account recovery (Q31) → **the admin resets passwords**; there's no self-service reset yet.

Back to [[00-feature-catalog]].
