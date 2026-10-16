---
type: index
scope: dashboard
sources: [dsl-teacher-dashboard/src, dsl-teacher-dashboard/CLAUDE.md, dsl-teacher-dashboard/AGENTS.md]
updated: 2026-10-16
---
# Dashboard (`dsl-teacher-dashboard/`)

The teacher authoring web app. Package rules: `dsl-teacher-dashboard/CLAUDE.md` (which imports `AGENTS.md`). See [[conventions-index]].

## Layout (`dsl-teacher-dashboard/src/`)
| Path | Contents |
|---|---|
| `main.tsx`, `App.tsx` | React root; router and guards |
| `context/AuthContext.tsx` | token and current user ([[auth-and-roles]]) |
| `lib/api.ts` | `apiRequest`, `apiUpload`, `ApiError` ([[api-client]]) |
| `lib/resources/*.ts` | one typed module per backend resource |
| `lib/languages.ts`, `lib/sentenceWords.ts` | language picker list, word splitter |
| `lib/questionTypes.ts`, `lib/questionPreview.ts` | type labels/families; preview model derivation |
| `types/index.ts` | copies of the backend entity types ([[api-contract]]) |
| `pages/` | one component per route ([[routing-and-pages]]) |
| `components/<feature>/` | form dialogs, sortable rows, media and question widgets |
| `components/ui/` | shadcn-generated (base-ui): don't hand-edit |

## Notes
- [[routing-and-pages]]: route tree, guards, which page calls which endpoint
- [[api-client]]: fetch wrapper, resource modules, error handling
- [[state-and-forms]]: page state, dialogs, reorder, publish, media widgets
- [[question-builder]]: question list, type picker, the 8 question forms
- [[question-preview]]: the static student-app mock (live in the form, modal from the list)

Lint: `oxlint`. Path alias `@/` → `src/` (`vite.config.ts`, `tsconfig.app.json`). Back to [[00-index]].
