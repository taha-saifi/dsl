---
type: component
scope: dashboard
sources: [dsl-teacher-dashboard/src/lib/api.ts, dsl-teacher-dashboard/src/lib/resources/specializations.ts, dsl-teacher-dashboard/src/lib/resources/courses.ts, dsl-teacher-dashboard/src/lib/resources/units.ts, dsl-teacher-dashboard/src/lib/resources/media.ts, dsl-teacher-dashboard/src/lib/resources/learningItems.ts, dsl-teacher-dashboard/src/lib/resources/exercises.ts, dsl-teacher-dashboard/src/lib/resources/questions.ts, dsl-teacher-dashboard/src/types/index.ts]
updated: 2026-10-16
---
# API client

## `dsl-teacher-dashboard/src/lib/api.ts`
- `apiRequest<T>(path, options)`: `fetch(VITE_API_URL + path)` with `Content-Type: application/json` and `Authorization: Bearer <localStorage.dsl_token>`. Returns `json.data as T` (the envelope is unwrapped).
- `apiUpload<T>(path, formData)`: a POST with **no** Content-Type, so the browser sets the multipart boundary itself.
- Errors:
  - Network failure → plain `Error("Network error: could not reach the server.")`.
  - Non-2xx → `ApiError(status, error.message || "Request failed", error.code)`. Branch on `err.code` (e.g. `INVALID_QUESTION_TEXT` in the question form). Only `AuthContext` logs out, and only on a 401 from `/auth/me`.
- Package rule: every network call goes through this file. No raw `fetch` in components.

## Resource modules (`src/lib/resources/`)
One module per backend router. Each wraps `apiRequest` with typed inputs:

| Module | Functions |
|---|---|
| `specializations.ts` | list, get, create, update (`{name, iconUrl?}`), delete |
| `courses.ts` | list (`specializationId?`), get, create, update, delete |
| `units.ts` | list (`courseId?`), get, create, update, delete, `reorderUnits(courseId, units)`, `attachLearningItem`, `detachLearningItem`, `reorderUnitLearningItems` |
| `media.ts` | `listMedia({type})`, `getMedia`, `uploadMedia(file)` (no delete) |
| `learningItems.ts` | list (`type?`, `search?`), get, create, update, delete, add/update/remove translation |
| `exercises.ts` | list (`unitId?`), get, create, update, delete, `reorderExercises` |
| `questions.ts` | list (`exerciseId`), get, create, update (no `type`; `questionText: null` clears), delete, `reorderQuestions`, `getQuestionTextDefaults` (memoized per page load) |

## Gaps compared with the backend
- Input types leave out fields the backend accepts: `slug`, `thumbnailMediaId`, `orderIndex` on update, moving a resource to a new parent.
- Optional fields are sent as `undefined`, which `JSON.stringify` drops, so they **can't be cleared** ([[known-mismatches]]).
- The types in `src/types/index.ts` are hand copies of the backend models. The contract is in [[api-contract]].

Back to [[dashboard-index]].
