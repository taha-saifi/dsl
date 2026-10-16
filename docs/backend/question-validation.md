---
type: component
scope: backend
sources: [dsl-backend/src/services/questionValidation.service.ts, dsl-backend/src/controllers/question.controller.ts, dsl-teacher-dashboard/src/lib/sentenceWords.ts]
updated: 2026-10-16
---
# Question validation

`validateQuestionForType(type, config, items, learningItemsById)` in `dsl-backend/src/services/questionValidation.service.ts` runs on **every** create and **every** PATCH. On PATCH it checks the *merged* question (new values over stored values), so even a points-only edit re-checks everything. Each `items[].learningItemId` must exist (`ensureLearningItemExists`, 404).

Type shapes: [[question-types]]. Order of checks for each family:

## Reference types (`choose_picture`, `multiple_choice`, `listening_transcribe`, `listening_select`, `typing`)
Uses the rule table `referenceQuestionTypeRules`:
1. **Item counts**: exactly 1 `target`, distractors within [min, max], 0 `pair` → `INVALID_ITEM_CARDINALITY`.
2. **Config**: each required language field is a non-empty string → `MISSING_CONFIG_FIELD`.
3. **Content checks** on the target (and on distractors where marked):
   - `choose_picture`: target **and distractors** need `imageMediaId` (`ITEM_MISSING_IMAGE`); target needs a `promptLanguage` translation.
   - `multiple_choice`: target needs `promptLanguage`; target **and distractors** need `answerLanguage`.
   - `listening_transcribe`: target needs an `audioLanguage` translation **with `audioMediaId`** (`ITEM_MISSING_AUDIO`) plus `answerLanguage`.
   - `listening_select`: as above, and distractors need `answerLanguage`.
   - `typing`: target needs `promptLanguage` and `answerLanguage`.
   - A missing translation gives `ITEM_MISSING_TRANSLATION`.

## Sentence types (`fill_blank`, `arrange_sentence`)
1. Exactly 1 target and nothing else → `INVALID_ITEM_CARDINALITY`.
2. `promptLanguage` and `sentenceLanguage` required; the target must have both translations.
3. Word splitting (`tokenizeWords`): **split on any run of characters that aren't letters or digits** (`/[^\p{L}\p{N}]+/u`), compared lowercase.
   - `fill_blank`: `config.blankWord` must appear as a whole token → `BLANK_WORD_NOT_IN_SENTENCE`.
   - `arrange_sentence`: `config.wordBlocks` (non-empty strings) must contain every sentence token as often as it appears (`WORD_BLOCKS_MISSING_WORD`) **and** have more blocks than the sentence has tokens (`WORD_BLOCKS_NO_DISTRACTOR`).

> [!warning] The dashboard splits words differently
> `dsl-teacher-dashboard/src/lib/sentenceWords.ts` splits on whitespace and trims punctuation from the ends only. `"don't"` is one token for the dashboard but `don` + `t` for the backend. See [[known-mismatches]].

## `matching`
At least 2 items, **all** `pair` → `INVALID_ITEM_CARDINALITY`. `sourceLanguage` and `targetLanguage` required; every item needs both translations.

## Design rules
- Correct answers are never stored; clients derive them from translations ([[adr-answers-derived-not-stored]]).
- `blankWord` and `wordBlocks` store words, not positions ([[adr-values-not-indices]]).
- `points` defaults to 10. `displayOrder` is required on each item, but nothing checks that it's unique.

Dashboard forms: [[question-builder]]. Back to [[backend-index]].
