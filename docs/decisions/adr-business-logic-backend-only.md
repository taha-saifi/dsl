---
type: decision
scope: cross-cutting
sources: [dsl-backend/AGENTS.md, dsl-teacher-dashboard/AGENTS.md]
updated: 2026-10-16
---
# ADR: business logic lives only in the backend

**Decision:** both `AGENTS.md` files say it. `dsl-backend/AGENTS.md`: "Business logic lives here only — never duplicate it client-side." `dsl-teacher-dashboard/AGENTS.md`: "presentation and interaction only."
**Result:**
- Clients do only UX-level checks (required fields, format hints) and display the server's error message.
- The dashboard's word splitter and word-block hints are a UI aid; the backend has the final say.
- The mobile app follows the same rule: answer grading, XP, and unlocks belong in the backend ([[mobile-index]]).

See [[api-contract]]. Back to [[decisions-index]].
