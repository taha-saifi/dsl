---
type: model
scope: backend
sources: [dsl-backend/src/models/User.ts, dsl-backend/src/scripts/createAdmin.ts]
updated: 2026-10-16
---
# User

`dsl-backend/src/models/User.ts`

| Field | Type | Notes |
|---|---|---|
| `email` | string | required, unique, lowercase, trimmed |
| `passwordHash` | string | required, `select: false`, removed from JSON |
| `role` | `"admin" \| "teacher" \| "student"` (`USER_ROLES`) | default `"student"` |
| `firstName`, `lastName` | string? | optional in the model, trimmed; required by register and `POST /admin/users` |
| `termsAcceptedAt` | Date? | set by register when the body sends `acceptedTerms: true` |
| `createdAt`, `updatedAt` | Date | |

The `toJSON` transform removes `passwordHash` and `__v`.

How each role is created ([[auth-and-roles]]):
- **student:** `POST /auth/register` (the mobile app's Sign Up).
- **teacher / admin:** an admin, with `POST /admin/users` (dashboard Users page).
- **first admin:** `npm run create-admin -- --email … --password … --first-name … --last-name …` in `dsl-backend/` (or `node dist/scripts/createAdmin.js …` in the container). For an existing email it promotes the account to admin and only changes the password if `--password` is given.

The default changed from `"teacher"` to `"student"` on 2026-10-16. Mongoose defaults apply on insert only, so **existing users kept their stored role**; no migration was needed.

Back to [[data-model-index]].
