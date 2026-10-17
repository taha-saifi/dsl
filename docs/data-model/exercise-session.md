---
type: model
scope: backend
sources: [dsl-backend/src/models/ExerciseSession.ts, dsl-backend/src/services/exerciseSession.service.ts, dsl-backend/src/services/answerChecking.service.ts]
updated: 2026-10-17
---
# ExerciseSession

`dsl-backend/src/models/ExerciseSession.ts`, collection `exercisesessions`. One play of one exercise by one student ([[feat-answer-checking-and-sessions]]).

| Field | Type | Notes |
|---|---|---|
| `studentId` | ObjectId → [[user]] | |
| `exerciseId` | ObjectId → [[exercise]] | |
| `unitId`, `courseId` | ObjectId | denormalized at start, for progress queries |
| `status` | `active` \| `completed` \| `abandoned` | |
| `startedAt`, `completedAt?` | Date | |
| `questions[]` | `{questionId, type, points}` | **snapshot at start**: the playable questions in order, so teacher edits mid-session can't change the score's basis |
| `attempts[]` | `{questionId, answer, verdict, attemptedAt, timeTakenMs?}` | embedded: bounded (questions × retries), always read with the session ([[adr-embed-vs-reference]]) |
| `score`, `maxScore`, `accuracy` | Number | set on complete |

Indexes:
- `{studentId, exerciseId, status}`;
- `{studentId, courseId, completedAt}`;
- **partial unique `{studentId, exerciseId}` where `status: "active"`** (`one_active_session`).

Rules (`exerciseSession.service.ts`):
- Starting needs an enrollment (403 `NOT_ENROLLED`) and **abandons** the student's active session for that exercise (Q14).
- Answers are checked server-side ([[adr-answer-normalization]]); retries are unlimited (Q12).
- **Score** = points of questions whose **first** attempt was `correct` or `almost`; `maxScore` = all snapshot points; **accuracy** = first-attempt-right ÷ questions × 100, rounded. Unanswered or skipped questions count as wrong.
- Any score completes the exercise (Q13). Best-score and progress views come from completed sessions ([[student-progress-planned]]).
- Answers aren't stored per session beyond `attempts`: choice ids are recomputed from the question (`playPayload.choiceId`).

Back to [[data-model-index]].
