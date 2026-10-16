---
type: contract
scope: backend
sources: [dsl-backend/src/middleware/error.middleware.ts, dsl-backend/src/services/resourceDependencies.service.ts, dsl-backend/src/services/questionValidation.service.ts, dsl-backend/src/services/mediaReference.service.ts, dsl-backend/src/controllers/auth.controller.ts, dsl-backend/src/controllers/media.controller.ts, dsl-backend/src/middleware/upload.middleware.ts, dsl-backend/src/controllers/question.controller.ts]
updated: 2026-10-16
---
# Error codes

Every error body is `{error:{message, code}}`. Clients should branch on `code`, not on `message` text.

## Generic
| code | status | When |
|---|---|---|
| `VALIDATION_ERROR` | 400 | bad or missing field, bad ObjectId, mongoose validation |
| `UNAUTHORIZED` | 401 | missing or invalid token, user gone |
| `INVALID_CREDENTIALS` | 401 | login failed |
| `FORBIDDEN_ROLE` | 403 | role not allowed ([[auth-and-roles]]) |
| `EMAIL_IN_USE` | 409 | register or `POST /admin/users` with an existing email |
| `DUPLICATE_RESOURCE` | 409 | Mongo unique index violated |
| `CONFIGURATION_ERROR` | 500 | `JWT_SECRET` missing at sign time |
| `INTERNAL_SERVER_ERROR` | 500 | unhandled |

## Not found (404)
`SPECIALIZATION_NOT_FOUND`, `COURSE_NOT_FOUND`, `UNIT_NOT_FOUND` (also: reorder ids not in the course), `EXERCISE_NOT_FOUND`, `QUESTION_NOT_FOUND`, `LEARNING_ITEM_NOT_FOUND`, `MEDIA_NOT_FOUND`, `TRANSLATION_NOT_FOUND`, `USER_NOT_FOUND` (admin password reset).

## Conflicts (409)
| code | Rule |
|---|---|
| `SLUG_IN_USE` | specialization slug taken |
| `TRANSLATION_LANGUAGE_IN_USE` | translation for that language already exists |
| `LEARNING_ITEM_ALREADY_ATTACHED` | unit already has the item |
| `SPECIALIZATION_HAS_COURSES`, `COURSE_HAS_UNITS`, `UNIT_HAS_EXERCISES`, `EXERCISE_HAS_QUESTIONS`, `LEARNING_ITEM_ATTACHED_TO_UNIT` | [[delete-guards]] |
| `EXERCISE_HAS_NO_QUESTIONS`, `UNIT_HAS_NO_PUBLISHED_EXERCISE`, `COURSE_HAS_NO_PUBLISHED_UNIT` | [[publish-readiness]] |

## Learning items / media (400 unless noted)
`DUPLICATE_TRANSLATION_LANGUAGE` (pre-save hook), `INVALID_MEDIA_TYPE` (image id used as audio or vice versa), `FILE_REQUIRED`, `FILE_TOO_LARGE`, `INVALID_FILE_UPLOAD`, `UNSUPPORTED_MEDIA_TYPE`, `STORAGE_DELETE_FAILED` (**500**). See [[media-storage-minio]].

## Questions (400), see [[question-validation]]
`INVALID_ITEM_CARDINALITY`, `MISSING_CONFIG_FIELD`, `ITEM_MISSING_IMAGE`, `ITEM_MISSING_TRANSLATION`, `ITEM_MISSING_AUDIO`, `BLANK_WORD_NOT_IN_SENTENCE`, `WORD_BLOCKS_MISSING_WORD`, `WORD_BLOCKS_NO_DISTRACTOR`.

Also on questions:
| code | When |
|---|---|
| `INVALID_QUESTION_TEXT` | `questionText` isn't a non-empty string (or `null` on PATCH), or is over 300 code points after trimming ([[adr-question-text]]) |
| `QUESTION_TYPE_IMMUTABLE` | PATCH sends a `type` different from the stored one |

The dashboard's `ApiError` carries `code` ([[api-client]]); the question form branches on `INVALID_QUESTION_TEXT`.

Back to [[backend-index]] · [[api-contract]].
