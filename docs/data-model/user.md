---
type: model
scope: backend
sources: [dsl-backend/src/models/User.ts]
updated: 2026-10-16
---
# User

`dsl-backend/src/models/User.ts`

| Field | Type | Notes |
|---|---|---|
| `email` | string | required, unique, lowercase, trimmed |
| `passwordHash` | string | required, `select: false`, removed from JSON |
| `role` | `"admin" \| "teacher" \| "student"` | **default `"teacher"`** |
| `firstName`, `lastName` | string? | optional, trimmed |
| `createdAt`, `updatedAt` | Date | |

The `toJSON` transform removes `passwordHash` and `__v`. Register can't set a role, so no API path creates students or admins today ([[auth-and-roles]]).

> [!todo] Unverified: how were existing admin accounts created? Presumably directly in the database.

Back to [[data-model-index]].
