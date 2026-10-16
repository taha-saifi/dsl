---
type: decision
scope: backend
sources: [dsl-backend/AGENTS.md, dsl-backend/src/models/Unit.ts, dsl-backend/src/models/LearningItem.ts, dsl-backend/src/models/Question.ts]
updated: 2026-10-16
---
# ADR: embed vs reference

**Context:** the original schema was relational: 15+ tables with junction tables (`docs/assets/dsl_full_erd.html`).
**Decision** (`dsl-backend/AGENTS.md`, "Data model"): *embed what's always fetched together and bounded in size; reference what has an independent lifecycle or is reused across many parents.*
**Result:**
- Embedded: `LearningItem.translations[]`, `Unit.learningItems[]`, `Question.items[]` (and the planned `ExerciseSession.attempts[]`).
- Referenced: everything in the content hierarchy, plus Media and LearningItem.
- MongoDB can't enforce uniqueness inside an embedded array, so translation-language uniqueness is checked in a pre-save hook.

See [[data-model-index]]. Back to [[decisions-index]].
