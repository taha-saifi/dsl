---
type: model
scope: backend
sources: [dsl-backend/src/models/Unit.ts, dsl-backend/src/controllers/units.controller.ts]
updated: 2026-10-16
---
# Unit

`dsl-backend/src/models/Unit.ts`

| Field | Type | Notes |
|---|---|---|
| `courseId` | ObjectId → [[course]] | required |
| `name` | string | required |
| `orderIndex` | number | required; set by the client (the dashboard uses max+1) |
| `isPublished` | boolean | gated ([[publish-readiness]]) |
| `learningItems` | `{ learningItemId, order }[]` | embedded vocabulary list (no `_id`s) |
| `createdAt`, `updatedAt` | Date | |

## Embedded vocabulary (`learningItems[]`)
- Attach: `POST /units/:id/learning-items {learningItemId, order}`. A duplicate gives 409 `LEARNING_ITEM_ALREADY_ATTACHED`.
- Detach: idempotent, 200 even when the item isn't attached.
- Reorder: the body is a bare array that must contain **every** attached id exactly once.
- The stored array **isn't sorted by `order`**, so clients sort it themselves.
- An attachment blocks deleting the learning item ([[delete-guards]]).

Ordering of units: `PATCH /units/reorder {courseId, units:[{id,orderIndex}]}`. Every id must belong to `courseId`.

Children: [[exercise]]. Vocabulary: [[learning-item]]. Back to [[data-model-index]].
