---
type: feature
scope: cross-cutting
sources: [docs/mobile/figma-screen-inventory.md]
updated: 2026-10-16
---
# Feature: unit and course completion screens (later)

**Size:** S · **Depends on:** [[feat-learning-progress]]; course part also [[feat-certificates]] · **Changes [[api-contract]]:** yes

## Goal
Finishing the last exercise of a unit or course shows a celebration with totals.

## Figma screens
[[figma-screen-inventory]]: Unit Complete `111:5`, Course Complete `111:52`.

## Mobile scope
After Exercise Complete, show Unit Complete when the unit reached 100%, and Course Complete when the course did.

## Backend changes
- **Additive:** session completion returns `{unitCompleted, courseCompleted}` plus unit totals (accuracy, time). Course completion sets `enrollments.completedAt`.

## Database changes
`enrollments.completedAt` (designed).

## Dashboard changes
None.

## Decisions (2026-10-16)
None.

Back to [[00-feature-catalog]].
