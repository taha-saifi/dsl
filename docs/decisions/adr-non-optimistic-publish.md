---
type: decision
scope: dashboard
sources: [dsl-teacher-dashboard/src/components/PublishToggle.tsx, dsl-teacher-dashboard/src/pages/UnitsPage.tsx, dsl-teacher-dashboard/CLAUDE.md]
updated: 2026-10-16
---
# ADR: publish is not optimistic; reorder is

**Decision:** `PublishToggle` never flips its badge before the server confirms, because publishing can be rejected with a 409 ([[publish-readiness]]) that the teacher needs to see. Drag-and-drop reorders *are* optimistic, since they rarely fail, and roll back on error.
**Source:** comment in `dsl-teacher-dashboard/src/components/PublishToggle.tsx`; subtask 15 in `dsl-teacher-dashboard/CLAUDE.md`.

See [[state-and-forms]]. Back to [[decisions-index]].
