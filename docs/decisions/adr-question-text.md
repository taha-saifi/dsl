---
type: decision
scope: cross-cutting
sources: [dsl-backend/src/models/Question.ts, dsl-backend/src/controllers/question.controller.ts, dsl-backend/src/routes/question.routes.ts, dsl-teacher-dashboard/src/components/questions/QuestionFormDialog.tsx, dsl-teacher-dashboard/src/components/questions/QuestionTextField.tsx]
updated: 2026-10-16
---
# ADR: teacher-written question text, server-side defaults, fixed type

**Context.** Questions had no text of their own; every client would have invented its own heading per type. Teachers need to phrase the instruction ("Which image shows the heart?").

## Decisions
1. **`Question.questionText` is optional.** Trimmed, 1–300 Unicode **code points** (an emoji counts once; the dashboard counter counts the same way). Absent means "use the default". No migration: existing questions keep working.
2. **Defaults live in the backend** (`defaultQuestionTexts` in `dsl-backend/src/models/Question.ts`), not in clients ([[adr-business-logic-backend-only]]):
   - every response carries a `displayText` virtual (`questionText ?? default`), never stored, so the mobile app just renders it;
   - `GET /questions/text-defaults` returns `{maxLength, defaults}` so an editor can show the default *before* a question exists.
3. **Clearing:** PATCH `questionText: null` unsets the field (`$unset`). `""`/whitespace is rejected with `INVALID_QUESTION_TEXT`, consistent with the existing "`""` is rejected" field rule ([[api-contract]]).
4. **No blank marker for `fill_blank`.** The sentence and blank already come from the target's `sentenceLanguage` translation and `config.blankWord` ([[adr-values-not-indices]]). The text is only the instruction, so requiring `___` would duplicate data that could drift.
5. **`type` is immutable after creation** (`QUESTION_TYPE_IMMUTABLE`). Alternative considered: allow a change if config/items are reset. Rejected: config and items are shaped per type, so a "changed" question is a new question; blocking is simpler and can't leave half-valid documents. Resending the same type is allowed so full-payload clients don't break.
6. **No answer field** was added; answers stay derived ([[adr-answers-derived-not-stored]]).

## Consequences
- The text is plain content and never affects validation, but because PATCH re-validates the whole merged question, editing only the text can still fail if a referenced item changed ([[known-mismatches]] D).
- `toJSON` now includes virtuals with `id: false`; no other shape change.

Back to [[decisions-index]] · [[question-types]].
