---
type: feature
scope: cross-cutting
sources: [dsl-backend/src/models/Question.ts, dsl-backend/src/services/questionValidation.service.ts, dsl-teacher-dashboard/src/lib/questionPreview.ts, dsl-backend/src/controllers/media.controller.ts]
updated: 2026-10-16
---
# Feature: exercise player, all 8 question types (MVP)

**Size:** L · **Depends on:** [[feat-unit-and-exercise-overview]] · **Changes [[api-contract]]:** yes

## Goal
A student plays an exercise's questions in order, with every type rendered natively, including images and audio.

## Figma screens
[[figma-screen-inventory]] and [[figma-question-screens]]:
- Matching `5:3`, Choose Picture `5:62`, Listening `5:121`, Reorder Words `5:237`, Fill in Blank `6:3`, Multiple Choice `6:54`.
- Pause `113:90`.
- `typing` and `listening_select` have no frame; they reuse the Listening and Multiple Choice patterns.

## Mobile scope
- **Shared shell:** top bar (close X → Pause, progress, `n/total`; hearts hidden until [[feat-hearts]]), type badge, `displayText` heading, and a "Check Answer" button that's disabled until an answer is given.
- **One renderer widget per type**, driven only by the play payload.
- **Audio:** play and replay the target translation's audio.
- **Pause dialog:** Keep going, or Quit (abandons the session, see [[feat-answer-checking-and-sessions]]).

## Backend changes (additive)
**`GET /learn/exercises/:id/play`** returns `{exercise, questions[]}`, each question as `{id, type, displayText, points, prompt, media, options/bank/columns}`, built server-side **without the answer**:
- **choose_picture / multiple_choice / listening_select:** `options[{id, imageUrl?|text}]`. Ids are opaque and the order is shuffled per request; the correct one isn't marked.
- **typing / listening_transcribe:** a prompt text (or audio URL), plus `answerLanguage` for the keyboard hint.
- **fill_blank:** the sentence split into `before`/`after` around the blank. The blank word itself is withheld.
- **arrange_sentence:** a shuffled bank `[{id, text}]` including distractors.
- **matching:** two independently shuffled columns `[{id, text}]`.

This replaces N+1 client fetches and stops the client from deriving answers. The derivation logic moves from `dsl-teacher-dashboard/src/lib/questionPreview.ts` into a backend service that both checking and play use ([[adr-business-logic-backend-only]]).

**Media URLs must be reachable from a device:** `MINIO_PUBLIC_ENDPOINT` must be a host the phone can resolve (the emulator uses `10.0.2.2:9000`; a physical device uses the LAN IP). This is a config/doc change, not a code change. Rewriting URLs server-side is the alternative (see Q8).

## Database changes
None.

## Dashboard changes
None required. Optional: point the preview at the same server service later to remove duplicated logic ([[question-preview]]).

## Decisions (2026-10-16)
- Q8 → Set `MINIO_PUBLIC_ENDPOINT` **per environment** (emulator `10.0.2.2`, device LAN IP, production URL). No proxy.
  - Because `Media.url` is stored at upload time, `/learn/*` responses build URLs from `storageKey` and the current `MINIO_PUBLIC_ENDPOINT` ([[mobile-architecture]]).
- Q9 → `fill_blank` stays a **typing input**. Figma's 4-choice layout isn't followed.
- Q10 → Options are **reshuffled on every play**.

Back to [[00-feature-catalog]].
