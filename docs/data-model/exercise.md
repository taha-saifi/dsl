---
type: model
scope: backend
sources: [dsl-backend/src/models/Exercise.ts, dsl-backend/src/controllers/exercise.controller.ts]
updated: 2026-10-16
---
# Exercise

`dsl-backend/src/models/Exercise.ts`. An ordered set of questions inside a unit.

| Field | Type | Notes |
|---|---|---|
| `unitId` | ObjectId → [[unit]] | required |
| `name` | string | required |
| `orderIndex` | number | required |
| `isPublished` | boolean | gated: needs at least 1 question ([[publish-readiness]]) |
| `createdAt`, `updatedAt` | Date | |

Reorder: `PATCH /exercises/reorder` with a bare array `[{id, orderIndex}]`. All ids must belong to one unit, otherwise 400. A partial list is allowed: only the listed ids are updated. The response is the full ordered list for that unit.

Children: [[question]]. Back to [[data-model-index]].
