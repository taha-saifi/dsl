---
type: feature
scope: cross-cutting
sources: [dsl-backend/src/models/Unit.ts, dsl-backend/src/models/Exercise.ts]
updated: 2026-10-16
---
# Feature: unit details and exercise intro (MVP)

**Size:** S · **Depends on:** [[feat-catalog-and-enrollment]] · **Changes [[api-contract]]:** no (uses `/learn/units/:id` from [[feat-published-content-api]])

## Goal
From a course, a student opens a unit, sees its exercises in order, and starts one.

## Figma screens
[[figma-screen-inventory]]: Unit Details `87:104`, Exercise Intro `112:370`. DS: Exercise Card `52:337`.

## Mobile scope
- **Unit Details:** unit name, exercise list (name, question count, a status of not started or done), and "Start next exercise".
- **Exercise Intro:** name, unit, question count, and the **mix of question types** (exercises are mixed-type, decided 2026-10-16, so the app shows chips such as "Multiple choice · Matching · +2", not one type label). Then Start, or "I'll do this later".
- Hidden until later features ship: difficulty, minutes, XP ([[feat-course-metadata]], [[feat-xp-and-levels]]), Locked ([[feat-content-locking]]).

## Backend changes (additive)
`GET /learn/units/:id` exercises include `questionCount` and `questionTypes: QuestionType[]` (distinct, in order of first appearance).

## Database changes
None.

## Dashboard changes
None.

## Open questions
None beyond the catalog's.

Back to [[00-feature-catalog]].
