---
type: contract
scope: cross-cutting
sources: [dsl-backend/src/app.ts, dsl-backend/src/controllers/adminUsers.controller.ts, dsl-backend/src/services/userAccount.service.ts, dsl-backend/src/services/learnerPreferences.service.ts, dsl-backend/src/services/studentCatalog.service.ts, dsl-backend/src/middleware/error.middleware.ts, dsl-backend/src/middleware/auth.middleware.ts, dsl-backend/src/models, dsl-backend/src/controllers, dsl-teacher-dashboard/src/types/index.ts, dsl-teacher-dashboard/src/lib/api.ts, dsl-backend/src/models/Question.ts]
updated: 2026-10-16
---
# API contract

**This note is the source of truth for the API.** The backend implements it, and every client (`dsl-teacher-dashboard/`, future `dsl-mobile/`) consumes it. An API change must update the backend, every affected client, and this note **in the same change**. Endpoint list: [[api-endpoints]]. Errors: [[error-codes]].

## Transport
- Base URL: `<host>/api`. JSON bodies, except `POST /media/upload`, which is multipart with field `file`.
- Auth: `Authorization: Bearer <jwt>` on every route except `/health`, `/auth/register`, `/auth/login`. The token lasts 7 days with no refresh ([[auth-and-roles]]).
- Success: `{ "data": T }`. Error: `{ "error": { "message": string, "code"?: string } }`. Clients branch on `code`.
- Delete success: `200 { "data": { "id": string } }`.
- Create: `201`, except reorder endpoints (200) and translation add / unit attach, which return **201 with the whole parent document**.
- References are **never populated**: ids come back as strings, and clients fetch what they need.

## Entity shapes (as the backend sends them)
Every entity also has `_id: string` and `__v: number` (User has no `__v`). Dates are ISO strings.
```ts
type Role = "admin" | "teacher" | "student";
interface User { email: string; role: Role; firstName?: string; lastName?: string;
  termsAcceptedAt?: string;   // set when register sent acceptedTerms: true
  preferences?: LearningPreferences;   // absent until the student finishes onboarding
  createdAt; updatedAt }
interface LearningPreferences { specializationId?: string; targetLanguage?: string;
  goal?: "professional" | "academic" | "certification" | "daily_practice";
  dailyTargetMinutes?: 5 | 10 | 15 | 20 | 30;
  experienceLevel?: "beginner" | "intermediate" | "advanced" }
// GET /learn/* (student views; only courses with isPublished: true count until slice 3 tightens it)
interface SpecializationSummary { _id: string; name: string; slug: string; iconUrl?: string; publishedCourseCount: number }
interface LanguageSummary { code: string; publishedCourseCount: number }
interface Specialization { name: string; slug: string; iconUrl?: string; createdAt }
interface Course { specializationId: string; thumbnailMediaId?: string; name: string;
  sourceLanguage: string; targetLanguage: string; description?: string; isPublished: boolean; createdAt; updatedAt }
interface Unit { courseId: string; name: string; orderIndex: number; isPublished: boolean;
  learningItems: { learningItemId: string; order: number }[];   // unsorted
  createdAt; updatedAt }
interface Media { uploadedBy: string; type: "image" | "audio" | "video"; url: string; filename: string;
  mimeType: string; sizeBytes: number; storageKey: string; createdAt }
interface Translation { language: string; text: string; pronunciation?: string; ipa?: string; audioMediaId?: string }
interface LearningItem { createdBy: string; imageMediaId: string | null; type: "word" | "phrase" | "sentence";
  translations: Translation[]; createdAt; updatedAt }
interface Exercise { unitId: string; name: string; orderIndex: number; isPublished: boolean; createdAt; updatedAt }
interface QuestionItem { learningItemId: string; role: "target" | "distractor" | "pair"; displayOrder: number }
interface Question { exerciseId: string; type: QuestionType; orderIndex: number;
  config: Record<string, unknown>; points: number; items: QuestionItem[];
  questionText?: string;   // teacher-written, absent when unset
  displayText: string;     // always sent, never stored: questionText ?? the type's default
  createdAt; updatedAt }
interface QuestionTextDefaults { maxLength: number; defaults: Record<QuestionType, string> }  // GET /questions/text-defaults
```
`QuestionType` and the per-type `config` shapes are in [[question-types]].

## Field rules
- Language codes: `^[a-z]{2}$` (lowercased by the server), with no enumerated list.
- Optional strings: omit the key to leave a value unchanged. `""` is **rejected** (400). There's currently no way to clear a field, except `imageMediaId: null` on learning items.
- `orderIndex`, `order`, `displayOrder`, and `points` must be JSON numbers.
- `isPublished: true` is gated ([[publish-readiness]]). Creating with `true` always fails.
- `Question.questionText`: optional, trimmed, 1–300 Unicode code points. On PATCH, `null` clears it (the type's default is used again); `""` or whitespace-only is rejected (`INVALID_QUESTION_TEXT`). Clients render `displayText` ([[adr-question-text]]).
- **Accounts:** `POST /auth/register` always creates a `student` (any `role` in the body is ignored) and requires `firstName` and `lastName`. Teachers and admins are created by an admin with `POST /admin/users`. Emails must look like `a@b.c`; passwords are trimmed and must be 8–128 characters (register, admin create, admin reset; login only checks the hash). See [[auth-and-roles]].
- **`PATCH /auth/me`** (students only): `{firstName?, lastName?, preferences?}`. Each `preferences` key is optional, **`null` clears it**, unknown keys are rejected (400). `specializationId` must exist (404 `SPECIALIZATION_NOT_FOUND`); `targetLanguage` is any 2-letter code; goal, daily target and level must be one of the values above (400 `VALIDATION_ERROR`). Goal and level are informational in the MVP.
- `Question.type` is fixed at creation. PATCH with a different `type` → 400 `QUESTION_TYPE_IMMUTABLE`; resending the same type is allowed.

## Reorder bodies (they differ per endpoint)
| Endpoint | Body |
|---|---|
| `PATCH /units/reorder` | `{ courseId, units: [{ id, orderIndex }] }` (ids must be in the course) |
| `PATCH /exercises/reorder` | `[{ id, orderIndex }]` (one unit; partial list allowed) |
| `PATCH /questions/reorder` | `[{ id, orderIndex }]` (one exercise; partial list allowed) |
| `PATCH /units/:id/learning-items/reorder` | `[{ learningItemId, order }]` (**must list every attached item**) |
Each returns the updated, ordered sibling list (`Unit[]`, `Exercise[]`, `Question[]`), or the `Unit` for learning-item reorder.

## Client obligations
- Never re-implement business rules. Treat the server's 4xx as final ([[adr-business-logic-backend-only]]).
- Derive correct answers from translations; never expect an `answer` field ([[adr-answers-derived-not-stored]]).
- Sort embedded arrays (`Unit.learningItems` by `order`, `Question.items` by `displayOrder`) on the client.
- Load `Media.url` directly; it's an absolute public URL.

Current deviations: [[known-mismatches]]. Back to [[contracts-index]].
