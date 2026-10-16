---
type: architecture
scope: cross-cutting
sources: [docker-compose.yml, dsl-backend/src/app.ts, dsl-backend/src/server.ts, dsl-teacher-dashboard/src/App.tsx, dsl-teacher-dashboard/src/lib/api.ts]
updated: 2026-10-16
---
# System overview

## Components
| Path | Role | Stack |
|---|---|---|
| `dsl-backend/` | REST API. **All business logic and validation live here.** | Node 20, Express 5, TypeScript (strict, CommonJS), Mongoose 9, jsonwebtoken + bcryptjs, multer, `@aws-sdk/client-s3` |
| `dsl-teacher-dashboard/` | Teacher authoring UI: presentation and interaction only | React 19, Vite 8, Tailwind v4, shadcn/ui (base-ui), react-router-dom 7, dnd-kit |
| `dsl-mobile/` | *Planned* student app | Flutter (see [[mobile-index]]) |
| MongoDB | Persistence | `mongo:7` in compose; the sub-docs say dev uses MongoDB Atlas |
| MinIO | Media object storage (S3-compatible) | `quay.io/minio/minio` |

## Content hierarchy
```
Specialization ─< Course ─< Unit ─< Exercise ─< Question
                               │                   │
                               └──> LearningItem <─┘   (shared library)
                                       └─ translations[] ──> Media (audio)
                                       └─ imageMediaId  ──> Media (image)
```
Details in [[data-model-index]].

## Request flow
1. The browser loads the static dashboard bundle (nginx in Docker, Vite in dev).
2. The dashboard calls `${VITE_API_URL}/...` with `Authorization: Bearer <jwt>` ([[api-client]]).
3. Express runs `cors({origin: FRONTEND_URL})` → `express.json()` → router → `authenticate` → `requireRole` → controller (`dsl-backend/src/app.ts`).
4. Controllers validate input (`dsl-backend/src/utils/requestValidation.ts`), use services for checks that span several models, and respond `{ data }`. Errors go to `errorHandler`, which responds `{ error: { message, code } }` ([[validation-and-errors]]).
5. Media bytes go to MinIO. The browser then loads the stored public URL **directly from MinIO**, not through the API ([[media-storage-minio]]).

## Startup (`dsl-backend/src/server.ts`)
Connect to Mongo (exit on failure) → `ensureBucketExists()` (exit on failure) → `listen(PORT)`.

Related: [[runtime-and-deployment]], [[auth-and-roles]], [[api-contract]]. Back to [[architecture-index]].
