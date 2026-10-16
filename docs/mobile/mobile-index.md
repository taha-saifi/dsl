---
type: roadmap
scope: mobile
sources: [dsl-backend/AGENTS.md, dsl-backend/src/app.ts]
updated: 2026-10-16
---
# Mobile (`dsl-mobile/`, planned)

A Flutter student app. **It doesn't exist yet.** When it's added it gets its own `dsl-mobile/CLAUDE.md`, follows [[api-contract]], and keeps its notes in this folder (`docs/mobile/`).

## Existing endpoints it can use (read-only, any authenticated role)
| Need | Endpoint |
|---|---|
| Log in / current user | `POST /auth/login`, `GET /auth/me` |
| Browse catalogue | `GET /specializations`, `GET /courses?specializationId=`, `GET /units?courseId=`, `GET /exercises?unitId=` |
| Play an exercise | `GET /questions?exerciseId=`, then `GET /learning-items/:id` for each referenced item |
| Images and audio | `GET /media/:id` → load `url` directly |

## Gaps the backend must fill first
1. **Published-only reads.** List endpoints return drafts too; nothing filters on `isPublished`. Students would see unpublished content.
2. **Student accounts.** Register always creates teachers ([[auth-and-roles]]).
3. **Progress, XP, hearts, sessions, enrollment**: designed but not built ([[student-progress-planned]]).
4. **Bulk payloads.** Playing one exercise takes N+1 requests (questions → items → media). An endpoint that returns an exercise with its items and media resolved would help.
5. **Answer checking.** No comparison rules are defined ([[question-types]]). Business logic belongs in the backend ([[adr-business-logic-backend-only]]).
6. **Media URLs** are absolute and use `MINIO_PUBLIC_ENDPOINT` (`localhost` in compose), which a phone can't reach ([[media-storage-minio]]).

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
