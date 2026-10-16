---
type: component
scope: dashboard
sources: [dsl-teacher-dashboard/src/components/questions/preview/QuestionPreview.tsx, dsl-teacher-dashboard/src/components/questions/preview/usePreviewSources.ts, dsl-teacher-dashboard/src/components/questions/preview/ShowAnswerToggle.tsx, dsl-teacher-dashboard/src/components/questions/QuestionPreviewDialog.tsx, dsl-teacher-dashboard/src/lib/questionPreview.ts]
updated: 2026-10-16
---
# Question preview (student mock)

A static iPhone 15 Pro mock (393×852 screen, CSS-scaled) showing a question the way the student app will. It follows the cached Figma screens in [[figma-question-screens]].

## Where it appears
- **Question form**: live, right-hand column (stacks under the form below `lg`). Re-renders on every keystroke and every item/config change.
- **Questions list**: the row's **Preview** action opens `QuestionPreviewDialog`, which steps through the exercise (buttons or ←/→) and links to Edit.
- Both have a **Show answer** switch that renders the solved state.

## Layers
1. `lib/questionPreview.ts` → `buildPreviewModel(input)`: pure. Derives prompts, options and answers from learning-item translations exactly as [[question-types]] → "How a client derives the answer" describes. Unknown pieces become `null`. Options/word banks/matching columns use a **stable pseudo-shuffle** keyed on ids, so nothing jumps while typing.
2. `preview/usePreviewSources.ts`: fetches the referenced learning items and their images through a page-lifetime promise cache (`primeLearningItem` seeds it from pickers; `resetPreviewCache` runs when `ExerciseDetailPage` mounts).
3. `preview/QuestionPreview.tsx`: renders the model. **Props only**: no inputs, handlers or state.

## Static and isolated
- The mock has `aria-hidden`, `inert` and `pointer-events: none`. A visible "Preview" caption (plus an sr-only summary with the question text) stands in for it.
- Mobile tokens (`--mp-*`, from Figma) are set **inline on the mock's root** and consumed with Tailwind `bg-(--mp-…)` utilities, so they can't reach the dashboard theme. Inter is loaded via `@fontsource-variable/inter` and only used inside the mock.
- No backend preview endpoint was needed: everything is derivable from data the dashboard already loads.

## Per-type notes
- Missing data shows a dashed placeholder inside the mock ("Add a target and distractors", "Missing translation").
- `typing` and `listening_select` have no Figma frame; they reuse the typing-input and option-list patterns of their siblings.
- `fill_blank` shows the sentence with a blank plus a typing input. The Figma frame shows four word choices, but the data model has no distractors for `fill_blank` (see [[figma-question-screens]]).

> [!todo] Unverified: the real app's option order (shuffle rule) and answer comparison aren't decided ([[mobile-index]]). The preview's order is illustrative only.

Back to [[dashboard-index]] · [[question-builder]].

> [!note] Student side
> The mobile app never derives answers: the backend builds its play payload (`dsl-backend/src/services/playPayload.service.ts`) with the same rules as `questionPreview.ts`. Keep the two in step until the preview is moved onto the backend service ([[feat-exercise-player]]).
