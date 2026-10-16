---
type: feature
scope: cross-cutting
sources: [dsl-backend/src/models/LearningItem.ts]
updated: 2026-10-16
---
# Feature: item definitions and flashcards (later)

**Size:** M · **Depends on:** [[feat-exercise-player]] · **Changes [[api-contract]]:** yes

## Goal
Learning items can carry an optional definition (decided 2026-10-16). Students can optionally review a unit's terms as flashcards, and the feedback sheet explains answers.

## Figma screens
[[figma-screen-inventory]]: Flashcard Front `112:424`, Flashcard Back `113:48`; the explanation line on Correct `87:218` / Wrong `87:262`.

## Mobile scope
- An optional "Review terms" deck from Unit Details (see Decisions): term, IPA, audio, then flip to the definition and an example.
- "Knew it" / "Need practice" (local only unless spaced repetition is added, which has no screen).
- The feedback sheet shows the target's definition when present.

## Backend changes
- **Additive:** optional `definition?` and `example?` on **each `Translation`** (proposed, because a definition is written in a language), max 500 chars, trimmed, `null` clears. They go into the existing translation POST/PATCH; validation is like `questionText`.
- `/learn/exercises/:id/play` adds a `flashcards[]` built from the exercise's target and pair items. Answer checks return `explanation` (definition) when present.
- Item `type` and the answer derivation are unchanged.

## Database changes
New optional fields inside the embedded `translations[]`. No migration: absent means no definition.

## Dashboard changes
Learning item detail page: definition and example inputs per translation, with counters, in the translation form ([[learning-item]]). The question preview could show it in the feedback state.

## Decisions (2026-10-16)
- Q16 → The definition (and example) are stored **per translation**.
- Q17 → **Flashcards are optional and separate from exercises.** They are a "Review terms" deck per unit, built from the unit's attached learning items (`Unit.learningItems[]`), opened from Unit Details. They're never inserted into an exercise, so the Figma "Intro → Flashcard → questions" link is not followed.
  - **This replaces the `play.flashcards[]` idea above** with `GET /learn/units/:id/flashcards`.
- Q18 → **Yes, definition mode.**
  - `multiple_choice` and `matching` get an optional `config.promptMode: "translation" | "definition"` (default `translation`, so existing questions are unchanged).
  - In definition mode the prompt/left column is the term and the options/right column are definitions in `definitionLanguage`.
  - Validation: every referenced item must have a definition in that language. New 400 code `MISSING_DEFINITION`.
  - The dashboard question form gets the toggle, and the preview renders it ([[question-builder]], [[question-preview]]).

Back to [[00-feature-catalog]].
