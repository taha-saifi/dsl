# DSL monorepo

DSL is a professional-vocabulary learning platform (medical, legal, engineering,
finance terminology taught in a foreign language). Teachers write content in a web
dashboard; students will learn it in a mobile app. Both clients use one REST API.

| Path | What | Package rules |
| --- | --- | --- |
| `dsl-backend/` | Express 5 + TypeScript + Mongoose API, media in MinIO | `dsl-backend/CLAUDE.md` |
| `dsl-teacher-dashboard/` | React 19 + Vite + Tailwind v4 + shadcn/ui authoring app | `dsl-teacher-dashboard/CLAUDE.md` |
| `dsl-mobile/` | Flutter (Android) student app, Riverpod + go_router + dio | `dsl-mobile/CLAUDE.md` |
| `docker-compose.yml` | Mongo, MinIO, backend, frontend | — |
| `docs/` | Obsidian knowledge vault describing the whole system | this file |

## How to get context

- For any task that touches more than one package, or the API, read
  `docs/00-index.md` first. Then follow wikilinks **only to the notes the task
  needs**. Don't read the whole vault.
- A wikilink such as `[[api-contract]]` refers to the note with that filename
  anywhere under `docs/`.
- Useful entry points:
  - API shape: `docs/contracts/api-contract.md`
  - Endpoints: `docs/backend/api-endpoints.md`
  - Question types: `docs/data-model/question-types.md`
  - Known client/server disagreements: `docs/contracts/known-mismatches.md`
- For work entirely inside one package, that package's `CLAUDE.md` is usually enough.

## Precedence

- Inside `dsl-backend/`, `dsl-teacher-dashboard/` and `dsl-mobile/`, their own `CLAUDE.md`
  (which imports `AGENTS.md`) takes precedence for package-specific rules: stack,
  structure, coding conventions, verification discipline.
- **One exception:** `dsl-teacher-dashboard/CLAUDE.md` calls the backend
  "read-only from this repo". That predates the monorepo. Working from the root,
  you **may modify any package, including the backend**, to coordinate a change
  across the project, unless the user says otherwise for a given task.
- Sub-project `AGENTS.md` files have some stale statements (separate repos,
  Cloudinary, "repo does not exist yet"). See `docs/conventions/conventions-index.md`.
  When docs and code disagree, the code is right.

## Cross-cutting rules

- `docs/contracts/api-contract.md` is **the source of truth for the API**
  (envelope, auth, entity shapes, request bodies, reorder shapes). Every client
  follows it.
- **An API change must update the backend, every affected client, and
  `api-contract.md` in the same change.** That includes routes, fields, enums,
  status codes and error codes. Update `docs/backend/api-endpoints.md` and
  `docs/backend/error-codes.md` when they're affected.
- Business logic and validation live in the backend only. Clients present data and
  show the server's errors.
- Correct answers are never stored. They're derived from learning-item translations.
- When you fix an entry in `docs/contracts/known-mismatches.md`, delete it in the
  same commit.

## Running

Everything in Docker (frontend :5173, API :5000/api, MinIO console :9001, Mongo :27017):

```bash
docker compose up --build      # build and start the full stack
docker compose down            # stop, keep data
docker compose down -v         # stop and wipe the Mongo/MinIO volumes
```

`VITE_API_URL` is baked into the frontend at build time. Rebuild after changing it.

Dev mode (each package reads its own `.env`; copy from `.env.example`):

```bash
cd dsl-backend && npm install && npm run dev            # ts-node-dev; needs reachable Mongo + MinIO
cd dsl-teacher-dashboard && npm install && npm run dev  # Vite on :5173
```

Build and lint: `npm run build` in either package; `npm run lint` (oxlint) in the dashboard.
Mobile: `flutter analyze && flutter test` in `dsl-mobile/`; run with
`flutter run --dart-define-from-file=env/emulator.json` (see `dsl-mobile/CLAUDE.md`).
The backend exits at startup if Mongo or MinIO is unreachable. For dev, a local MinIO
can come from `docker compose up minio`.

## Working style

- **Plan first**, then implement in **vertical slices**. A slice runs end to end:
  backend + client + docs.
- **Stop after each slice** and let the user verify before starting the next.
- Verify against the real running API and database, not just "it compiles". Each
  package's `CLAUDE.md` describes its verification discipline.
- **Never read, print, or copy `.env`, `atlas-credentials.env`, or any credential
  file.** Refer to env vars by name only. Never put secret values in `docs/`.
- Commit only when the user asks.

## Vault maintenance

- After any task that changes behavior, update the affected `docs/` notes **and
  their `updated:` date** in the same commit.
- If a note contradicts the code, the code wins: fix the note.
- Note format:
  - YAML frontmatter with `type`, `scope`, `sources` (repo-relative paths), `updated`.
  - One concept per note, under ~150 lines (split a note rather than let it grow).
  - Wikilinks to related notes and back to the section index.
  - Code cited as repo-relative paths.
  - `> [!todo] Unverified:` instead of guessing.
- Don't copy sub-project `CLAUDE.md`/`AGENTS.md` rules into the vault. Link to them instead.
- New notes are linked from their section index (and the section index from
  `docs/00-index.md`).

## dsl-mobile

- `dsl-mobile/CLAUDE.md` holds the Flutter-specific rules and takes precedence
  inside that folder.
- It follows `[[api-contract]]` (`docs/contracts/api-contract.md`). Any API it
  needs is added via the cross-cutting rule above, in the same slice.
- Its notes are in `docs/mobile/`, starting from `docs/mobile/mobile-index.md`.
  Build order and per-slice gates: `docs/mobile/mobile-roadmap.md`.
