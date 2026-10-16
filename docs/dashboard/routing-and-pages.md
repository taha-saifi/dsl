---
type: component
scope: dashboard
sources: [dsl-teacher-dashboard/src/App.tsx, dsl-teacher-dashboard/src/components/layout/AppShell.tsx, dsl-teacher-dashboard/src/components/ProtectedRoute.tsx, dsl-teacher-dashboard/src/components/RequireTeacherRole.tsx, dsl-teacher-dashboard/src/components/RequireAdminRole.tsx, dsl-teacher-dashboard/src/pages]
updated: 2026-10-16
---
# Routing and pages

`BrowserRouter` lives in `dsl-teacher-dashboard/src/App.tsx`. nginx sends unknown paths to `index.html` ([[runtime-and-deployment]]).

```
/login                       RedirectIfAuthenticated > LoginPage
<ProtectedRoute>             no user → /login (token + connectionError → render anyway)
  <RequireTeacherRole>       student → "teachers only" + Logout
    <AppShell>               sidebar: Dashboard · Specializations · Learning Items (+ Users for admins); topbar: email + Logout
      /                                   DashboardHomePage
      /specializations                    SpecializationsPage
      /specializations/:specializationId/courses   CoursesPage
      /courses/:courseId/units            UnitsPage
      /units/:unitId                      UnitDetailPage
      /learning-items                     LearningItemsPage
      /learning-items/:learningItemId     LearningItemDetailPage
      /exercises/:exerciseId              ExerciseDetailPage
      <RequireAdminRole>                  not admin → /
        /users                            UsersPage
```
There's no catch-all 404 route. Users navigate down the hierarchy; detail pages fetch their parents for breadcrumbs.

## Page → endpoints
| Page / component | Calls |
|---|---|
| LoginPage (via AuthContext) | `POST /auth/login`, `GET /auth/me` |
| DashboardHomePage | GET `/specializations`, `/courses`, `/units`, `/exercises` (unfiltered, for counts) |
| SpecializationsPage + SpecializationFormDialog | list, create, update, delete specializations |
| CoursesPage + CourseFormDialog | `GET /specializations/:id`, list by `?specializationId`, create, update (incl. publish), delete |
| UnitsPage + UnitFormDialog | `GET /courses/:id`, list by `?courseId`, create, update, publish, delete, `PATCH /units/reorder` |
| UnitDetailPage | `GET /units/:id`, `GET /courses/:id`, exercises by `?unitId`; attach, detach, and reorder learning items; exercise create/update/publish/delete/reorder; `GET /learning-items/:id` and `GET /media/:id` per attached item |
| LearningItemsPage + LearningItemFormDialog | list (`?type`, debounced `?search`), create, update, delete, `GET /media/:id` per thumbnail |
| LearningItemDetailPage + TranslationFormDialog | `GET /learning-items/:id`, add, update, and remove translations, delete item, `GET /media/:id` |
| ExerciseDetailPage + QuestionFormDialog | `GET /exercises/:id` → unit → course; questions by `?exerciseId`; create, update, delete, reorder; exercise publish/delete; `GET /learning-items/:id` |
| UsersPage + StaffUserFormDialog + ResetPasswordDialog (admin) | `GET /admin/users?role=`, `POST /admin/users`, `PATCH /admin/users/:id/password` |
| MediaPicker / MediaAttachField | `GET /media?type`, `POST /media/upload`, `GET /media/:id` |
| AttachLearningItemDialog (also used by TargetItemField) | `GET /learning-items`, `GET /media/:id` |

Never called: `POST /auth/register`, `DELETE /media/:id`, `GET /questions/:id` (`getQuestion` exists but is unused), `GET /health`.

> [!note] Fetch per item
> Thumbnails and item labels are fetched one request per id (`getMedia`, `getLearningItem` in loops) because the API never populates references. See [[api-contract]].

Full endpoint list: [[api-endpoints]]. Back to [[dashboard-index]].
