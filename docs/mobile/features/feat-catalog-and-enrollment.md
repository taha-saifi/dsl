---
type: feature
scope: cross-cutting
sources: [dsl-backend/AGENTS.md]
updated: 2026-10-16
---
# Feature: catalog, course details and enrollment (MVP)

**Size:** M · **Depends on:** [[feat-published-content-api]] · **Changes [[api-contract]]:** yes

## Goal
A student browses published courses, opens one, enrolls, and finds their enrolled courses on Home.

## Figma screens
[[figma-screen-inventory]]: Course Catalog `62:5`, Course Details `87:5`, Home `60:5` (MVP subset: greeting, My Courses, the current-course card with Continue). DS: Course Card `52:289`, Unit Card `52:310`, Bottom Nav `52:266`, and the empty/loading/error states `52:460` `52:473` `52:495`.

## Mobile scope
- **Bottom nav:** Home and Courses in the MVP. Practice, Certs and Profile are hidden or disabled until their features ship.
- **Catalog:** search, domain chips, and course cards showing domain, name, description, unit count, and Enrolled with a % or "Enroll Now". Sort and "Load more" are deferred until there's a lot of content.
- **Course Details:** description, unit list, and Enroll or Continue.
- **Home:** My Courses and Continue Learning. Hide XP, hearts, streak, achievements and leaderboard until those features exist.

## Backend changes (additive)
- `POST /learn/courses/:id/enroll`: idempotent, returns 201 or 200 with the `Enrollment`; 404 if the course isn't playable.
- `DELETE /learn/courses/:id/enroll`: unenroll. Progress is kept.
- `GET /learn/me/courses`: enrolled courses with progress (`null` until [[feat-learning-progress]] ships).
- `/learn/courses*` responses add `isEnrolled`.
- **Students only** (`requireRole("student")`): enrollment is a student concept.

## Database changes
- New collection **`enrollments`**: `{studentId, courseId, enrolledAt, completedAt?}`.
  - **Referenced, not embedded in `User`:** it has its own lifecycle and grows with use ([[adr-embed-vs-reference]]).
  - Unique index `{studentId, courseId}`; index `{courseId}` for teacher views later.
- No migration needed.

## Dashboard changes
None in the MVP; see [[feat-teacher-student-insights]].

## Built (2026-10-16)
- Backend as planned. Course summaries also carry `specializationName` (for the domain label on cards) and `enrolledAt`. Unenroll answers `{id: courseId}`, like other deletes. The model note is [[enrollment]].
- App:
  - **Courses tab** (`features/catalog/`): search with a 350 ms pause, domain chips, a language picker, course cards with Enroll Now or Continue, plus empty, error and loading states.
  - **Filters** start from the onboarding domain and language; a preferred domain with no published courses falls back to "All".
  - **Course Details**: counts, an About section, the unit list, Enroll Now, and Leave course (with a confirmation).
  - **Home**: greeting, Current Course (the most recently enrolled until progress exists) with Continue Learning, and My Courses.
- Not built yet: Continue Learning and the unit rows open Course Details for now; Unit Details is Slice 5. Sort and "Load more" are deferred.
- The bottom nav keeps Certs and Profile (Profile has Log out).

## Decisions (2026-10-16)
- Q6 → Students **enroll explicitly** ("Enroll Now") before playing.
- Q7 → Cards hide level and duration in the MVP. Level arrives with [[feat-course-metadata]].

Back to [[00-feature-catalog]].
