# dsl-teacher-dashboard — Agent Instructions

## What this repo is

The teacher-facing web dashboard for **DSL**, a professional vocabulary learning app. Teachers use this to build the content library (Learning Items, translations, media) and author exercises/questions, organized under Specializations → Courses → Units.

This app consumes the API in the sibling repo `dsl-backend`. All business logic and validation live in that API — this repo is presentation and interaction only. Never re-implement backend logic here (e.g. don't compute "correct answers" client-side beyond what the API already returns for review purposes).

**Status: this repo does not exist yet.** You are scaffolding it from scratch. Follow the setup section below exactly, then build toward the Phase 0 definition of done.

---

## Tech stack

- React 18 + TypeScript, built with Vite
- Tailwind CSS
- shadcn/ui for components
- React Router for navigation
- Fetch-based API client (no heavy data-fetching library needed yet — introduce React Query only if manual fetch/state juggling becomes a real problem)

---

## Setup

```bash
npm create vite@latest dsl-teacher-dashboard -- --template react-ts
cd dsl-teacher-dashboard
npm install
npm install react-router-dom
npm install tailwindcss @tailwindcss/vite
npx shadcn@latest init
git init
```

Notes on the above, learned the hard way in subtask 1:

- `npx tailwindcss init -p` (the old Tailwind v3 setup) **does not exist in Tailwind v4** — there's no `init` subcommand anymore. Install `tailwindcss` + `@tailwindcss/vite`, add `tailwindcss()` to the `plugins` array in `vite.config.ts`, and use `@import "tailwindcss";` at the top of `src/index.css` instead of `@tailwind base/components/utilities` directives or a `tailwind.config.js` file.
- The `shadcn@latest init` CLI (current major version) generates CSS that imports `shadcn/tailwind.css` for keyframes/utility helpers, but that preset does **not** include the `--color-*` token mapping Tailwind v4 needs to resolve utilities like `border-border` or `bg-background`. You have to hand-add an `@theme inline { --color-background: var(--background); ... }` block to `src/index.css` yourself, mapping every CSS variable the generator put under `:root`/`.dark` to its `--color-*` (and `--radius-*`) equivalent — otherwise the dev server throws `Cannot apply unknown utility class` at build time.

### Environment variables (`.env`, gitignored — commit `.env.example` with blank values)

```
VITE_API_URL=http://localhost:5000/api
```

**Vite's default `.gitignore` does NOT cover `.env`** — it only ignores `*.local` (e.g. `.env.local`), not plain `.env`. Add `.env` explicitly (and `!.env.example` to un-ignore the example file) or it will get committed. Verify with `git check-ignore -v .env`, don't assume.

---

## Target folder structure

```
src/
├── components/
│   └── ui/                   # shadcn-generated components live here, don't hand-edit
├── pages/
│   ├── LoginPage.tsx
│   └── ...one page per route, added as each phase is built
├── lib/
│   └── api.ts                # typed fetch wrapper — every API call goes through this
├── types/
│   └── index.ts               # TypeScript interfaces mirroring backend collections
├── context/
│   └── AuthContext.tsx        # holds JWT + current user, exposes login/logout
├── App.tsx                    # router setup
├── main.tsx
└── index.css                  # Tailwind directives
```

Feature folders (e.g. `components/courses/`, `components/questions/`) get added as each phase is built — don't pre-create empty folders for future phases.

---

## Design direction

The DSL brand (established in the Figma mobile app design) uses a premium dark navy theme, Electric Cyan (`#06B8D4`) and Gold Amber (`#F5B02A`) as accents, and Inter as the typeface. That palette was designed for the student-facing mobile app.

**For this dashboard**: reuse the same brand colors and Inter font for consistency, but favor a lighter, higher-density admin layout over the mobile app's dark immersive style — teachers are scanning tables and filling forms repeatedly, not being drawn into an experience. Default to a light or neutral surface with the navy/cyan/amber as accents (buttons, active states, badges), not as the dominant background. Confirm this direction with the user before investing heavily in theming — it hasn't been explicitly decided yet.

---

## Types (mirror the backend's Mongoose schemas)

Keep `src/types/index.ts` in sync with `dsl-backend`'s models. Core shapes:

```typescript
interface Specialization {
  _id: string;
  name: string;
  slug: string;
  iconUrl?: string;
}

interface Course {
  _id: string;
  specializationId: string;
  thumbnailMediaId?: string;
  name: string;
  sourceLanguage: string;
  targetLanguage: string;
  description?: string;
  isPublished: boolean;
}

interface Unit {
  _id: string;
  courseId: string;
  name: string;
  orderIndex: number;
  isPublished: boolean;
  learningItems: { learningItemId: string; order: number }[];
}

interface Translation {
  language: string;
  text: string;
  pronunciation?: string;
  ipa?: string;
  audioMediaId?: string;
}

interface LearningItem {
  _id: string;
  imageMediaId?: string;
  type: "word" | "phrase" | "sentence";
  translations: Translation[];
}

interface Exercise {
  _id: string;
  unitId: string;
  name: string;
  orderIndex: number;
  isPublished: boolean;
}

type QuestionType =
  | "choose_picture"
  | "multiple_choice"
  | "listening_transcribe"
  | "listening_select"
  | "typing"
  | "fill_blank"
  | "arrange_sentence"
  | "matching";

interface QuestionItem {
  learningItemId: string;
  role: "target" | "distractor" | "pair";
  displayOrder: number;
}

interface Question {
  _id: string;
  exerciseId: string;
  type: QuestionType;
  orderIndex: number;
  config: Record<string, unknown>;   // shape depends on `type` — see dsl-backend AGENTS.md catalog
  points: number;
  items: QuestionItem[];
}
```

---

## API client pattern

All requests go through `src/lib/api.ts` — a single typed wrapper, not scattered `fetch` calls in components:

```typescript
async function apiRequest<T>(path: string, options: RequestInit = {}): Promise<T> {
  const token = localStorage.getItem("dsl_token");
  const res = await fetch(`${import.meta.env.VITE_API_URL}${path}`, {
    ...options,
    headers: {
      "Content-Type": "application/json",
      ...(token ? { Authorization: `Bearer ${token}` } : {}),
      ...options.headers,
    },
  });
  if (!res.ok) {
    const err = await res.json().catch(() => ({}));
    throw new Error(err?.error?.message || "Request failed");
  }
  const json = await res.json();
  return json.data as T;
}
```

## Auth approach

JWT is stored in `localStorage` for Phase 0/1 simplicity, read by `AuthContext` on load. This is a deliberate tradeoff for solo MVP speed, not a production-final decision — revisit with httpOnly cookies before any real deployment, since localStorage tokens are readable by any script on the page (XSS exposure).

---

## Roadmap (this repo's slice of each phase)

### 15-subtask roadmap

- [x] 1. **Scaffolding** — Vite + React + TS, Tailwind, shadcn init, one
      fetch to `dsl-backend`'s `/api/health` on load
- [x] 2. **Auth** — Login page, `AuthContext` (JWT in localStorage),
      protected route wrapper, logout
- [x] 3. **App shell & navigation** — Persistent sidebar/topbar, route
      structure for every page below, empty placeholders wired into routing
- [x] 4. **Specializations UI** — List, create/edit, delete with
      confirmation, surfaces the backend's 409 dependent-delete error
- [ ] 5. **Courses UI** — List filtered by specialization, create/edit
      (languages, description), delete
- [ ] 6. **Units UI** — List filtered by course, create/edit,
      drag-and-drop reorder wired to the reorder endpoint, delete
- [ ] 7. **Media upload & picker component** — Reusable upload widget +
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

---

## Conventions

- Components are function components with explicit prop interfaces, no `any`
- One component per file, colocated with its feature folder once features exist
- Tailwind utility classes directly in JSX — don't introduce a separate CSS-in-JS system
- shadcn components are generated, not hand-written — extend via composition, don't fork the generated files unless truly necessary
- Every network call goes through `lib/api.ts`, never a raw `fetch` in a component

## What not to do

- Don't hardcode the API base URL — always read `VITE_API_URL`
- Don't duplicate backend validation logic here beyond basic UX-level form checks (required fields, format hints) — the API is the source of truth
- Don't build ahead of the current roadmap phase
