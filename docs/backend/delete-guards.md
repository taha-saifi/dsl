---
type: component
scope: backend
sources: [dsl-backend/src/services/resourceDependencies.service.ts, dsl-backend/src/controllers/specializations.controller.ts, dsl-backend/src/controllers/courses.controller.ts, dsl-backend/src/controllers/units.controller.ts, dsl-backend/src/controllers/exercise.controller.ts, dsl-backend/src/controllers/learningItem.controller.ts, dsl-backend/src/controllers/question.controller.ts, dsl-backend/src/controllers/media.controller.ts]
updated: 2026-10-16
---
# Delete guards

There are no cascading deletes. A parent can only be deleted once it has no children; otherwise you get a 409.

| Deleting | Blocked while | code |
|---|---|---|
| Specialization | any course has `specializationId` = it | `SPECIALIZATION_HAS_COURSES` |
| Course | any unit has `courseId` = it | `COURSE_HAS_UNITS` |
| Unit | any exercise has `unitId` = it | `UNIT_HAS_EXERCISES` |
| Exercise | any question has `exerciseId` = it | `EXERCISE_HAS_QUESTIONS` |
| LearningItem | any unit's `learningItems[]` contains it | `LEARNING_ITEM_ATTACHED_TO_UNIT` |
| Question | — (always allowed) | — |
| Media | — (always allowed, storage delete first) | — |

All guards live in `dsl-backend/src/services/resourceDependencies.service.ts`. The unit → exercise guard was added late (Phase 5), per `dsl-backend/AGENTS.md`.

## Gaps (dangling references are possible)
- **LearningItem referenced by a question**: not checked. After deletion the question still reads fine, but any PATCH re-validates and fails with 404 `LEARNING_ITEM_NOT_FOUND` ([[question-validation]]).
- **Media referenced by a learning item, translation, or course thumbnail**: not checked ([[media-storage-minio]]).
- **Deleting the last question of a published exercise**: allowed, which breaks [[publish-readiness]].

The dashboard shows these 409 messages verbatim in a toast ([[state-and-forms]]). Listed in [[known-mismatches]]. Back to [[backend-index]].
