---
type: model
scope: backend
sources: [dsl-backend/src/models/Specialization.ts, dsl-backend/src/controllers/specializations.controller.ts]
updated: 2026-10-16
---
# Specialization

`dsl-backend/src/models/Specialization.ts`. A top-level domain, e.g. "Medicine".

| Field | Type | Notes |
|---|---|---|
| `name` | string | required |
| `slug` | string | required, unique, kebab-case (`/^[a-z0-9]+(?:-[a-z0-9]+)*$/`) |
| `iconUrl` | string? | free-text URL, not a Media reference |
| `createdAt` | Date | no `updatedAt` |

- On create, `slug` defaults to `toKebabCase(name)` (accents stripped). A taken slug gives 409 `SLUG_IN_USE`.
- **Renaming doesn't regenerate the slug**; only an explicit `slug` in the PATCH changes it.
- Can't be deleted while it has courses ([[delete-guards]]).

Children: [[course]]. Back to [[data-model-index]].
