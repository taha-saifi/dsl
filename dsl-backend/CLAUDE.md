@AGENTS.md

## Claude Code — picking up this project

You're joining mid-project. Codex built and verified Phases 0 through 4a
against real MongoDB Atlas and Cloudinary data — AGENTS.md above (imported)
is the single source of truth for stack, folder structure, the full data
model, and conventions. Read it in full before making any changes.

**Status**: Phases 0 through 6 are all complete and verified — every phase
in AGENTS.md's roadmap is checked off. There is no pending "immediate next
task" right now; read the roadmap and "What not to do" section in
AGENTS.md before starting any new work, and confirm scope with the user
first since nothing beyond Phase 6 has been defined yet.

**Rules for this handoff:**
- Don't touch files from phases already checked off in AGENTS.md's roadmap
  unless you're fixing a genuine bug — each phase was verified with real
  requests against real data before being marked done, not just by
  `npm run build` passing.
- When you finish a phase, update the roadmap checklist in AGENTS.md
  yourself. That file is shared with Codex, so keep it accurate for
  whichever tool picks this project up next.
- Follow the same verification discipline already established: real
  requests against the running server and real database, explicit
  pass/fail per check, not just "it compiles."