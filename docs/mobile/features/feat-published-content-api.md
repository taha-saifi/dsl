---
type: feature
scope: cross-cutting
sources: [dsl-backend/src/controllers/courses.controller.ts, dsl-backend/src/controllers/units.controller.ts, dsl-backend/src/controllers/exercise.controller.ts, dsl-backend/src/services/resourceDependencies.service.ts]
updated: 2026-10-16
---
# Feature: published content API for students (MVP)

**Size:** M · **Depends on:** [[feat-student-accounts]] · **Changes [[api-contract]]:** yes

## Goal
Students see only content that's published **all the way down**: they never see drafts, empty units or broken chains.

## Figma screens
None of its own. It feeds Catalog `62:5`, Course Details `87:5` and Unit Details `87:104` ([[figma-screen-inventory]]).

## Mobile scope
No screens. The repository layer calls `/learn/*` only.

## Backend changes (additive)
A new read-only router at **`/api/learn`** that returns student-shaped responses, open to any authenticated user (the dashboard could reuse it for a "view as student" mode).
- `GET /learn/specializations`: domains with `publishedCourseCount`.
- `GET /learn/courses?specializationId&targetLanguage&search`: published courses that have **at least one playable exercise**, plus `unitCount`.
- `GET /learn/courses/:id`: the course plus its published units (each with `exerciseCount`), filtered the same way.
- `GET /learn/units/:id`: the unit plus its published exercises (each with `questionCount`).
- "Published" means the course, unit and exercise are all `isPublished` and the exercise has at least 1 question. This covers the no-cascade gap in [[publish-readiness]].
- Responses never include `Unit.learningItems[]` or anything answer-bearing.
- Unpublished or missing content returns 404 `NOT_FOUND`, never 403, so drafts don't leak.

**Behavior change (breaking only for students, and none exist yet):** authoring reads (`GET /learning-items`, `GET /media` list, `GET /questions`, `GET /units/:id` with attachments) get `requireRole("teacher","admin")`. Otherwise a student can read drafts and derive answers from translations.

## Database changes
None. The queries can use the existing `courseId`/`unitId`/`exerciseId` and `orderIndex` fields; add compound indexes `{courseId, isPublished, orderIndex}` and `{unitId, isPublished, orderIndex}` if profiling shows a need.

## Dashboard changes
None. The dashboard keeps using the authoring routes.

## Built (2026-10-16)
- All four `/learn` reads exist; visibility is computed in one place, `dsl-backend/src/services/studentCatalog.service.ts` (four queries per request; fine at MVP sizes, revisit with indexes if catalogs grow).
- 404 codes are the existing per-resource ones (`COURSE_NOT_FOUND`, `UNIT_NOT_FOUND`), not a generic `NOT_FOUND`.
- Responses also carry `exerciseCount` on courses and `courseName` on units (for the Unit Details header). `questionCount` is on unit exercises now; Slice 5 adds `questionTypes`.
- `?search` matches course names, case-insensitive, regex characters taken literally, ≤100 chars.
- Access: every authoring router is teacher/admin for all methods (Q4), including `/media/:id` and `/questions/text-defaults`.
- Media: `Media.url` and `thumbnailUrl` are built from `storageKey` + the current `MINIO_PUBLIC_ENDPOINT` on every response.
- App: `lib/features/learn/data/` (models, `LearnRepository`), tested against fixtures recorded from this API. Onboarding's `/learn` code moved there.

## Decisions (2026-10-16)
- Q4 → Students **lose** read access to the authoring GET routes (403).
- Q5 → Unpublished content disappears for enrolled students too.

Back to [[00-feature-catalog]].
