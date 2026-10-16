---
type: index
scope: backend
sources: [dsl-backend/src/app.ts, dsl-backend/CLAUDE.md, dsl-backend/AGENTS.md]
updated: 2026-10-16
---
# Backend (`dsl-backend/`)

Package rules: `dsl-backend/CLAUDE.md` (which imports `dsl-backend/AGENTS.md`). See [[conventions-index]].

## Layout (`dsl-backend/src/`)
| Folder | Contents |
|---|---|
| `server.ts` / `app.ts` | entry point; middleware wiring and router mounting |
| `config/` | `config.ts` (the only place that reads env vars), `db.ts`, `storage.ts` (S3 client, bucket setup) |
| `routes/` | one router per resource; maps verb and path to a controller, plus auth/role middleware |
| `controllers/` | request parsing and Mongoose calls |
| `services/` | checks that span models: `resourceDependencies.service.ts`, `questionValidation.service.ts`, `mediaReference.service.ts` |
| `middleware/` | `auth`, `role`, `upload` (multer), `error` (`ApiError` + handler) |
| `models/` | Mongoose schemas with explicit TS interfaces ([[data-model-index]]) |
| `utils/` | `asyncHandler`, `requestValidation` |

## Notes
- [[api-endpoints]]: every route, its role, body, and response
- [[validation-and-errors]]: input parsing helpers and error mapping
- [[error-codes]]: catalogue of every `code`
- [[media-storage-minio]]: upload/delete pipeline
- [[publish-readiness]]: publish gating rules
- [[delete-guards]]: dependent-delete 409s
- [[question-validation]]: per-type question rules

Back to [[00-index]].
