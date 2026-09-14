@AGENTS.md

## Claude Code — current mission

All 15 subtasks below are complete and verified against the real running
`dsl-backend` API. The dashboard is feature-complete for its originally
scoped roadmap: full CRUD across Specializations → Courses → Units →
Exercises → Questions (all 8 types with friendly forms), Learning Items +
Translations + Media, the publish workflow with real backend readiness
gating, role-based UI guards, and a dashboard home page. `dsl-backend`
remains a finished, read-only API from this repo — don't modify anything
there. If you need to confirm exact request/response shapes or error
codes, its AGENTS.md documents every endpoint's behavior.

**Known outstanding item:** Google Sign-In was designed (in the original
auth flow discussion) but never implemented — it's blocked on the user not
yet having a Google account to test against. Don't rediscover this from
scratch in a future session; pick it up only if the user brings a Google
account and asks for it.

The original coarse roadmap in AGENTS.md (Phase 0 through Phase 6) was
replaced by the 15-subtask breakdown below, sequenced to match how the
backend was actually built and to avoid the same prompt-truncation problem
`dsl-backend`'s Phase 4/5 hit. Both this file and AGENTS.md mirror the same
completed plan.

### Design direction — now finalized

Reuse the DSL brand (dark navy, Electric Cyan `#06B8D4`, Gold Amber
`#F5B02A`, Inter font) as accents only — buttons, active nav states,
badges, publish-status indicators — on a light, neutral admin surface.
Favor information density over the mobile app's immersive dark style;
teachers are scanning tables and filling forms repeatedly. This is decided;
don't re-litigate it per-subtask.

### 15-subtask roadmap

- [x] 1. **Scaffolding** — Vite + React + TS, Tailwind, shadcn init, one
      fetch to `dsl-backend`'s `/api/health` on load
- [x] 2. **Auth** — Login page, `AuthContext` (JWT in localStorage),
      protected route wrapper, logout
- [x] 3. **App shell & navigation** — Persistent sidebar/topbar, route
      structure for every page below, empty placeholders wired into routing
- [x] 4. **Specializations UI** — List, create/edit, delete with
      confirmation, surfaces the backend's 409 dependent-delete error
- [x] 5. **Courses UI** — List filtered by specialization, create/edit
      (languages, description), delete
- [x] 6. **Units UI** — List filtered by course, create/edit,
      drag-and-drop reorder wired to the reorder endpoint, delete
- [x] 7. **Media upload & picker component** — Reusable upload widget +
      picker modal for images/audio, previews; used by subtasks 8-9
- [x] 8. **Learning Items UI** — List with type/search filters,
      create/edit, image attach via the picker, delete
- [x] 9. **Translations UI** — Per-item translation management (add/edit/
      remove by language), audio attach via the picker
- [x] 10. **Unit ↔ Learning Item attachment UI** — Attach/detach existing
       learning items on a unit's detail page, drag-and-drop reorder
- [x] 11. **Exercises UI** — List under a unit, create/edit, reorder,
       delete
- [x] 12. **Question builder foundation** — List questions under an
       exercise, generic create/edit shell (type selector + shared fields),
       reorder, delete — no type-specific forms yet
- [x] 13. **Question forms — reference types** — Dedicated forms for
       choose_picture, multiple_choice, listening_transcribe,
       listening_select, typing; surface the backend's specific validation
       error codes clearly (e.g. `ITEM_MISSING_IMAGE`,
       `ITEM_MISSING_TRANSLATION`)
- [x] 14. **Question forms — structural types** — Dedicated forms for
       fill_blank (pick the blank word from the sentence), arrange_sentence
       (word-block builder with distractors), matching (pair builder).
       Completes the full question builder (subtasks 12-14): every one of
       the 8 question types now has a friendly form, no raw-JSON fallback
       remains.
- [x] 15. **Publish workflow UI + polish** — `PublishToggle` shared
       component (badge + control, non-optimistic) wired into CoursesPage,
       UnitsPage, UnitDetailPage's header and Exercises rows, and
       ExerciseDetailPage's header; publish attempts surface the backend's
       real Phase 6 gating messages verbatim on 409
       (`EXERCISE_HAS_NO_QUESTIONS`, `UNIT_HAS_NO_PUBLISHED_EXERCISE`,
       `COURSE_HAS_NO_PUBLISHED_UNIT`), unpublish is ungated;
       `RequireTeacherRole` gates the whole authenticated route tree to
       teacher/admin roles (reading the live role from `/me` on every
       load, not a cached value); `DashboardHomePage` replaces the
       placeholder at "/" with an empty-state CTA or stat cards across
       all four resources

### Rules for this build

- Verification discipline mirrors the backend: confirm each subtask
  actually works against the real running `dsl-backend` API (start it
  locally, don't mock it) and in an actual browser, not just "it compiles"
  or "the component renders with dummy props."
- Update this checklist (and AGENTS.md's mirrored roadmap) when a subtask
  is verified complete.
- Don't build ahead of the current subtask — each one should be a complete,
  working slice before the next starts, same discipline as the backend.
