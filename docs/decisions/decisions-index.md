---
type: index
scope: cross-cutting
sources: [dsl-backend/AGENTS.md, dsl-teacher-dashboard/AGENTS.md, dsl-teacher-dashboard/CLAUDE.md]
updated: 2026-10-16
---
# Decisions

Architectural decisions that can be seen in the code or stated in the sub-project instruction files.

| Note | Decision |
|---|---|
| [[adr-embed-vs-reference]] | Embed bounded, always-fetched-together data; reference everything else |
| [[adr-answers-derived-not-stored]] | Correct answers are never stored; they're derived from translations |
| [[adr-values-not-indices]] | `blankWord` / `wordBlocks` store words, not positions |
| [[adr-business-logic-backend-only]] | All business rules live in the backend; clients only present |
| [[adr-minio-over-cloudinary]] | Media moved from Cloudinary to self-hosted MinIO |
| [[adr-jwt-in-localstorage]] | Dashboard keeps the JWT in localStorage (a deliberate MVP trade-off) |
| [[adr-vite-api-url-build-arg]] | `VITE_API_URL` is a build arg and must be browser-reachable |
| [[adr-question-text]] | Optional teacher-written question text with server-side per-type defaults; question type is immutable |
| [[adr-non-optimistic-publish]] | The publish toggle waits for the server; reorder is optimistic with rollback |

Back to [[00-index]].
