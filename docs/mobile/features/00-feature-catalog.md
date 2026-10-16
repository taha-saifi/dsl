---
type: roadmap
scope: mobile
sources: [docs/mobile/figma-screen-inventory.md, docs/mobile/backend-capability-map.md]
updated: 2026-10-16
---
# Mobile feature catalog

Features for the `dsl-mobile/` student app. Each one is built as a vertical slice: backend, then dashboard, then mobile. Screens: [[figma-screen-inventory]]. Current API: [[backend-capability-map]].

**Decided (2026-10-16):**
- Exercises stay **mixed-type**: one exercise holds many questions of any types.
- Learning items get an **optional definition** (a model change).

## MVP: sign up, onboard, pick a course, finish a lesson with all 8 types
| # | Feature | Size | Depends on | Backend | DB | Dashboard |
|---|---|---|---|---|---|---|
| 1 | [[feat-student-accounts]] | M | Slice 0 | register → student (**breaking behavior**); admin-only `/admin/users` (add teachers, reset passwords) | `role` default, `termsAcceptedAt` | admin Users page |
| 2 | [[feat-onboarding-and-preferences]] | M | 1 | `PATCH /auth/me`, `GET /learn/languages` | `User.preferences` (embedded) | — |
| 3 | [[feat-published-content-api]] | M | 1 | new `/api/learn` read router; authoring GETs teacher-only (**breaking for students**) | — | — |
| 4 | [[feat-catalog-and-enrollment]] | M | 3 | enroll / unenroll / my courses | `enrollments` | — |
| 5 | [[feat-unit-and-exercise-overview]] | S | 4 | `questionCount`, `questionTypes` | — | — |
| 6 | [[feat-exercise-player]] | L | 5 | `GET /learn/exercises/:id/play` (answer-free, reshuffled) | — | — |
| 7 | [[feat-answer-checking-and-sessions]] | L | 6 | sessions; checking with `correct`/`almost`/`wrong` verdicts | `exerciseSessions` | — |
| 8 | [[feat-learning-progress]] | M | 7, 4 | progress computed on read | indexes | — |
| 9 | [[feat-static-screens]] | S | 1 | — | — | — |

Order: 1 → 2 → 3 → … → 9. Slice 9 can also be built any time after 1. Slices 1–8 change [[api-contract]].

## Later (suggested order)
| Feature | Size | Depends on | Notes |
|---|---|---|---|
| [[feat-content-locking]] | M | MVP 8 | sequential exercises; teacher-chosen prerequisite units |
| [[feat-course-metadata]] | S | — | `Course.level`, `Exercise.difficulty` only |
| [[feat-item-definitions-and-flashcards]] | M | MVP 6 | optional per-translation definition; definition mode for MC and matching; separate unit flashcard deck |
| [[feat-xp-and-levels]] | M | MVP 7 | |
| [[feat-hearts]] | M | MVP 7 | replays cost hearts |
| [[feat-streaks-and-daily-goal]] | S | MVP 7, MVP 2 | |
| [[feat-unit-and-course-completion]] | S | MVP 8 | |
| [[feat-teacher-student-insights]] | M | MVP 8 | dashboard only; totals only |
| [[feat-profile-and-settings]] | S | MVP 1 | real settings later; static in the MVP |
| [[feat-achievements]] | M | XP, streaks | static in the MVP |
| [[feat-certificates]] | L | completion | static in the MVP |
| [[feat-leaderboard]] | M | XP | static in the MVP |
| [[feat-google-sign-in]] | M | MVP 1 | **blocked**: no test Google account |
| [[feat-password-reset]] | M | MVP 1 | **blocked**: no email provider; the admin resets passwords meanwhile |

Not planned (no screen): spaced repetition and review, notifications, subscriptions and ads, and the **Practice** tab (no frame).

**Decided (Q34):** the Practice tab will be designed later; it's hidden in the app until then.

## Cross-cutting design choices in these notes
- **Answers stay on the server.** Students get an answer-free play payload, and checking is a backend service. The derivation now in `dsl-teacher-dashboard/src/lib/questionPreview.ts` moves into the backend ([[adr-answers-derived-not-stored]], [[adr-business-logic-backend-only]]).
- **Progress is computed on read** from `exerciseSessions`, never stored as counters, so there's nothing to drift.
- **References vs embedding:** `enrollments`, `exerciseSessions`, `studentStats` and `certificates` are referenced collections. Attempts, preferences and definitions are embedded ([[adr-embed-vs-reference]]).

All questions Q1–Q34 were answered on 2026-10-16; each note's **Decisions** section records them. Back to [[mobile-index]].
