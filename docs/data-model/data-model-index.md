---
type: index
scope: cross-cutting
sources: [dsl-backend/src/models, dsl-backend/AGENTS.md, docs/assets/dsl_full_erd.html]
updated: 2026-10-16
---
# Data model

MongoDB via Mongoose, one file per model in `dsl-backend/src/models/`. The design started as a relational ERD (`docs/assets/dsl_full_erd.html`) and was translated using the rule in [[adr-embed-vs-reference]]: **embed what's always fetched together and bounded; reference what has its own lifecycle or is reused.**

## Collections (implemented)
| Note | Model | Embedded arrays |
|---|---|---|
| [[user]] | `User` | — |
| [[specialization]] | `Specialization` | — |
| [[course]] | `Course` | — |
| [[unit]] | `Unit` | `learningItems[]` (replaces the `unit_learning_items` junction) |
| [[media]] | `Media` | — |
| [[learning-item]] | `LearningItem` | `translations[]` |
| [[exercise]] | `Exercise` | — |
| [[question]] | `Question` | `items[]` (replaces `question_items`) |

Question payloads: [[question-types]]. Planned student-side collections: [[student-progress-planned]].

## References
```
Course.specializationId ─> Specialization
Course.thumbnailMediaId ─> Media          (no type check)
Unit.courseId           ─> Course
Unit.learningItems[].learningItemId ─> LearningItem
Exercise.unitId         ─> Unit
Question.exerciseId     ─> Exercise
Question.items[].learningItemId ─> LearningItem
LearningItem.imageMediaId / translations[].audioMediaId ─> Media
LearningItem.createdBy, Media.uploadedBy ─> User
```
Nothing is populated: the API always returns raw ObjectId strings, and clients fetch referenced documents separately. Integrity rules: [[delete-guards]].

## Shared field conventions
- `_id` is an ObjectId, sent as a 24-hex string. `__v` is present in responses (except on User).
- Language codes: 2 lowercase letters (`/^[a-z]{2}$/`), with no fixed list.
- `orderIndex` orders siblings. `Unit.learningItems[].order` and `Question.items[].displayOrder` order embedded entries.
- `timestamps: true` gives `createdAt`/`updatedAt`. Specialization and Media have `createdAt` only.

Back to [[00-index]].
