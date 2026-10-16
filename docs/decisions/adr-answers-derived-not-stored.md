---
type: decision
scope: cross-cutting
sources: [dsl-backend/AGENTS.md, dsl-backend/src/services/questionValidation.service.ts]
updated: 2026-10-16
---
# ADR: correct answers are derived, never stored

**Decision** (`dsl-backend/AGENTS.md`, "Question type config catalog" and "What not to do"): `Question.config` holds rendering instructions only. The correct answer always comes from the referenced learning item's translations at request time.
**Why:** if a translation is fixed once, every question that uses it is fixed too. There's no duplicated answer data to drift.
**Result:** validation checks that the needed translations, images, and audio exist ([[question-validation]]). Clients compute the expected answer as described in [[question-types]].

Back to [[decisions-index]].
