---
type: decision
scope: backend
sources: [dsl-backend/AGENTS.md, dsl-backend/src/config/storage.ts, dsl-backend/src/models/Media.ts, docker-compose.yml]
updated: 2026-10-16
---
# ADR: MinIO instead of Cloudinary

**Context:** Phase 3 originally shipped with Cloudinary.
**Decision** (roadmap notes in `dsl-backend/AGENTS.md`): migrate to a self-hosted MinIO bucket (S3-compatible) that runs in Docker Compose.
**Kept the same:** upload validation, the `{url, …}` shape, and the rule "don't delete the DB record if storage deletion fails".
**Changed:** `Media.cloudinaryPublicId` → `storageKey`. The bucket and its public-read policy are created at startup.
**Stale references:** `dsl-backend/CLAUDE.md` still mentions Cloudinary.

Details: [[media-storage-minio]]. Back to [[decisions-index]].
