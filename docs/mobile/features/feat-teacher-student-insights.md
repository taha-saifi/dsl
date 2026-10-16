---
type: feature
scope: cross-cutting
sources: [docs/mobile/figma-screen-inventory.md]
updated: 2026-10-16
---
# Feature: teacher view of students (later)

**Size:** M · **Depends on:** [[feat-learning-progress]] · **Changes [[api-contract]]:** yes

## Goal
Teachers see aggregate figures for their courses (no individual students).

## Figma screens
None (dashboard only).

## Mobile scope
None.

## Backend changes
- **Additive** teacher-only endpoints: `GET /courses/:id/stats` (enrollment count, completion rates), `GET /exercises/:id/stats` (attempts, accuracy per question).

## Database changes
Reads `enrollments` and `exerciseSessions`; index `{exerciseId, status}` on sessions.

## Dashboard changes
A "Stats" panel on the course page, and per-question accuracy on the exercise page.

## Decisions (2026-10-16)
- Q33 → Teachers see **totals only**: enrollment count, completion rates, and per-question accuracy. No individual students and no enrollment management.
  - This drops `GET /courses/:id/enrollments` in favour of `GET /courses/:id/stats`.

Back to [[00-feature-catalog]].
