---
type: model
scope: backend
sources: [dsl-backend/src/models/Course.ts, dsl-backend/src/controllers/courses.controller.ts]
updated: 2026-10-16
---
# Course

`dsl-backend/src/models/Course.ts`

| Field | Type | Notes |
|---|---|---|
| `specializationId` | ObjectId → [[specialization]] | required; checked to exist on create and update |
| `thumbnailMediaId` | ObjectId? → [[media]] | not type-checked; can't be cleared |
| `name` | string | required |
| `sourceLanguage` | 2-letter | required: the learner's language (e.g. `ar`) |
| `targetLanguage` | 2-letter | required: the language being taught (e.g. `en`) |
| `description` | string? | |
| `isPublished` | boolean | default false; gated ([[publish-readiness]]) |
| `createdAt`, `updatedAt` | Date | |

The list is sorted newest first and can be filtered by `?specializationId`. The dashboard limits question language pickers to the course's two languages ([[question-builder]]).

Children: [[unit]]. Back to [[data-model-index]].
