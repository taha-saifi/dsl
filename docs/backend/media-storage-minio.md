---
type: component
scope: backend
sources: [dsl-backend/src/config/storage.ts, dsl-backend/src/controllers/media.controller.ts, dsl-backend/src/middleware/upload.middleware.ts, dsl-backend/src/routes/media.routes.ts, dsl-backend/src/models/Media.ts, dsl-backend/src/services/mediaReference.service.ts]
updated: 2026-10-16
---
# Media storage (MinIO)

Media is stored in a self-hosted, S3-compatible MinIO bucket. It was originally Cloudinary; see [[adr-minio-over-cloudinary]]. Older docs that still say "Cloudinary" are stale.

## Bucket setup (`dsl-backend/src/config/storage.ts`)
- `S3Client` with `endpoint = MINIO_INTERNAL_ENDPOINT` and `forcePathStyle: true`.
- `ensureBucketExists()` runs at startup. If `HeadBucket` fails, it creates the bucket and applies a **public-read** policy (`s3:GetObject` for `*`). An existing bucket's policy is left alone.

## Upload: `POST /api/media/upload` (teacher/admin)
1. multer `memoryStorage`, field `file`, 10 MB limit (`dsl-backend/src/middleware/upload.middleware.ts`).
2. Allowed MIME types: `image/jpeg`, `image/png`, `image/webp`, `audio/mpeg`, `audio/wav`, `audio/mp4`. Anything else gives 400 `UNSUPPORTED_MEDIA_TYPE`.
3. Key = `randomUUID() + original extension`, via `PutObject` with the content type.
4. `url = ${MINIO_PUBLIC_ENDPOINT}/${MINIO_BUCKET}/${key}`, an absolute URL saved in the database. Clients load it directly.
5. `type` = `image` if the MIME type starts with `image/`, otherwise `audio`. `video` is in the enum but can never be produced.
6. Creates a [[media]] document with `uploadedBy = req.user._id` and `storageKey = key`. Returns 201.

## Delete: `DELETE /api/media/:id`
Deletes the object from storage **first**. If that fails it returns 500 `STORAGE_DELETE_FAILED` and **keeps the database record**. On success it deletes the document.
> [!warning] No reference check
> Deleting media doesn't check whether a learning item or translation still points at it. See [[delete-guards]] and [[known-mismatches]].

## Type checks on references
`ensureMediaHasType` (`mediaReference.service.ts`) runs when an `imageMediaId` or `audioMediaId` is set on a learning item or translation: 404 if the media is missing, 400 `INVALID_MEDIA_TYPE` if it's the wrong kind. `Course.thumbnailMediaId` is **not** checked.

> [!todo] Unverified: since `url` stores an absolute public endpoint, changing `MINIO_PUBLIC_ENDPOINT` (e.g. for a real deployment) breaks every existing URL. Is a migration planned, or should URLs be built on read?

Dashboard side: [[state-and-forms]] (MediaPicker / MediaAttachField). Back to [[backend-index]].
