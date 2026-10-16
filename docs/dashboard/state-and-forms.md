---
type: component
scope: dashboard
sources: [dsl-teacher-dashboard/src/pages/UnitsPage.tsx, dsl-teacher-dashboard/src/pages/UnitDetailPage.tsx, dsl-teacher-dashboard/src/pages/LearningItemsPage.tsx, dsl-teacher-dashboard/src/components/PublishToggle.tsx, dsl-teacher-dashboard/src/components/media/MediaPicker.tsx, dsl-teacher-dashboard/src/components/media/MediaAttachField.tsx, dsl-teacher-dashboard/src/components/courses/CourseFormDialog.tsx, dsl-teacher-dashboard/src/components/ui/toast.tsx, dsl-teacher-dashboard/src/lib/languages.ts]
updated: 2026-10-16
---
# State and forms

There's no global store or data-fetching library. Each page holds its own `useState`. The only shared state is `AuthContext` ([[auth-and-roles]]).

## Page pattern
- `status: "loading" | "ready" | "error" | "not-found"`. A 404 `ApiError` becomes `not-found`. The error state has a Retry button.
- `fetchData()` runs in `useEffect` on route param change, often as `Promise.all` over parent and children.
- Results from create/edit dialogs are merged into local lists (`onSaved`), sorted by `orderIndex`.
- Deletes go through a shadcn `AlertDialog`. On failure the dialog closes and the backend's message (e.g. the 409 [[delete-guards]] text) is shown verbatim in a toast (`components/ui/toast.tsx`, the base-ui toast manager).

## Form dialogs (`components/<feature>/*FormDialog.tsx`)
- One dialog handles both create and edit (`isEdit = Boolean(entity)`). State is reset every time `open` turns true.
- Only UX-level checks happen client-side (e.g. "Select a source language"); everything else comes back from the API and the message is shown inline in the dialog.
- New siblings get `orderIndex = max(existing) + 1`, or 0 when there are none.
- Languages: `LanguageSelect` over the 33 codes in `lib/languages.ts`. The backend accepts any 2-letter code.

## Drag-and-drop reorder (dnd-kit)
Optimistic: `arrayMove` → renumber 0..n → set state → call reorder → replace with the server's list. **On failure, roll back** and show a toast. Used for units, exercises, questions, and unit learning items. Body shapes differ per endpoint ([[api-contract]]).

## Publish (`components/PublishToggle.tsx`)
Badge plus button. **Not optimistic**: the parent sends PATCH `{isPublished: !current}` and re-renders only after success. A 409 gating error is shown in a toast. See [[publish-readiness]] and [[adr-non-optimistic-publish]].

## Media widgets
- `MediaPicker`: modal that lists `GET /media?type=` and uploads with a file input. Its allowed MIME types match the backend allowlist ([[media-storage-minio]]).
- `MediaAttachField`: shows the selected image or audio (fetched with `getMedia`), with Change/Remove buttons. **Remove sets `undefined`, which isn't sent to the server, so the saved media is kept** ([[known-mismatches]]).

Question forms: [[question-builder]]. Back to [[dashboard-index]].
