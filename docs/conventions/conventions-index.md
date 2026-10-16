---
type: convention
scope: cross-cutting
sources: [dsl-backend/CLAUDE.md, dsl-backend/AGENTS.md, dsl-teacher-dashboard/CLAUDE.md, dsl-teacher-dashboard/AGENTS.md]
updated: 2026-10-16
---
# Conventions

Package rules live in the packages. **Inside its folder, a package's file takes precedence** over anything in this vault. This note only says where to look; it doesn't copy the rules.

| File | Covers |
|---|---|
| `dsl-backend/CLAUDE.md` | handoff status, "don't touch verified phases except for real bugs", verification discipline (real requests, real database) |
| `dsl-backend/AGENTS.md` | stack, folder structure, data model, question catalogue, API conventions, CORS, roadmap, coding conventions, "What not to do" |
| `dsl-teacher-dashboard/CLAUDE.md` | completed 15-subtask roadmap, finalized design direction, verification rules (real API, real browser) |
| `dsl-teacher-dashboard/AGENTS.md` | stack, Tailwind v4 / shadcn setup pitfalls, env handling, folder structure, API client pattern, Docker, coding conventions |

## Known staleness in these files
- Both `AGENTS.md` files still open with "this repo does not exist yet" and describe the clients as separate repos. They now live in this monorepo.
- `dsl-backend/CLAUDE.md` mentions Cloudinary; media is on MinIO ([[adr-minio-over-cloudinary]]).
- `dsl-teacher-dashboard/AGENTS.md` says React 18 (it's actually 19) and says the design direction is unconfirmed (its `CLAUDE.md` says it's final).
- `dsl-teacher-dashboard/CLAUDE.md` calls the backend "read-only from this repo". **The root `CLAUDE.md` overrides this for cross-package work.**

Pitfalls drawn from these files: [[gotchas]]. Back to [[00-index]].
