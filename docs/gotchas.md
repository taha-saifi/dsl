---
type: gotcha
scope: cross-cutting
sources: [dsl-backend/AGENTS.md, dsl-teacher-dashboard/AGENTS.md, dsl-backend/src/app.ts, dsl-backend/src/server.ts, dsl-backend/src/utils/requestValidation.ts, dsl-teacher-dashboard/vite.config.ts, dsl-teacher-dashboard/src/index.css, .gitignore]
updated: 2026-10-16
---
# Gotchas

## Setup and runtime
- **CORS looks like "backend down".** `cors()` allows only `FRONTEND_URL`. If the dashboard can't connect, check this first (`dsl-backend/AGENTS.md`, "CORS").
- **The backend exits at startup** if Mongo *or* MinIO is unreachable (`dsl-backend/src/server.ts`). Dev mode needs a MinIO too.
- **`VITE_API_URL` is baked in at build time** and must be browser-reachable. Changing it means rebuilding the frontend ([[adr-vite-api-url-build-arg]]).
- **Media URLs are absolute** (`MINIO_PUBLIC_ENDPOINT`), so changing the endpoint breaks every stored URL ([[media-storage-minio]]).
- **Vite's default `.gitignore` doesn't ignore `.env`.** The repo ignores it explicitly. Verify with `git check-ignore -v` (`dsl-teacher-dashboard/AGENTS.md`).
- **Never read or print `.env` or `atlas-credentials.env`.**

## Tailwind v4 / shadcn (dashboard)
- `npx tailwindcss init` doesn't exist in v4. Use the `@tailwindcss/vite` plugin and `@import "tailwindcss";`.
- The shadcn CLI output doesn't map `--color-*` tokens for v4. `dsl-teacher-dashboard/src/index.css` needs a hand-written `@theme inline` block, or you get `Cannot apply unknown utility class`.
- `components/ui/` is generated: compose rather than edit.

## API behaviour that surprises people
- Omitting a field leaves it unchanged, but `""` and `null` are rejected, so most optional fields can't be cleared ([[validation-and-errors]]).
- Creating with `isPublished: true` always fails with a 409 ([[publish-readiness]]).
- Unpublishing doesn't cascade upward ([[publish-readiness]]).
- `Unit.learningItems` comes back unsorted. Its reorder must include every attached item ([[unit]]).
- The three reorder endpoints have different body shapes ([[api-contract]]).
- `GET /auth/me` returns the user directly; login returns `{token, user}`.
- Every list endpoint returns drafts as well as published content.
- Registration creates **teachers** ([[auth-and-roles]]).
- A question PATCH re-validates the whole question ([[question-validation]]).

## Monorepo history
- `dsl-backend/` and `dsl-teacher-dashboard/` were imported with `git subtree`. The backend's Phases 1–6 had never been committed in the original repo, so the import captured only the scaffold. The full source was restored on 2026-10-16 from a working-tree backup.

Related: [[known-mismatches]], [[conventions-index]]. Back to [[00-index]].
