---
type: decision
scope: dashboard
sources: [dsl-teacher-dashboard/AGENTS.md, dsl-teacher-dashboard/Dockerfile, docker-compose.yml]
updated: 2026-10-16
---
# ADR: VITE_API_URL is a build argument

**Fact:** Vite inlines `VITE_*` into the bundle at build time.
**Decision** (`dsl-teacher-dashboard/AGENTS.md`, "Docker"): pass it as `--build-arg` (compose `build.args`), never as a runtime env var. It must be **browser-reachable** (`http://localhost:5000/api`), never a compose hostname like `backend`.
**Result:** changing the API URL means rebuilding the frontend image (`docker compose up --build`).

See [[runtime-and-deployment]]. Back to [[decisions-index]].
