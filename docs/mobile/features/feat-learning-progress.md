---
type: feature
scope: cross-cutting
sources: [docs/data-model/student-progress-planned.md]
updated: 2026-10-16
---
# Feature: learning progress (MVP)

**Size:** M · **Depends on:** [[feat-answer-checking-and-sessions]], [[feat-catalog-and-enrollment]] · **Changes [[api-contract]]:** yes

## Goal
A student sees what they've finished and how far along each course and unit is, and Continue takes them to the next exercise.

## Figma screens
[[figma-screen-inventory]]: the % bars, Done marks and "n of m exercises" on Home `60:5`, Catalog `62:5`, Course Details `87:5` and Unit Details `87:104`. DS: Progress Bar `52:241`, Progress Ring `52:217`.

## Mobile scope
- Progress bars and rings, Done badges, the "Continue Learning" target.
- Data is refreshed after each completed session.

## Backend changes (additive)
- `/learn/courses*`, `/learn/units/:id` and `/learn/me/courses` add:
  - `progress: {completedExercises, totalExercises, percent}`
  - `nextExerciseId`
  - per-exercise `status: not_started|completed` and `bestScore`
- **Computed on read** from `exerciseSessions` (completed sessions only) against the currently published exercises. Nothing to keep in sync, and unpublishing adjusts totals automatically.

## Database changes
None beyond `exerciseSessions` indexes. The designed `unitProgress` collection is **not** needed until [[feat-content-locking]].

## Dashboard changes
None.

## Decisions (2026-10-16)
- Q15 → Course % = completed exercises ÷ all published exercises in the course.

Back to [[00-feature-catalog]].
