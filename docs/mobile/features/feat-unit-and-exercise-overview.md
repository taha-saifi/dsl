---
type: feature
scope: cross-cutting
sources: [dsl-backend/src/models/Unit.ts, dsl-backend/src/models/Exercise.ts]
updated: 2026-10-16
---
# Feature: unit details and exercise intro (MVP)

**Size:** S · **Depends on:** [[feat-catalog-and-enrollment]] · **Changes [[api-contract]]:** yes, additive (`questionTypes` on `/learn/units/:id` exercises)

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

## Built (2026-10-16)
- Backend: `questionTypes` is computed in the same aggregation as `questionCount` (`studentCatalog.service.ts`), sorted by question `orderIndex`, so a teacher's reorder changes it immediately.
- App (`features/unit/`):
  - **Unit Details**: course badge, the unit name, numbered exercise rows with a type summary ("Choose picture · Multiple choice · +6") and question count, and Start Next Exercise (the first exercise until progress exists).
  - **Exercise Intro**: "MIXED PRACTICE" (or the single type), the question and type counts, "What to expect" with one chip per type, a **disabled Start Exercise** that is wired to the player in Slice 6, and "I'll do this later".
  - **Course Details**: unit rows open the unit; enrolled students get Continue Learning (to the first unit).
- Shared fix: `DslBadge` now ellipsizes long labels (it overflowed with a unit name).
- Not shown (no data yet): the unit description and the exercise description and tip from Figma, difficulty, minutes, XP, Done/Locked.
- Test content: "Organs: mixed practice", 8 questions of all 8 types, copied through the API from the draft "Organs and tissues" into the S3 course's published unit. Slice 6 uses it.

## Open questions
None beyond the catalog's.

Back to [[00-feature-catalog]].
