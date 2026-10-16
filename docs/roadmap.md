---
type: roadmap
scope: cross-cutting
sources: [dsl-backend/AGENTS.md, dsl-backend/CLAUDE.md, dsl-teacher-dashboard/CLAUDE.md]
updated: 2026-10-16
---
# Roadmap

## Done
- **Backend Phases 0–6** (`dsl-backend/AGENTS.md`, "Roadmap"): scaffold, auth, Specialization/Course/Unit CRUD, media (MinIO), learning items and translations, unit attachments, exercises and questions (all 8 types), publish gating, and role permissions.
- **Dashboard subtasks 1–15** (`dsl-teacher-dashboard/CLAUDE.md`): full authoring UI, including all 8 question forms, publish workflow, and role guard.
- **Question text + student preview** (2026-10-16): optional `questionText` with per-type defaults, immutable question type, grouped type picker, live phone preview in the question form and a preview modal on the list ([[adr-question-text]], [[question-builder]]).
- **Monorepo**: compose stack (Mongo, MinIO, backend, frontend); knowledge vault (this folder).

## Outstanding
- **Google Sign-In.** Designed but blocked: the user doesn't have a Google account to test with yet. Pick it up only when asked (`dsl-teacher-dashboard/CLAUDE.md`).
- **Fix [[known-mismatches]]**, starting with group A (silent data loss) and the open-registration role default.
- **Move JWT to httpOnly cookies** before any real deployment ([[adr-jwt-in-localstorage]]).

## Next (not yet scoped; confirm with the user first)
1. Student-facing backend: published-only reads, student registration, progress collections ([[student-progress-planned]]).
2. `dsl-mobile/` Flutter app ([[mobile-index]]).

> [!todo] Unverified: priority and order of the items above; nothing beyond Phase 6 has been defined (`dsl-backend/CLAUDE.md`).

Back to [[00-index]].
