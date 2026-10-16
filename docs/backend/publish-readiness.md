---
type: component
scope: backend
sources: [dsl-backend/src/services/resourceDependencies.service.ts, dsl-backend/src/services/studentCatalog.service.ts, dsl-backend/src/controllers/courses.controller.ts, dsl-backend/src/controllers/units.controller.ts, dsl-backend/src/controllers/exercise.controller.ts, dsl-teacher-dashboard/src/components/PublishToggle.tsx]
updated: 2026-10-16
---
# Publish readiness

Course, Unit, and Exercise each have `isPublished` (default `false`). Setting it to `true` on POST or PATCH is gated. Setting it to `false` is **never** gated.

| Resource | Gate function | Passes when | Else (409) |
|---|---|---|---|
| Exercise | `ensureExerciseReadyToPublish` | at least 1 question exists | `EXERCISE_HAS_NO_QUESTIONS` |
| Unit | `ensureUnitReadyToPublish` | at least 1 **published** exercise | `UNIT_HAS_NO_PUBLISHED_EXERCISE` |
| Course | `ensureCourseReadyToPublish` | at least 1 **published** unit | `COURSE_HAS_NO_PUBLISHED_UNIT` |

- On create, the controllers pass `null`, so **creating with `isPublished: true` always fails**: a new resource can't have children yet.
- So the order is bottom-up: questions → publish exercise → publish unit → publish course.

> [!warning] No cascade
> The gates only run when publishing. Unpublishing an exercise, or deleting its last question (question deletes aren't guarded), leaves the parent unit or course published with nothing published underneath. Student-facing reads must not assume a published parent has published children. See [[gotchas]].
>
> **Handled for students (Slice 3):** `/api/learn` re-checks the whole chain on every read (`studentCatalog.service.ts`), so an emptied unit or course disappears for students. The authoring side still has no cascade.

> [!todo] Unverified: is a published question set meant to be frozen? Questions can currently be edited or deleted under a published exercise.

Dashboard: `PublishToggle` flips the badge only after the server confirms, and shows the 409 message in a toast. See [[adr-non-optimistic-publish]] and [[state-and-forms]].

Related: [[delete-guards]], [[error-codes]]. Back to [[backend-index]].
