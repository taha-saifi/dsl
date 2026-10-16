---
type: index
scope: cross-cutting
sources: [docker-compose.yml, dsl-backend/src/app.ts, dsl-teacher-dashboard/src/App.tsx]
updated: 2026-10-16
---
# DSL — Knowledge Vault

DSL teaches professional vocabulary (medical, legal, engineering, finance) in a foreign language. Teachers write content in a web dashboard and students will learn it in a Flutter app. Both clients use one REST API.

**How to use this vault:** start here. Follow links only to the notes your task needs. If a note disagrees with the code, the code is right: fix the note.

## Sections
- [[architecture-index]]: system shape, runtime, auth
- [[backend-index]]: `dsl-backend/` (Express + Mongoose + MinIO)
- [[data-model-index]]: MongoDB collections and question types
- [[dashboard-index]]: `dsl-teacher-dashboard/` (React + Vite)
- [[contracts-index]]: **the API contract every client follows**, plus known mismatches
- [[mobile-index]]: planned `dsl-mobile/` (Flutter)
- [[decisions-index]]: architectural decisions
- [[conventions-index]]: links to the package-level CLAUDE.md / AGENTS.md rules
- [[gotchas]]: pitfalls
- [[roadmap]]: what's done, what's next

## Start points by task
| Task | Read |
|---|---|
| Change or add an endpoint | [[api-contract]] → [[api-endpoints]] → [[validation-and-errors]] |
| Work on questions | [[question-types]] → [[question-validation]] → [[question-builder]] |
| Docker / env / ports | [[runtime-and-deployment]] |
| Login, tokens, roles | [[auth-and-roles]] |
| Fix a client/server disagreement | [[known-mismatches]] |
| Start the mobile app | [[mobile-index]] → [[api-contract]] |

Original relational ERD (design reference only; it predates the MongoDB model): `docs/assets/dsl_full_erd.html`.
