@AGENTS.md

## Claude Code — current mission

This repo has AGENTS.md but nothing else yet — no scaffolding exists. You
are starting Phase 7: building this dashboard from scratch and wiring it to
`dsl-backend`, which is fully built and verified through its own Phase 6
(Auth, Specializations/Courses/Units CRUD, Media, Learning Items +
Translations, Exercises + all 8 Question types, and publish-readiness
gating). Treat `dsl-backend` as a finished, read-only API from this repo —
don't modify anything there. If you need to confirm exact request/response
shapes or error codes, its AGENTS.md documents every endpoint's behavior.

The original coarse roadmap in AGENTS.md (Phase 0 through Phase 6) has been
replaced by a 15-subtask breakdown below, sequenced to match how the
backend was actually built and to avoid the same prompt-truncation problem
`dsl-backend`'s Phase 4/5 hit. **The first subtask you're given should also
update AGENTS.md's Roadmap section to replace its old Phase 0-6 list with
this one**, so both files describe the same plan going forward.

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
- [ ] 8. **Learning Items UI** — List with type/search filters,
      create/edit, image attach via the picker, delete
- [ ] 9. **Translations UI** — Per-item translation management (add/edit/
      remove by language), audio attach via the picker
- [ ] 10. **Unit ↔ Learning Item attachment UI** — Attach/detach existing
       learning items on a unit's detail page, drag-and-drop reorder
- [ ] 11. **Exercises UI** — List under a unit, create/edit, reorder,
       delete
- [ ] 12. **Question builder foundation** — List questions under an
       exercise, generic create/edit shell (type selector + shared fields),
       reorder, delete — no type-specific forms yet
- [ ] 13. **Question forms — reference types** — Dedicated forms for
       choose_picture, multiple_choice, listening_transcribe,
       listening_select, typing; surface the backend's specific validation
       error codes clearly (e.g. `ITEM_MISSING_IMAGE`,
       `ITEM_MISSING_TRANSLATION`)
- [ ] 14. **Question forms — structural types** — Dedicated forms for
       fill_blank (pick the blank word from the sentence), arrange_sentence
       (word-block builder with distractors), matching (pair builder)
- [ ] 15. **Publish workflow UI + polish** — Publish/unpublish toggles on
       Course/Unit/Exercise wired to the backend's readiness gating with
       clear blocked-reason messaging, role-based UI guards, a dashboard
       home page tying navigation together

### Rules for this build

- Verification discipline mirrors the backend: confirm each subtask
  actually works against the real running `dsl-backend` API (start it
  locally, don't mock it) and in an actual browser, not just "it compiles"
  or "the component renders with dummy props."
- Update this checklist (and AGENTS.md's mirrored roadmap) when a subtask
  is verified complete.
- Don't build ahead of the current subtask — each one should be a complete,
  working slice before the next starts, same discipline as the backend.
