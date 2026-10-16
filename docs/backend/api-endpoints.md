---
type: component
scope: backend
sources: [dsl-backend/src/app.ts, dsl-backend/src/routes/auth.routes.ts, dsl-backend/src/routes/adminUsers.routes.ts, dsl-backend/src/routes/learn.routes.ts, dsl-backend/src/routes/specializations.routes.ts, dsl-backend/src/routes/courses.routes.ts, dsl-backend/src/routes/units.routes.ts, dsl-backend/src/routes/media.routes.ts, dsl-backend/src/routes/learningItem.routes.ts, dsl-backend/src/routes/exercise.routes.ts, dsl-backend/src/routes/question.routes.ts, dsl-backend/src/routes/health.routes.ts]
updated: 2026-10-16
---
# API endpoints

Base path `/api`. Roles: **P** = public, **R** = any authenticated user, **T** = teacher or admin, **S** = student only, **A** = admin only ([[auth-and-roles]]). Every success response is `{data: …}`. **Deletes return 200 `{data:{id}}`**, not 204. Body shapes are defined in [[api-contract]].

| Method | Path | Role | Body / query | Success |
|---|---|---|---|---|
| GET | `/health` | P | — | 200 `{status:"ok"}` |
| POST | `/auth/register` | P | `{email,password (≥8),firstName,lastName,acceptedTerms?}`, always creates a **student** | 201 `{token,user}` |
| POST | `/auth/login` | P | `{email,password}` | 200 `{token,user}` |
| GET | `/auth/me` | R | — | 200 `User` |
| PATCH | `/auth/me` | S | `{firstName?,lastName?,preferences?:{specializationId?,targetLanguage?,goal?,dailyTargetMinutes?,experienceLevel?}}` (`null` clears a preference) | 200 `User` |
| GET | `/learn/specializations` | R | — (domains with ≥1 published course, by name) | 200 `SpecializationSummary[]` |
| GET | `/learn/languages` | R | `?specializationId` (404 if unknown) | 200 `LanguageSummary[]` (most courses first) |
| GET | `/learn/courses` | R | `?specializationId`, `?targetLanguage` (2-letter), `?search` (case-insensitive, literal, ≤100 chars); newest first | 200 `CourseSummary[]` |
| GET | `/learn/courses/:id` | R | — (404 `COURSE_NOT_FOUND` unless visible) | 200 `CourseDetail` |
| GET | `/learn/units/:id` | R | — (404 `UNIT_NOT_FOUND` unless visible) | 200 `UnitDetail` |
| GET | `/admin/users` | A | `?role=teacher,admin` (comma list; omitted = every role; newest first) | 200 `User[]` |
| POST | `/admin/users` | A | `{email,password (≥8),firstName,lastName,role:"teacher"\|"admin"}` | 201 `User` |
| PATCH | `/admin/users/:id/password` | A | `{password (≥8)}` | 200 `User` |
| GET | `/specializations` | T | — (sorted by name) | 200 `Specialization[]` |
| GET | `/specializations/:id` | T | — | 200 |
| POST | `/specializations` | T | `{name, slug?, iconUrl?}` | 201 |
| PATCH | `/specializations/:id` | T | `{name?, slug?, iconUrl?}` | 200 |
| DELETE | `/specializations/:id` | T | — | 200 |
| GET | `/courses` | T | `?specializationId` (newest first) | 200 `Course[]` |
| GET / PATCH / DELETE | `/courses/:id` | T | PATCH: any course field incl. `isPublished` | 200 |
| POST | `/courses` | T | `{specializationId,name,sourceLanguage,targetLanguage,description?,thumbnailMediaId?,isPublished?}` | 201 |
| GET | `/units` | T | `?courseId` (by `orderIndex`) | 200 `Unit[]` |
| GET / PATCH / DELETE | `/units/:id` | T | PATCH: `{courseId?,name?,orderIndex?,isPublished?}` | 200 |
| POST | `/units` | T | `{courseId,name,orderIndex,isPublished?}` | 201 |
| PATCH | `/units/reorder` | T | `{courseId, units:[{id,orderIndex}]}` | 200 `Unit[]` of the course |
| POST | `/units/:id/learning-items` | T | `{learningItemId, order}` | **201** `Unit` |
| PATCH | `/units/:id/learning-items/reorder` | T | `[{learningItemId, order}]`, must list **every** attached item | 200 `Unit` |
| DELETE | `/units/:id/learning-items/:learningItemId` | T | — (idempotent) | 200 `Unit` |
| GET | `/media` | T | `?type=image\|audio\|video` (newest first) | 200 `Media[]` |
| POST | `/media/upload` | T | multipart, field `file` | 201 `Media` |
| GET / DELETE | `/media/:id` | T | — | 200 |
| GET | `/learning-items` | T | `?type`, `?search` (case-insensitive regex on `translations.text`) | 200 newest first |
| POST | `/learning-items` | T | `{type, imageMediaId?, translations?[]}` | 201 |
| GET / PATCH / DELETE | `/learning-items/:id` | T | PATCH: `{type?, imageMediaId? (null clears)}` | 200 |
| POST | `/learning-items/:id/translations` | T | `Translation` | **201** `LearningItem` |
| PATCH / DELETE | `/learning-items/:id/translations/:language` | T | PATCH: `{text?,pronunciation?,ipa?,audioMediaId?}` | 200 `LearningItem` |
| GET | `/exercises` | T | `?unitId` (by `orderIndex`) | 200 |
| GET / PATCH / DELETE | `/exercises/:id` | T | PATCH: `{unitId?,name?,orderIndex?,isPublished?}` | 200 |
| POST | `/exercises` | T | `{unitId,name,orderIndex,isPublished?}` | 201 |
| PATCH | `/exercises/reorder` | T | `[{id,orderIndex}]`, all in one unit | 200 `Exercise[]` of that unit |
| GET | `/questions` | T | `?exerciseId` (by `orderIndex`) | 200 |
| GET | `/questions/text-defaults` | T | — | 200 `{maxLength, defaults: {<type>: text}}` |
| GET / PATCH / DELETE | `/questions/:id` | T | PATCH: `{exerciseId?,type? (must equal current),orderIndex?,points?,config?,items?,questionText? (null clears)}` | 200 |
| POST | `/questions` | T | `{exerciseId,type,orderIndex,points?,config,items,questionText?}` | 201 |
| PATCH | `/questions/reorder` | T | `[{id,orderIndex}]`, all in one exercise | 200 `Question[]` of that exercise |

Route order matters: `/reorder` (and `/questions/text-defaults`) are registered before `/:id` in the unit, exercise, and question routers.

Every question response includes `displayText` (a virtual: `questionText` or the type's default), see [[adr-question-text]].

**Since Slice 3 every authoring route, GETs included, is teacher/admin only**; students read published content through `/api/learn`, which shows only content published all the way down ([[publish-readiness]]). Not implemented yet: progress, sessions, enrollment. See [[student-progress-planned]] and [[mobile-index]].

Errors: [[error-codes]]. Related: [[routing-and-pages]] (which page calls what). Back to [[backend-index]].
