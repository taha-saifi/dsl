---
type: roadmap
scope: cross-cutting
sources: [dsl-backend/AGENTS.md, docs/assets/dsl_full_erd.html]
updated: 2026-10-17
---
# Student progress collections (planned, not implemented)

`enrollments` is built (Slice 4): see [[enrollment]]. `exerciseSessions` is built (Slice 7): see [[exercise-session]].

**Progress is not stored** (Slice 8): `dsl-backend/src/services/learnerProgress.service.ts` computes course and unit %, the next exercise, and each exercise's best score from completed sessions on every read ([[feat-learning-progress]]). `unitProgress` is only needed for locking ([[feat-content-locking]]).

`dsl-backend/AGENTS.md` ("Data model") and the ERD describe these collections, but **there are no model files, routes, or controllers for them**. The planned model files (`StudentStats.ts`, `UnitProgress.ts`) don't exist yet.

| Collection | Key fields (as designed) |
|---|---|
| `studentStats` | `studentId` (unique), `totalXp`, `currentStreak`, `longestStreak`, `hearts` (default 5), `lastActivityDate?` |
| `unitProgress` | `studentId`, `unitId`, `isUnlocked`, `completedAt?` |

These are what [[mobile-index]] depends on. Building them is on the [[roadmap]].

> [!todo] Unverified: XP, streak, heart, and unlock rules aren't specified anywhere yet.

Back to [[data-model-index]].
