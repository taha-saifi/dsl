---
type: decision
scope: backend
sources: [dsl-backend/AGENTS.md, dsl-backend/src/services/questionValidation.service.ts]
updated: 2026-10-16
---
# ADR: store word values, not positions

**Decision** (`dsl-backend/AGENTS.md`): `fill_blank.config.blankWord` and `arrange_sentence.config.wordBlocks` store the words themselves, not token indices.
**Why:** small edits to a translation (e.g. punctuation) don't silently point the question at a different word.
**Trade-off:** the backend re-checks the words against the sentence on every write, so the client and server must split words the same way. They currently don't ([[known-mismatches]] #4).

See [[question-validation]]. Back to [[decisions-index]].
