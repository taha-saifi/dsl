---
type: component
scope: backend
sources: [dsl-backend/src/utils/requestValidation.ts, dsl-backend/src/utils/asyncHandler.ts, dsl-backend/src/middleware/error.middleware.ts, dsl-backend/src/middleware/upload.middleware.ts]
updated: 2026-10-16
---
# Validation and errors

## Request parsing (`dsl-backend/src/utils/requestValidation.ts`)
Controllers parse `req.body` by hand with these helpers. There's no schema library. Each helper throws `ApiError(400, …, "VALIDATION_ERROR")`.

| Helper | Accepts | Rejects |
|---|---|---|
| `getBodyObject` | plain object | arrays, null, primitives |
| `getRequiredString` / `getOptionalString` | non-empty string after trim (optional: `undefined` passes) | **`""` and whitespace, even when the field is optional** |
| `getRequiredObjectId` / `getOptionalObjectId` | 24-hex string | **`null`** (optional only accepts `undefined`) |
| `getRequiredNumber` / `getOptionalNumber` | finite number | numeric strings |
| `getOptionalBoolean` | boolean | `"true"` |
| `getRouteObjectId` | route param ObjectId | → message `"<Resource> id must be a valid ObjectId."` |

> [!warning] Optional fields can't be cleared
> Since `""` and `null` are both rejected, a PATCH can't clear `description`, `iconUrl`, `pronunciation`, `ipa`, `thumbnailMediaId`, or `audioMediaId`. The one exception is `LearningItem.imageMediaId`, which accepts `null`. See [[known-mismatches]].

Update handlers build a partial `update` object from the fields that are present, then call `findByIdAndUpdate(..., {new:true, runValidators:true})`.

## Async errors
Every handler is wrapped in `asyncHandler` (`dsl-backend/src/utils/asyncHandler.ts`), which passes rejections to `next`. Controllers `throw new ApiError(status, message, code)` and never write error JSON themselves.

## Error handler (`dsl-backend/src/middleware/error.middleware.ts`)
Shape: `{ error: { message: string, code?: string } }`.

| Source | Status | code |
|---|---|---|
| `ApiError` | its own | its own |
| Mongo duplicate key (11000) | 409 | `DUPLICATE_RESOURCE` |
| `mongoose.Error.ValidationError` | 400 | `VALIDATION_ERROR` (message of the first error) |
| `multer.MulterError` | 400 | `FILE_TOO_LARGE` (>10MB) or `INVALID_FILE_UPLOAD` |
| anything else | 500 | `INTERNAL_SERVER_ERROR` (logged with `console.error`) |

Mongoose pre-hooks may throw `ApiError` directly, e.g. `DUPLICATE_TRANSLATION_LANGUAGE` in `dsl-backend/src/models/LearningItem.ts`.

Full code list: [[error-codes]]. Client side: [[api-client]]. Back to [[backend-index]].
