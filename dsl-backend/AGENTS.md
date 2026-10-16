# dsl-backend — Agent Instructions

## What this repo is

The backend API for **DSL**, a professional vocabulary learning app (medical, legal, engineering, finance terminology taught in a foreign language). This API is consumed by two clients that live in separate repos:

- `dsl-teacher-dashboard` — React web app, teachers author content
- A future Flutter mobile app — students consume content and track progress

Both clients hit the same REST API. Business logic lives here only — never duplicate it client-side.

**Status: this repo does not exist yet.** You are scaffolding it from scratch. Follow the setup section below exactly, then build toward the Phase 0 definition of done.

---

## Tech stack

- Node.js + Express
- TypeScript (strict mode)
- MongoDB via Mongoose
- JWT auth (`jsonwebtoken` + `bcryptjs`)
- `dotenv` for config, `cors` for cross-origin requests from the dashboard

---

## Setup

```bash
mkdir dsl-backend && cd dsl-backend
npm init -y
npm install express mongoose dotenv cors bcryptjs jsonwebtoken
npm install -D typescript ts-node-dev @types/express @types/node @types/cors @types/bcryptjs @types/jsonwebtoken
npx tsc --init
git init
```

`package.json` scripts to add:
```json
{
  "scripts": {
    "dev": "ts-node-dev --respawn --transpile-only src/server.ts",
    "build": "tsc",
    "start": "node dist/server.js"
  }
}
```

`tsconfig.json` — enable `strict: true`, `outDir: "dist"`, `rootDir: "src"`, `esModuleInterop: true`.

### Environment variables (`.env`, gitignored — commit `.env.example` with blank values)

```
PORT=5000
MONGODB_URI=your_atlas_connection_string
JWT_SECRET=replace_with_a_long_random_string
FRONTEND_URL=http://localhost:5173
```

---

## Target folder structure

```
src/
├── config/
│   └── db.ts                  # Mongoose connection, exported connect function
├── models/
│   ├── User.ts
│   ├── Specialization.ts
│   ├── Course.ts
│   ├── Unit.ts
│   ├── Media.ts
│   ├── LearningItem.ts
│   ├── Exercise.ts
│   ├── Question.ts
│   ├── Enrollment.ts
│   ├── StudentStats.ts
│   ├── UnitProgress.ts
│   └── ExerciseSession.ts
├── routes/
│   ├── health.routes.ts
│   ├── auth.routes.ts
│   └── ...one file per resource, added as each phase is built
├── controllers/
│   └── ...mirrors routes, one controller file per resource
├── middleware/
│   ├── auth.middleware.ts     # verifies JWT, attaches req.user
│   └── error.middleware.ts    # centralized error handler
├── app.ts                     # Express app, middleware wiring, route mounting
└── server.ts                  # entry point — imports app, connects DB, listens
```

Do not put business logic in `routes/` files — routes only wire HTTP verb + path to a controller function. Controllers call Mongoose models directly at this project's current scale; introduce a service layer only if a controller starts doing multi-model orchestration.

---

## Data model — MongoDB collections

This model was originally designed relationally (15+ tables with foreign keys and junction tables) and has been translated to MongoDB. The rule applied: **embed what's always fetched together and bounded in size; reference what has an independent lifecycle or is reused across many parents.**

### users
```
_id             ObjectId
email           string, unique, required
passwordHash    string, required
role            "admin" | "teacher" | "student"
firstName       string
lastName        string
termsAcceptedAt Date, optional (register with acceptedTerms: true)
preferences     { specializationId?, targetLanguage?, goal?, dailyTargetMinutes?, experienceLevel? }, optional, embedded (onboarding)
createdAt       Date
updatedAt       Date
```

### specializations
```
_id         ObjectId
name        string            e.g. "Medicine"
slug        string, unique
iconUrl     string?
createdAt   Date
```

### courses
```
_id                 ObjectId
specializationId    ObjectId → specializations
thumbnailMediaId    ObjectId → media, nullable
name                string            e.g. "Medical English"
sourceLanguage      string (2-letter) e.g. "ar"
targetLanguage      string (2-letter) e.g. "en"
description         string?
isPublished         boolean
createdAt           Date
updatedAt           Date
```

### units
```
_id             ObjectId
courseId        ObjectId → courses
name            string
orderIndex      number
isPublished     boolean
learningItems: [                 // embedded — replaces unit_learning_items
  { learningItemId: ObjectId, order: number }
]
createdAt       Date
updatedAt       Date
```

### media
```
_id             ObjectId
uploadedBy      ObjectId → users
type            "image" | "audio" | "video"
url             string
filename        string
mimeType        string
sizeBytes       number
createdAt       Date
```

### learningItems
```
_id             ObjectId
createdBy       ObjectId → users
imageMediaId    ObjectId → media, nullable
type            "word" | "phrase" | "sentence"
translations: [                  // embedded — replaces learning_item_translations
  {
    language        string (2-letter),
    text            string,
    pronunciation   string?,
    ipa             string?,
    audioMediaId    ObjectId → media, nullable
  }
]
createdAt       Date
updatedAt       Date
```
Enforce uniqueness of `translations[].language` per item at the application layer (Mongoose doesn't enforce uniqueness within embedded arrays natively) — validate in a pre-save hook.

### exercises
```
_id             ObjectId
unitId          ObjectId → units
name            string
orderIndex      number
isPublished     boolean
createdAt       Date
updatedAt       Date
```

### questions
```
_id             ObjectId
exerciseId      ObjectId → exercises
type            "choose_picture" | "multiple_choice" | "listening_transcribe" |
                "listening_select" | "typing" | "fill_blank" |
                "arrange_sentence" | "matching"
orderIndex      number
config          Mixed             // type-specific, see catalog below
points          number, default 10
items: [                          // embedded — replaces question_items
  { learningItemId: ObjectId, role: "target" | "distractor" | "pair", displayOrder: number }
]
questionText    string, optional  // teacher-written, trimmed, ≤ 300 code points; null on PATCH clears
                                  // responses add virtual displayText = questionText ?? per-type default
                                  // type is immutable after create (QUESTION_TYPE_IMMUTABLE)
createdAt       Date
updatedAt       Date
```

### enrollments (built: `models/Enrollment.ts`)
```
_id             ObjectId
studentId       ObjectId → users
courseId        ObjectId → courses
enrolledAt      Date
completedAt     Date, nullable
```

### studentStats
```
_id                 ObjectId
studentId           ObjectId → users, unique
totalXp             number, default 0
currentStreak       number, default 0
longestStreak       number, default 0
hearts              number, default 5
lastActivityDate    Date, nullable
```

### unitProgress
```
_id             ObjectId
studentId       ObjectId → users
unitId          ObjectId → units
isUnlocked      boolean
completedAt     Date, nullable
```

### exerciseSessions
```
_id             ObjectId
studentId       ObjectId → users
exerciseId      ObjectId → exercises
startedAt       Date
completedAt     Date, nullable
xpEarned        number
heartsLost      number
accuracy        number            0–100
attempts: [                       // embedded — replaces question_attempts
  { questionId: ObjectId, isCorrect: boolean, timeTakenMs: number, attemptedAt: Date }
]
```

---

## Question type config catalog

The correct answer is **never** stored in `config`. It is always derived at runtime from the referenced `learningItem`'s translation. `config` holds rendering instructions only.

| type | config shape | items |
|---|---|---|
| `choose_picture` | `{ promptLanguage }` | 1 target + N distractor |
| `multiple_choice` | `{ promptLanguage, answerLanguage }` | 1 target + N distractor |
| `listening_transcribe` | `{ audioLanguage, answerLanguage }` | 1 target |
| `listening_select` | `{ audioLanguage, answerLanguage }` | 1 target + N distractor |
| `typing` | `{ promptLanguage, answerLanguage }` | 1 target |
| `fill_blank` | `{ promptLanguage, sentenceLanguage, blankWord }` | 1 target |
| `arrange_sentence` | `{ promptLanguage, sentenceLanguage, wordBlocks: string[] }` | 1 target |
| `matching` | `{ sourceLanguage, targetLanguage }` | N pair |

`blankWord` and `wordBlocks` store values, not positional indices — this survives minor translation text edits without breaking the question.

---

## API conventions

- Base path: `/api`
- Resource routes are plural nouns: `/api/specializations`, `/api/courses`, `/api/units`, etc.
- Standard REST verbs: `GET` (list/detail), `POST` (create), `PATCH` (partial update), `DELETE`
- Success response shape: `{ data: ... }`
- Error response shape: `{ error: { message: string, code?: string } }`, handled centrally in `error.middleware.ts` — controllers throw or call `next(err)`, they don't format error JSON themselves
- Protected routes use `auth.middleware.ts`, which verifies the JWT from the `Authorization: Bearer <token>` header and attaches `req.user`
- Role-gating (teacher vs student vs admin) happens in middleware, not scattered in controllers

## CORS

`cors()` must explicitly allow `process.env.FRONTEND_URL` as an origin. Without this, the dashboard's fetch calls fail silently and look like the backend is down — check this first if the dashboard can't connect.

## Deployment

This repo has its own multi-stage `Dockerfile` (builder compiles TypeScript with `npm run build`; runner installs production deps only and runs `node dist/server.js`). `MONGODB_URI`, `MINIO_INTERNAL_ENDPOINT`, `MINIO_PUBLIC_ENDPOINT`, and the other `MINIO_*`/`JWT_SECRET`/`FRONTEND_URL` values are supplied via environment at container runtime (via Docker Compose in a later task) — never baked into the image. `.dockerignore` excludes `node_modules`, `dist`, `.env`, `.git`, and all `*.md` files (including `AGENTS.md`/`CLAUDE.md` — dev docs, not runtime files).

---

## Roadmap (this repo's slice of each phase)

- [x] **Phase 0 — Scaffolding**
- [x] Phase 1 — Auth (register, login, JWT middleware)
- [x] Phase 2 — Specializations / Courses / Units CRUD
  - Note: the Unit↔Exercise dependent-delete guard (reject deleting a unit while exercises reference it) was missing from the original Phase 2 implementation and was added later, once Phase 5 introduced Exercises.
- [x] Phase 3 — Media upload endpoint (MinIO, local S3-compatible)
  - Note: Media originally shipped with only upload/getById/remove — a GET /api/media list endpoint (optional ?type= filter, newest-first) was added later for the dashboard's media picker.
  - Note: originally built against Cloudinary, later migrated to a self-hosted MinIO bucket (S3-compatible) — same upload validation, URL/delete contract, and "don't delete the DB record if storage deletion fails" rule, only the storage backend changed. `Media.storageKey` (formerly `cloudinaryPublicId`) holds the object key; `ensureBucketExists()` in `config/storage.ts` creates the bucket with a public-read policy on server startup.
- [x] Phase 4a — Learning Items + Translations
- [x] Phase 4b — Unit learning-item attachments
- [x] Phase 5 — Exercises + Questions CRUD (all 8 types)
  - Note: Exercise originally shipped without a reorder endpoint — PATCH /api/exercises/reorder was added later, mirroring Question's reorder (including its cross-parent unitId scope check).
- [x] Phase 6 — Publish workflow, validation, permissions
  - Publish-readiness gating: POST/PATCH on Exercise, Unit, and Course reject `isPublished: true` with 409 (`EXERCISE_HAS_NO_QUESTIONS`, `UNIT_HAS_NO_PUBLISHED_EXERCISE`, `COURSE_HAS_NO_PUBLISHED_UNIT`) unless the resource already has a qualifying published/existing child — see `ensureExerciseReadyToPublish` / `ensureUnitReadyToPublish` / `ensureCourseReadyToPublish` in `resourceDependencies.service.ts`. Setting `isPublished: false` is never gated.
  - Permissions (superseded by the Slice 3 entry below: GETs are teacher/admin too): `requireRole("teacher", "admin")` (`role.middleware.ts`, `FORBIDDEN_ROLE` / 403) is now applied to every mutating route (POST/PATCH/DELETE, including reorder/attach/detach) across every resource. GET routes remain `auth.middleware` only — any authenticated role can read. The one-off `requireRole` on Exercise's reorder route from the prior task is no longer a special case; it's now consistent with the rest of the API.
- [x] Student accounts (mobile Slice 1, 2026-10-16)
  - `POST /auth/register` always creates a `student` (default role is now `"student"`; existing users keep their stored role), requires first/last name, password 8–128 chars (`services/userAccount.service.ts`), optional `acceptedTerms` → `termsAcceptedAt`.
  - Admin-only `/api/admin/users` (`requireRole("admin")`): list (`?role=`), create teacher/admin, `PATCH /:id/password`. `USER_NOT_FOUND` 404.
  - `npm run create-admin -- --email … --password … --first-name … --last-name …` (`src/scripts/createAdmin.ts`) creates or promotes the first admin.
- [x] Onboarding preferences (mobile Slice 2, 2026-10-16)
  - `PATCH /auth/me` (student only) sets name and `preferences` (`services/learnerPreferences.service.ts`; `null` clears a key, unknown keys 400, specialization must exist).
  - New `/api/learn` router (any signed-in role): `GET /learn/specializations`, `GET /learn/languages?specializationId=`.
- [x] Published content API (mobile Slice 3, 2026-10-16)
  - `/api/learn` adds `GET /courses`, `/courses/:id`, `/units/:id`. Visibility ("published all the way down": exercise published with ≥1 question → unit → course → domain) lives only in `services/studentCatalog.service.ts`; hidden content is 404.
  - **Every authoring router is now `requireRole("teacher","admin")` for all methods, GETs included** (set once in `router.use`). Students use `/api/learn`.
  - `Media` JSON rebuilds `url` from `storageKey` with the current `MINIO_PUBLIC_ENDPOINT` (`publicMediaUrl` in `config/storage.ts`); the stored `url` is no longer sent.
- [x] Enrollment (mobile Slice 4, 2026-10-16)
  - `models/Enrollment.ts` (unique `{studentId, courseId}`), `services/enrollment.service.ts` (idempotent enroll/unenroll; visible courses only).
  - Student-only `POST`/`DELETE /api/learn/courses/:id/enroll`, `GET /api/learn/me/courses`. `/learn` course summaries add `specializationName`, `isEnrolled`, `enrolledAt`.
- [x] Unit overview (mobile Slice 5, 2026-10-16): `/learn/units/:id` exercises add `questionTypes` (distinct, by question `orderIndex`).

### Phase 0 definition of done

- `npm run dev` starts the server and logs a successful MongoDB Atlas connection
- `GET /api/health` returns `{ data: { status: "ok" } }`
- CORS is configured to allow the dashboard's origin
- No models, routes, or auth logic beyond the health check yet — resist the urge to build ahead of the current phase

---

## Conventions

- No `any` — if a type is genuinely unknown, use `unknown` and narrow it
- Async route handlers wrapped so thrown errors reach `error.middleware.ts` (e.g. an `asyncHandler` wrapper) rather than needing try/catch in every controller
- Mongoose schemas defined with explicit TypeScript interfaces, not inferred
- Environment variables accessed only through a single typed `config.ts`, never `process.env` scattered through the codebase
- Commit `.env.example`, never commit `.env`

## What not to do

- Don't store a computed/correct answer anywhere in the database — always derive it from the `learningItem` translation at request time
- Don't let a controller call another resource's Mongoose model directly for cross-cutting logic — that's a sign a service layer is needed
- Don't build ahead of the current roadmap phase — each phase should be a complete, working vertical slice before the next starts
