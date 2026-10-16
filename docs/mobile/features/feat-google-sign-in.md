---
type: feature
scope: cross-cutting
sources: [docs/mobile/figma-screen-inventory.md]
updated: 2026-10-16
---
# Feature: Google sign-in (later)

**Size:** M · **Depends on:** [[feat-student-accounts]] · **Changes [[api-contract]]:** yes

## Goal
Sign in with a Google account.

## Figma screens
[[figma-screen-inventory]]: "Continue with Google" on Login `55:40`.

## Mobile scope
Google button using Android Credential Manager / google_sign_in; it exchanges the ID token with the API.

## Backend changes
- **Additive:** `POST /auth/google` `{idToken}`, verified server-side, finds or creates the student. Designed in `dsl-backend/AGENTS.md`, not built.

## Database changes
`User.googleId?` (sparse unique index); `passwordHash` becomes optional for Google-only users.

## Dashboard changes
None (could be added to the dashboard login too).

## Decisions (2026-10-16)
- Q30 → It stays in "later" while there's no test Google account.

Back to [[00-feature-catalog]].
