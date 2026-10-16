---
type: model
scope: backend
sources: [dsl-backend/src/models/Media.ts]
updated: 2026-10-16
---
# Media

`dsl-backend/src/models/Media.ts`. One uploaded file in MinIO.

| Field | Type | Notes |
|---|---|---|
| `uploadedBy` | ObjectId → [[user]] | |
| `type` | `"image" \| "audio" \| "video"` | `video` is never produced by upload |
| `url` | string | **absolute** public URL, loaded directly by clients |
| `filename` | string | original filename |
| `mimeType`, `sizeBytes` | string, number | |
| `storageKey` | string | object key in the bucket (formerly `cloudinaryPublicId`) |
| `createdAt` | Date | no `updatedAt` |

Referenced by [[learning-item]] (`imageMediaId`, `translations[].audioMediaId`) and [[course]] (`thumbnailMediaId`). Pipeline: [[media-storage-minio]].

Back to [[data-model-index]].
