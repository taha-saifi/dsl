---
type: roadmap
scope: mobile
sources: [dsl-mobile/CLAUDE.md, dsl-backend/AGENTS.md, dsl-backend/src/app.ts]
updated: 2026-10-17
---
# Mobile (`dsl-mobile/`)

A Flutter (Android) student app. **Slices 0–2 are done**: scaffold, theme from the Figma tokens, API client with the 401 rule, a 4-tab shell, student accounts (Welcome, Sign In, Sign Up, session restore, "students only" screen, logout; see [[auth-and-roles]]), onboarding (domain, language, goal/target/level saved to `User.preferences`; see [[user]]), the published-content API with its app repository (Slice 3), catalog and enrollment: Courses tab, Course Details, Home with My Courses (Slice 4, [[enrollment]]), Unit Details and Exercise Intro with the type mix (Slice 5), the exercise player with all 8 question types and audio, on an answer-free payload (Slice 6), server-side answer checking with sessions, feedback and Exercise Complete (Slice 7, [[exercise-session]]), and progress bars, Done badges and real Continue targets computed from sessions (Slice 8). Next is Slice 9, the static screens that complete the MVP ([[mobile-roadmap]]). Package rules: `dsl-mobile/CLAUDE.md`. It follows [[api-contract]] and keeps its notes in this folder.

## Endpoints the app uses
Students may call only these; every authoring route answers them 403 ([[auth-and-roles]]).
| Need | Endpoint |
|---|---|
| Account | `POST /auth/register`, `POST /auth/login`, `GET` / `PATCH /auth/me` |
| Onboarding | `GET /learn/specializations`, `GET /learn/languages` |
| Browse published content | `GET /learn/courses`, `GET /learn/courses/:id`, `GET /learn/units/:id` |
| Enrollment | `POST` / `DELETE /learn/courses/:id/enroll`, `GET /learn/me/courses` |
| Play | `POST /learn/exercises/:id/sessions` (returns the answer-free payload), `POST /learn/sessions/:id/answers` · `complete` · `abandon` |
| Images | `thumbnailUrl` in `/learn` responses, loaded directly |

## Gaps the backend must fill next
1. ~~Published-only reads~~ and ~~student accounts~~: done (Slices 1 and 3).
3. **XP, hearts, streaks** (enrollment, sessions and progress are done): designed but not built ([[student-progress-planned]]).
4. ~~Bulk payloads~~: one play request per exercise since Slice 6.
5. ~~Answer checking~~: server-side since Slice 7 ([[adr-answer-normalization]]).
6. ~~Media URLs~~: built from the current `MINIO_PUBLIC_ENDPOINT` on every response since Slice 3 ([[media-storage-minio]]).

Stack decided in [[mobile-architecture]]: Riverpod, go_router, dio, secure storage for the token, online-only MVP.

Design reference: the brand (Electric Cyan `#06B8D4`, Gold Amber `#F5B02A`, Inter) comes from the mobile Figma design. The question screens use a light Soft Gray surface with Midnight Ink text. Cached tokens, layouts and screenshots: [[figma-question-screens]].

Render each question's `displayText` as its heading ([[adr-question-text]]).

## Planning notes
- [[figma-screen-inventory]]: every Figma frame by flow, with node ids and prototype links.
- [[backend-capability-map]]: each endpoint and learner capability, and what's missing for students.
- [[00-feature-catalog]]: MVP and later features, one note each under `features/`.
- [[mobile-architecture]]: Flutter stack and conventions (accepted).
- [[mobile-roadmap]]: build order, per-slice tasks and verification gates.

Back to [[00-index]] · [[roadmap]].
