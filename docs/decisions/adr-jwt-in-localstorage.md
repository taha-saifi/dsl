---
type: decision
scope: dashboard
sources: [dsl-teacher-dashboard/AGENTS.md, dsl-teacher-dashboard/src/context/AuthContext.tsx, dsl-teacher-dashboard/src/lib/api.ts]
updated: 2026-10-16
---
# ADR: JWT in localStorage

**Decision** (`dsl-teacher-dashboard/AGENTS.md`, "Auth approach"): store the JWT in `localStorage["dsl_token"]` for MVP speed.
**Known cost:** any script on the page can read it (XSS exposure). The file says to revisit with httpOnly cookies **before any real deployment**.
**Result:** a cookie-based approach would also need backend changes (CORS credentials, cookie issuing), so it's a cross-package change that must update [[api-contract]].

See [[auth-and-roles]]. Back to [[decisions-index]].
