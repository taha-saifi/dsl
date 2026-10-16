---
type: component
scope: dashboard
sources: [dsl-teacher-dashboard/src/components/questions/QuestionFormDialog.tsx, dsl-teacher-dashboard/src/components/questions/QuestionTypePicker.tsx, dsl-teacher-dashboard/src/components/questions/QuestionTypeGlyph.tsx, dsl-teacher-dashboard/src/components/questions/QuestionTextField.tsx, dsl-teacher-dashboard/src/components/questions/ReferenceTypeQuestionFields.tsx, dsl-teacher-dashboard/src/components/questions/StructuralTypeQuestionFields.tsx, dsl-teacher-dashboard/src/components/questions/TargetItemField.tsx, dsl-teacher-dashboard/src/components/questions/SortableQuestionRow.tsx, dsl-teacher-dashboard/src/components/questions/QuestionPreviewDialog.tsx, dsl-teacher-dashboard/src/lib/questionTypes.ts, dsl-teacher-dashboard/src/lib/sentenceWords.ts, dsl-teacher-dashboard/src/pages/ExerciseDetailPage.tsx]
updated: 2026-10-16
---
# Question builder

Lives on `ExerciseDetailPage`. Questions are a numbered, sortable `<ol>`; create/edit happens in `QuestionFormDialog`. The student-side mock is described in [[question-preview]].

## List (`SortableQuestionRow`)
- Each row: drag handle, position, the type's glyph, `displayText` as the title, then type label, points, item count and a "Default text" marker when `questionText` is unset.
- Actions: **Preview** (opens `QuestionPreviewDialog`), **Edit**, delete (icon, confirm dialog).
- States: a skeleton while the page loads, an empty state with "Add the first question", the existing error/retry box.

## Type metadata (`lib/questionTypes.ts`, `QuestionTypeGlyph.tsx`)
- `QUESTION_TYPE_INFO`: label + one-line description per type, and a **family** by what the student does: *pick* (choose_picture, multiple_choice, listening_select), *type* (typing, listening_transcribe, fill_blank), *build* (arrange_sentence, matching).
- `QuestionTypeGlyph`: a tiny SVG schematic of each student screen, reused by the picker, list rows and the form header. Accent colour comes from `--glyph-accent`.

## `QuestionFormDialog`
- **Create** is two steps: `QuestionTypePicker` (native radios grouped by family, keyboard-navigable) → details. The back arrow returns to the picker; picking a *different* type resets `items` and `config`.
- **Edit** opens straight on details; the type is shown but can't be changed (the server returns `QUESTION_TYPE_IMMUTABLE`, [[adr-question-text]]). Edits never send `type`.
- Details: `QuestionTextField` + points, then the type-specific fields; at `lg` and up the live preview sits in a right-hand column, below that it stacks under the form.
- `QuestionTextField`: placeholder = the type's default (from `GET /questions/text-defaults`), a counter in code points after trimming, amber at 90%, red and "Shorten this by N characters" over the limit (Save is disabled). Empty means "use the default".
- Language pickers only offer the course's `sourceLanguage` and `targetLanguage` (`languageOptionsFromCodes`).
- On submit: checks language fields are filled and lowercases them; renumbers `items[].displayOrder` to 0..n; sends `{points, config, items, questionText: trimmed || null}` on edit, `{exerciseId, type, orderIndex = max+1, points, config, items, questionText?}` on create.
- Errors: `ApiError.code === "INVALID_QUESTION_TEXT"` shows under the text field; anything else shows in the banner as the server's message ([[question-validation]]).
- Learning items are resolved through `usePreviewSources` (shared cache), which also feeds the preview.

## Reference types (`ReferenceTypeQuestionFields.tsx`)
`choose_picture`, `multiple_choice`, `listening_transcribe`, `listening_select`, `typing`.
- `REFERENCE_TYPE_CONFIG_FIELDS` lists the language fields per type, matching the backend's `requiredConfigFields`.
- The target is picked with `TargetItemField` (opens `AttachLearningItemDialog`). Distractors are appended with `role: "distractor"`.

## Structural types (`StructuralTypeQuestionFields.tsx`)
- **fill_blank**: pick a target, then click a word of its `sentenceLanguage` translation to set `blankWord`.
- **arrange_sentence**: `wordBlocks` is filled from the sentence while empty; the teacher removes blocks, adds distractor words, or resets. `computeWordBlocksHint` flags missing words or no distractor.
- **matching**: items are added with `role: "pair"`; each row shows whether both translations exist.

Words come from `tokenize` in `lib/sentenceWords.ts`, **which differs from the backend's splitter** ([[known-mismatches]]).

Payload reference: [[question-types]]. Back to [[dashboard-index]].
