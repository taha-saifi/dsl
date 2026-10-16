---
type: contract
scope: cross-cutting
sources: [dsl-teacher-dashboard/src/components/media/MediaAttachField.tsx, dsl-teacher-dashboard/src/components/learningItems/LearningItemFormDialog.tsx, dsl-teacher-dashboard/src/components/learningItems/TranslationFormDialog.tsx, dsl-teacher-dashboard/src/lib/sentenceWords.ts, dsl-teacher-dashboard/src/lib/api.ts, dsl-teacher-dashboard/src/types/index.ts, dsl-backend/src/utils/requestValidation.ts, dsl-backend/src/services/questionValidation.service.ts, dsl-backend/src/models/User.ts, dsl-backend/src/services/resourceDependencies.service.ts, dsl-backend/src/controllers/media.controller.ts]
updated: 2026-10-16
---
# Known mismatches

Found during the 2026-10-16 audit. Remove an entry once it's fixed, in the same commit as the fix. Contract: [[api-contract]].

## A. Silent data loss (bugs)
1. **"Remove image" on a learning item does nothing.** `MediaAttachField` sets `undefined`, which isn't serialized, so the PATCH has no `imageMediaId` and the image stays. The backend accepts `null`. *Fix: the dashboard sends `null`.*
2. **"Remove audio" on a translation does nothing**, and the backend has no way to clear it (`getOptionalObjectId` rejects `null`). *Fix: both sides.*
3. **Optional text can't be cleared** (`iconUrl`, `description`, `pronunciation`, `ipa`). The dashboard sends `undefined` and the backend rejects `""`. *Fix: decide how clearing works (`null` or `""`), then update both sides and [[api-contract]].*
4. **Word splitting differs.** Backend `tokenizeWords` splits on any non-letter/digit. Dashboard `tokenize` splits on whitespace and trims punctuation from the ends. Words like "don't" or "well-known" lead to `BLANK_WORD_NOT_IN_SENTENCE` / `WORD_BLOCKS_MISSING_WORD`. See [[question-validation]].

## B. Type drift (`dsl-teacher-dashboard/src/types/index.ts` vs the models)
5. `User.firstName` / `lastName` are required in the dashboard but optional in the backend.
6. `LearningItem.imageMediaId` is `string | null` in the backend; the dashboard has `string | undefined`. `createdBy` is missing.
7. `Media` is missing `uploadedBy` and `storageKey`. `"video"` is in both enums but upload can never produce it.
8. No entity has `createdAt` / `updatedAt` in the dashboard types.

## C. Backend features with no dashboard support
9. `DELETE /media/:id` has no client function or UI, so media accumulates.
10. `Course.thumbnailMediaId` and `Specialization.slug` aren't editable. A rename keeps the old slug.
11. Moving a unit, exercise, or question to another parent is supported by PATCH but not exposed.

## D. Contract hazards (fix before `dsl-mobile` relies on them)
12. **Anyone who registers becomes a teacher** (`User.role` defaults to `"teacher"`). See [[auth-and-roles]].
13. The reorder bodies have three different shapes, and `order` vs `orderIndex` naming is mixed ([[api-contract]]).
14. Deleting a learning item doesn't check question references. Afterwards, editing the question fails with 404 ([[delete-guards]]).
15. Deleting media doesn't check references, which leaves broken URLs ([[media-storage-minio]]).
16. No publish cascade: a published parent can lose all its published children ([[publish-readiness]]).
17. Question PATCH re-validates everything, so a points-only edit can fail if a referenced item has changed since ([[question-validation]]).

Back to [[contracts-index]] · [[roadmap]].
