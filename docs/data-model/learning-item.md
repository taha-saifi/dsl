---
type: model
scope: backend
sources: [dsl-backend/src/models/LearningItem.ts, dsl-backend/src/controllers/learningItem.controller.ts]
updated: 2026-10-16
---
# LearningItem

`dsl-backend/src/models/LearningItem.ts`. A reusable vocabulary entry (word, phrase, or sentence) with one translation per language. It's the source of every correct answer ([[adr-answers-derived-not-stored]]).

| Field | Type | Notes |
|---|---|---|
| `createdBy` | ObjectId → [[user]] | set from `req.user` |
| `imageMediaId` | ObjectId → [[media]] \| **null** | default `null`; must be an image; PATCH `null` clears it |
| `type` | `"word" \| "phrase" \| "sentence"` | required |
| `translations` | `Translation[]` | embedded, default `[]` |
| `createdAt`, `updatedAt` | Date | |

## Translation (embedded, no `_id`)
| Field | Type | Notes |
|---|---|---|
| `language` | 2-letter | the key: **unique within the item** (pre-save hook gives `DUPLICATE_TRANSLATION_LANGUAGE`; the add endpoint gives `TRANSLATION_LANGUAGE_IN_USE`) |
| `text` | string | required |
| `pronunciation`, `ipa` | string? | can't be cleared once set |
| `audioMediaId` | ObjectId? → [[media]] | must be audio; **can't be cleared** |

- Translations are addressed by language: `/learning-items/:id/translations/:language`. The language can't be changed; delete the translation and add it again.
- Search: `?search=` is a case-insensitive regex (escaped) over any translation's text. `?type=` filters by type.
- Attached to units ([[unit]]) and referenced by questions ([[question]]).

Back to [[data-model-index]].
