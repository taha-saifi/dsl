---
type: component
scope: dashboard
sources: [dsl-teacher-dashboard/src/components/questions/QuestionFormDialog.tsx, dsl-teacher-dashboard/src/components/questions/ReferenceTypeQuestionFields.tsx, dsl-teacher-dashboard/src/components/questions/StructuralTypeQuestionFields.tsx, dsl-teacher-dashboard/src/components/questions/TargetItemField.tsx, dsl-teacher-dashboard/src/components/questions/SortableQuestionRow.tsx, dsl-teacher-dashboard/src/lib/sentenceWords.ts, dsl-teacher-dashboard/src/pages/ExerciseDetailPage.tsx]
updated: 2026-10-16
---
# Question builder

Lives on `ExerciseDetailPage`. Questions are listed as sortable rows, and create/edit happens in `QuestionFormDialog`.

## `QuestionFormDialog`
- Shared fields: a type selector (8 types) and `points` (default 10).
- **Changing the type resets `items` and `config`.**
- Language pickers only offer the parent course's `sourceLanguage` and `targetLanguage` (`languageOptionsFromCodes` in `ExerciseDetailPage.tsx`).
- On submit:
  - Checks the language config fields are filled, and lowercases them.
  - Renumbers `items[].displayOrder` to 0..n.
  - Sends **the full** `{type, points, config, items}`, plus `exerciseId` and `orderIndex = max+1` on create.
- Learning-item labels are fetched with `getLearningItem` per id.
- Backend validation errors ([[question-validation]]) are shown inline as the message text.

## Reference types (`ReferenceTypeQuestionFields.tsx`)
`choose_picture`, `multiple_choice`, `listening_transcribe`, `listening_select`, `typing`.
- `REFERENCE_TYPE_CONFIG_FIELDS` lists the language fields per type, matching the backend's `requiredConfigFields`.
- The target is picked with `TargetItemField`, which opens `AttachLearningItemDialog` as a picker. Distractors are appended with `role: "distractor"`.

## Structural types (`StructuralTypeQuestionFields.tsx`)
- **fill_blank**: pick a target, then click a word of its `sentenceLanguage` translation to set `blankWord`.
- **arrange_sentence**: `wordBlocks` is filled in automatically from the sentence (only while empty). The teacher removes blocks, adds extra distractor words, or resets from the sentence. A client-side hint (`computeWordBlocksHint`) flags missing words or the lack of a distractor. A freshly filled list has no distractor, so the backend returns `WORD_BLOCKS_NO_DISTRACTOR` until the teacher adds one.
- **matching**: items are added with `role: "pair"`. Each row shows whether it has the source and target translations.

Words come from `tokenize` in `lib/sentenceWords.ts` (whitespace split, punctuation trimmed from the ends), **which differs from the backend's splitter** ([[known-mismatches]]).

Payload reference: [[question-types]]. Back to [[dashboard-index]].
