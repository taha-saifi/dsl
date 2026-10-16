---
type: architecture
scope: cross-cutting
sources: [docker-compose.yml, dsl-mobile/env/emulator.json, dsl-mobile/android/app/src/debug/res/xml/network_security_config.xml, dsl-backend/Dockerfile, dsl-backend/.dockerignore, dsl-backend/.env.example, dsl-backend/src/config/config.ts, dsl-teacher-dashboard/Dockerfile, dsl-teacher-dashboard/.dockerignore, dsl-teacher-dashboard/nginx.conf, dsl-teacher-dashboard/.env.example, dsl-teacher-dashboard/vite.config.ts]
updated: 2026-10-16
---
# Runtime and deployment

## Docker Compose (`docker-compose.yml`)
| Service | Image / build | Host port → container | Depends on |
|---|---|---|---|
| `mongo` | `mongo:7`, volume `mongo-data`, no auth | 27017 → 27017 | — |
| `minio` | `quay.io/minio/minio`, volume `minio-data` | 9000 (S3 API), 9001 (console) | — |
| `backend` | `./dsl-backend/Dockerfile` | 5000 → 5000 | mongo, minio (`service_healthy`) |
| `frontend` | `./dsl-teacher-dashboard/Dockerfile` | 5173 → 80 | backend |

The compose file contains local-dev-only credentials inline. Never reuse them, and never copy them into notes.

## Backend env vars (names only; read only through `dsl-backend/src/config/config.ts`)
`PORT` (default 5000), `MONGODB_URI`, `JWT_SECRET`, `FRONTEND_URL`, `MINIO_INTERNAL_ENDPOINT`, `MINIO_PUBLIC_ENDPOINT`, `MINIO_ACCESS_KEY`, `MINIO_SECRET_KEY`, `MINIO_BUCKET`, `MINIO_REGION` (default `us-east-1`).
- `MINIO_INTERNAL_ENDPOINT` is what the backend uses to reach MinIO (`http://minio:9000` in compose).
- `MINIO_PUBLIC_ENDPOINT` is the base of the media URLs saved in the database, so it must be reachable from the **browser** (`http://localhost:9000`). Compose reads it from the shell with that default (`${MINIO_PUBLIC_ENDPOINT:-http://localhost:9000}`), so a phone test can use `MINIO_PUBLIC_ENDPOINT=http://<LAN IP>:9000 docker compose up`. Already-uploaded media keep the URL they were saved with ([[mobile-architecture]], "Media URLs").
- `FRONTEND_URL` is the only allowed CORS origin.

## Dashboard env var
`VITE_API_URL` (e.g. `http://localhost:5000/api`). Vite inlines it **at build time**, so in Docker it's a build `arg`, not a runtime env var. It must be a browser-reachable URL, never a compose service name. See [[adr-vite-api-url-build-arg]].

## Images
- **Backend** (`dsl-backend/Dockerfile`): `node:20-alpine` multi-stage. The builder runs `npm ci && npm run build`; the runner runs `npm ci --omit=dev` and `node dist/server.js`. `.dockerignore` excludes `node_modules`, `dist`, `.env`, `.git`, `*.md`.
- **Dashboard** (`dsl-teacher-dashboard/Dockerfile`): the builder runs `npm run build` (`tsc -b && vite build`); the runner is `nginx:alpine` serving `dist/`.
- **nginx** (`dsl-teacher-dashboard/nginx.conf`): `try_files $uri /index.html` sends unknown paths to the SPA so client routes don't 404. It does **not** proxy `/api`.

## Dev mode (no containers for the apps)
| Package | Command | Notes |
|---|---|---|
| backend | `npm run dev` (ts-node-dev, `src/server.ts`) | reads `dsl-backend/.env`; needs a reachable Mongo **and** MinIO, or startup exits |
| dashboard | `npm run dev` (Vite, :5173) | reads `dsl-teacher-dashboard/.env`; no dev proxy, calls `VITE_API_URL` directly |

| mobile | `flutter run --dart-define-from-file=env/emulator.json` | API at `http://10.0.2.2:5000/api` (the emulator's alias for the host); a phone uses `env/device.json` with the host's LAN IP. Debug builds allow cleartext HTTP; release builds don't. Details: `dsl-mobile/CLAUDE.md` |

In dev mode, Mongo and MinIO come from compose: `docker compose up -d mongo minio` (verified 2026-10-16).

Related: [[system-overview]], [[media-storage-minio]], [[gotchas]]. Back to [[architecture-index]].
