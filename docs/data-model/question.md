---
type: model
scope: backend
sources: [dsl-backend/src/models/Question.ts, dsl-backend/src/controllers/question.controller.ts]
updated: 2026-10-16
---
# Question

`dsl-backend/src/models/Question.ts`

| Field | Type | Notes |
|---|---|---|
| `exerciseId` | ObjectId → [[exercise]] | required |
| `type` | `QuestionType` (8 values) | see [[question-types]] |
| `orderIndex` | number | required |
| `config` | Mixed (object) | type-specific rendering settings, **never the answer** |
| `points` | number | default 10 |
| `items` | `{ learningItemId, role, displayOrder }[]` | embedded, no `_id`s |
| `createdAt`, `updatedAt` | Date | |

- `role` is one of `"target"`, `"distractor"`, `"pair"`.
- Every write runs [[question-validation]] against the referenced [[learning-item]] documents.
- Reorder: `PATCH /questions/reorder [{id, orderIndex}]`, all in one exercise.
- Deleting a question is never blocked.

Exported constants `questionTypes` and `questionItemRoles` (in the model file) are the canonical enum lists. Back to [[data-model-index]].
