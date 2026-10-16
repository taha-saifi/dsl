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

## Next: student mobile app (planned 2026-10-16)
The student-facing backend and `dsl-mobile/` are built together, one vertical slice at a time: Slice 0 (scaffold), then MVP slices 1–9, then the later features. Each slice is backend → dashboard → mobile and is verified before the next one.
- Order and gates: [[mobile-roadmap]]
- Features and decisions: [[00-feature-catalog]]
- Architecture: [[mobile-architecture]]
- Inputs: [[figma-screen-inventory]], [[backend-capability-map]]

Slice 1 also fixes the open-registration role default ([[known-mismatches]] #12).

Back to [[00-index]].
