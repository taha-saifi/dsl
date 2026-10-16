---
type: feature
scope: cross-cutting
sources: [dsl-backend/src/models/Question.ts, docs/data-model/student-progress-planned.md]
updated: 2026-10-16
---
# Feature: answer checking and exercise sessions (MVP)

**Size:** L · **Depends on:** [[feat-exercise-player]] · **Changes [[api-contract]]:** yes

## Goal
The server judges each answer, shows the correct answer when the student is wrong, records the attempt, and closes the exercise with a score.

## Figma screens
[[figma-screen-inventory]]:
- Correct `87:218`, Wrong `87:262`.
- Matching Wrong/Retry/Correct `147:3` `148:120` `147:61`.
- Pause `113:90` ("quitting will reset your progress").
- Exercise Complete `6:107`, MVP subset: score %, accuracy and time. XP and level wait for [[feat-xp-and-levels]].

## Mobile scope
- Check Answer → a feedback sheet: green "Correct!", or red "Incorrect, the correct answer is …".
- The "explanation" line shows the item's definition once [[feat-item-definitions-and-flashcards]] exists; until then it's omitted.
- **Wrong:** Try Again (same question) or Skip & Continue.
- **Last question:** an Exercise Complete summary, then Continue to the next exercise or Back to the unit.

## Backend changes (additive)
- `POST /learn/exercises/:id/sessions` starts a session, or resumes the active one; it returns the session and the `play` payload.
- `POST /learn/sessions/:id/answers` with `{questionId, answer}` → `{isCorrect, correctAnswer, attemptNumber}`. The answer shape depends on the type:
  - pick types: `{optionId}`
  - typing, listening_transcribe and fill_blank: `{text}`
  - arrange_sentence: `{blockIds[]}`
  - matching: `{pairs:[{leftId,rightId}]}`
- `POST /learn/sessions/:id/complete` → `{score, maxScore, accuracy, durationMs}`. `POST /learn/sessions/:id/abandon` for Quit.
- **Checking service** in the backend, using the same derivation as play. Text comparison follows **one documented normalization rule** (see Q11).
- New error codes, all 409 except the first:
  - `SESSION_NOT_FOUND` (404)
  - `SESSION_NOT_ACTIVE`
  - `QUESTION_NOT_IN_SESSION`
  - `QUESTION_ALREADY_ANSWERED`, when retries are capped (see Q12)

## Database changes
New collection **`exerciseSessions`** (the designed shape in [[student-progress-planned]], extended):
- **Identity and status:** `{studentId, exerciseId, unitId, courseId, status: active|completed|abandoned, startedAt, completedAt?}`. The `unitId` and `courseId` are denormalized for progress queries.
- **Question snapshot:** `questionIds[]`, frozen at start so teacher edits mid-session can't break it.
- **Attempts:** `attempts[]: {questionId, answer, isCorrect, attemptedAt, timeTakenMs}`.
  - Embedded, because they're bounded (questions × retries) and always read with the session.
- **Results:** `score`, `maxScore`, `accuracy`.
- **Indexes:**
  - `{studentId, exerciseId, status}`
  - `{studentId, courseId, completedAt}`
  - optionally a partial unique index giving one active session per student and exercise.
- No migration.

## Dashboard changes
None in the MVP.

## Decisions (2026-10-16)
- Q11 → **Three verdicts:** `correct`, `almost`, `wrong`.
  - Trim, collapse spaces, and ignore case and trailing punctuation. Answers that differ **only in accents** are `almost`.
  - `almost` counts as correct for score, and the feedback shows the exact spelling.
  - The answer response returns `verdict` in addition to `isCorrect`.
- Q12 → Unlimited retries. Only a correct **first** attempt counts toward score and accuracy.
- Q13 → An exercise is done at **any score**. It can be replayed, and the **best score** counts.
- Q14 → An interrupted session is **not resumed**: starting again abandons the old active session.

Back to [[00-feature-catalog]].
