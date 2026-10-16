---
type: feature
scope: cross-cutting
sources: [dsl-backend/src/models/Course.ts, dsl-backend/src/models/Unit.ts, dsl-backend/src/models/Exercise.ts]
updated: 2026-10-16
---
# Feature: course, unit and exercise metadata (later)

**Size:** S · **Depends on:** none (content-side; can ship any time) · **Changes [[api-contract]]:** yes

## Goal
Cards show the details in Figma: course subtitle and level, unit description, exercise difficulty and estimated time.

## Figma screens
[[figma-screen-inventory]]: Catalog `62:5`, Course Details `87:5`, Unit Details `87:104`, Exercise Intro `112:370`.

## Mobile scope
Render the extra fields when present.

## Backend changes
- **Additive** optional fields on the existing endpoints: `Course.subtitle?`, `Course.level?` (beginner/intermediate/advanced), `Unit.description?`, `Exercise.description?`, `Exercise.difficulty?` (easy/medium/hard).
- Estimated time is derived from question count (proposed ~30s per question) rather than stored. `/learn/*` exposes them.

## Database changes
Optional fields; no migration.

## Dashboard changes
Course, unit and exercise forms get the new inputs ([[state-and-forms]]).

## Decisions (2026-10-16)
- Q32 → Only **`Course.level`** (beginner/intermediate/advanced) and **`Exercise.difficulty`** (easy/medium/hard) are added; no subtitle and no unit or exercise descriptions. Estimated time is **derived** from the question count.

Back to [[00-feature-catalog]].
