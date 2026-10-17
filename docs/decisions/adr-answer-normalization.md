---
type: decision
scope: cross-cutting
sources: [dsl-backend/src/services/answerNormalization.ts, dsl-backend/src/services/answerChecking.service.ts]
updated: 2026-10-17
---
# ADR: how typed answers are compared (correct / almost / wrong)

**Context.** `typing`, `listening_transcribe` and `fill_blank` compare free text with the answer derived from translations ([[question-types]]). Students type on phone keyboards that may lack accents, ligatures or curly apostrophes. A rule was needed, and it belongs in the backend ([[adr-business-logic-backend-only]]). Decided with the user as Q11 in [[feat-answer-checking-and-sessions]].

## Decision
One rule, in `dsl-backend/src/services/answerNormalization.ts`:
1. **Normalize both sides:**
   - Unicode NFC;
   - typographic apostrophes and quotes (’ ‘ ʼ “ ”) become ASCII;
   - trim, collapse whitespace, lower-case;
   - drop trailing punctuation (`. , ! ? ; : …`).
2. Equal → **`correct`**.
3. Equal after also folding accents and ligatures (é→e, à→a, ü→u, œ→oe, æ→ae, ß→ss) → **`almost`**. It counts as correct for the score, and the app shows the exact spelling ("Watch the accents: “cœur”").
4. Otherwise → **`wrong`**.

`arrange_sentence` compares the placed blocks word by word with the target sentence's words (split like `questionValidation.service.ts`): all words correct → `correct`, any word only `almost` → `almost`, else `wrong`. Choice types and matching are exact (the right option or the right pairs); they are never `almost`.

## Consequences
- An answer that's one letter off (a typo, not an accent) is `wrong`. There's no fuzzy matching; that keeps the rule explainable to teachers.
- Inner punctuation counts ("don't" ≠ "dont").
- Changing the rule changes scores of future attempts only; stored attempts keep their verdict.

Related: [[exercise-session]]. Back to [[decisions-index]].
