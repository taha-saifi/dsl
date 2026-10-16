---
type: contract
scope: cross-cutting
sources: [dsl-backend/src/models/Question.ts, dsl-backend/src/services/questionValidation.service.ts, dsl-teacher-dashboard/src/components/questions/ReferenceTypeQuestionFields.tsx, dsl-teacher-dashboard/src/components/questions/StructuralTypeQuestionFields.tsx]
updated: 2026-10-16
---
# Question types

Eight types. `config` holds **only** rendering instructions; the correct answer is always worked out from the referenced learning items' translations ([[adr-answers-derived-not-stored]]). All language values are 2-letter codes.

| type | `config` | `items` | Must exist on the items |
|---|---|---|---|
| `choose_picture` | `{promptLanguage}` | 1 target + ≥1 distractor | image on target and distractors; target has `promptLanguage` |
| `multiple_choice` | `{promptLanguage, answerLanguage}` | 1 target + ≥1 distractor | target: prompt and answer; distractors: answer |
| `listening_transcribe` | `{audioLanguage, answerLanguage}` | 1 target, 0 distractors | target: audio translation **with audioMediaId**, plus answer |
| `listening_select` | `{audioLanguage, answerLanguage}` | 1 target + ≥1 distractor | target: audio translation with audio, plus answer; distractors: answer |
| `typing` | `{promptLanguage, answerLanguage}` | 1 target, 0 distractors | target: prompt and answer |
| `fill_blank` | `{promptLanguage, sentenceLanguage, blankWord}` | 1 target only | target: both; `blankWord` is a whole word in the sentence |
| `arrange_sentence` | `{promptLanguage, sentenceLanguage, wordBlocks: string[]}` | 1 target only | target: both; blocks cover every sentence word, plus at least 1 distractor block |
| `matching` | `{sourceLanguage, targetLanguage}` | ≥2 items, all `pair` | every item: both languages |

No type allows `pair` except `matching`.

## Question text
Each question may carry a teacher-written `questionText`; otherwise clients show the type's default. Both arrive resolved as `displayText` ([[adr-question-text]]). Defaults (`defaultQuestionTexts` in `dsl-backend/src/models/Question.ts`):

| type | default text |
|---|---|
| `choose_picture` | Choose the matching picture |
| `multiple_choice` | Choose the correct translation |
| `listening_transcribe` | Listen and type what you hear |
| `listening_select` | Listen and choose what you hear |
| `typing` | Type the translation |
| `fill_blank` | Complete the sentence |
| `arrange_sentence` | Arrange the words to form the sentence |
| `matching` | Match each word to its translation |

`fill_blank` needs **no blank marker** in the text: the sentence and its blank come from the target's `sentenceLanguage` translation and `config.blankWord`. The text is only the instruction.

## How a client derives the answer
- choose_picture / multiple_choice / listening_select: the target item is correct. Show the distractors' images or `answerLanguage` text as the wrong options.
- typing / listening_transcribe: expected text = the target's `answerLanguage` translation `text`.
- fill_blank: the answer is `blankWord`. The sentence is the target's `sentenceLanguage` text.
- arrange_sentence: the expected order is the target's `sentenceLanguage` text, split into words. The extra blocks are distractors.
- matching: pair each item's `sourceLanguage` text with its own `targetLanguage` text.

> [!todo] Unverified: how answers are compared (case, punctuation, accents) isn't defined anywhere. The student app will need a rule, and it should live in the backend ([[mobile-index]]).

Rules in detail: [[question-validation]]. Forms: [[question-builder]]. Back to [[data-model-index]].
