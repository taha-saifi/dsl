---
type: reference
scope: mobile
sources: [dsl-backend/src/app.ts, dsl-backend/src/routes, dsl-backend/src/middleware/role.middleware.ts, dsl-backend/src/models/User.ts, dsl-backend/src/controllers/auth.controller.ts, dsl-backend/src/controllers/media.controller.ts, dsl-backend/src/services/resourceDependencies.service.ts]
updated: 2026-10-16
---
# Backend capability map (for the student app)

What the API gives a student today, checked against the code on 2026-10-16. Screens are from [[figma-screen-inventory]]; routes from [[api-endpoints]].

## Endpoints
**Access today:** R = any logged-in role (students included), T = teacher/admin, P = public. A logged-in student can already read **everything**, including drafts.

| Endpoint | Today | For students |
|---|---|---|
| `GET /health` | P | ✅ as-is |
| `POST /auth/login`, `GET /auth/me` | P / R | ✅ as-is |
| `POST /auth/register` | P | ✅ creates a **student**, password ≥ 8, names required (Slice 1) |
| `/admin/users` | A | admin-only staff accounts and password resets (Slice 1) |
| `PATCH /auth/me`, `GET /learn/specializations`, `GET /learn/languages` | S / R / R | ✅ onboarding (Slice 2) |
| `GET /specializations`, `/:id` | R | ✅ mostly (domain list); 🔶 needs published course counts for Domain/Language cards |
| `GET /courses`, `/:id` | R | 🔶 needs a student variant: published only, plus enrollment and progress |
| `GET /units`, `/:id` | R | 🔶 published only, plus progress and lock state; `learningItems[]` is teacher data |
| `GET /exercises`, `/:id` | R | 🔶 published only, plus progress and lock state |
| `GET /questions?exerciseId=`, `/:id` | R | 🔶 must check that the parent exercise is published; N+1 to play (see below) |
| `GET /questions/text-defaults` | R | not needed (`displayText` is on every question) |
| `GET /learning-items/:id` | R | 🔶 works, but leaks unpublished items; better bundled with the exercise |
| `GET /learning-items` (search), `GET /media` (list) | R | ⛔ teacher tools; students should get 403 or never call them |
| `GET /media/:id` | R | ✅ but the `url` host is wrong for phones (below) |
| All POST/PATCH/DELETE, reorder, attach/detach, upload | T | ⛔ teacher/admin only; students correctly get 403 `FORBIDDEN_ROLE` |

There is no CORS concern: a native Android client isn't subject to it (`cors({origin: FRONTEND_URL})` only affects browsers).

## Learner capabilities
Only what a Figma screen or the existing model calls for.

| Capability | Needed by | Status today |
|---|---|---|
| Student accounts and role | Sign Up `55:68` | ✅ built in Slice 1 ([[auth-and-roles]]) |
| Google sign-in | Login `55:40` | ❌ designed in `AGENTS.md`, not built |
| Forgot password | Login | ❌ none |
| Onboarding profile: domain, language, goal, daily target, level | `57:5` `57:73` `57:132`, Settings | ✅ `User.preferences` (Slice 2); editing from Settings comes later |
| Enrollment | Catalog "Enroll Now", Home "My Courses" | 📐 designed only (`enrollments`, [[student-progress-planned]]) |
| Progress per course/unit/exercise (% and n/m) | Home, `87:5`, `87:104`, Certificates | 📐 `unitProgress` and `exerciseSessions` designed; no course-level rollup rule |
| Locking / unlock order | `87:5` units, `87:104` exercises | 📐 `unitProgress.isUnlocked` designed; no rule for exercise locks |
| Answer submission + **server-side checking** | Correct/Wrong `87:218` `87:262`, all question frames | ❌ nothing; answers are derived from translations, never stored ([[adr-answers-derived-not-stored]]), so checking must be a backend service ([[adr-business-logic-backend-only]]); comparison rules are undecided ([[question-types]]) |
| Exercise session (start, attempts, finish, quit resets) | Pause `113:90`, Exercise Complete `6:107` | 📐 `exerciseSessions` with embedded `attempts[]` designed |
| Score, accuracy, time | `6:107`, `111:5` | 📐 `accuracy` designed; time is derivable from `startedAt`/`completedAt` |
| XP (per exercise, total, per unit "+560 XP") | Home, cards, results | 📐 `totalXp`, `xpEarned` designed; ❌ no XP rule; per-question `points` exists |
| Levels (Beginner → Advanced, "progress to next level") | `6:107`, Profile | ❌ no thresholds; also overlaps the onboarding "experience level" |
| Hearts (5, −1 on wrong, timed refill) | Lesson top bar, `87:262`, `113:5` | 📐 `hearts` designed; ❌ no loss/refill rule; ads/premium are out of scope |
| Streaks | Home, Profile | 📐 `currentStreak`, `longestStreak`, `lastActivityDate` designed; ❌ no rule (timezone!) |
| Daily target / "today's practice" | Home, Profile Setup | ❌ none |
| Achievements | Home, Profile, Unit Complete | ❌ not even designed |
| Certificates (number, verify URL) | `111:52` `111:98` `111:163` | ❌ not designed |
| Leaderboard (weekly/monthly, rank, percentile) | `111:213`, Home | ❌ not designed; needs XP history by period, not just `totalXp` |
| Flashcards (definition, example, IPA, audio) | `112:424` `113:48` | 🔶 `ipa`, `pronunciation`, `audioMediaId` exist on `Translation`; ❌ no definition or example (decided: add an optional definition, [[feat-item-definitions-and-flashcards]]) |
| Audio for listening types | `5:121`, flashcards | 🔶 `Translation.audioMediaId` → `Media.url`; ⚠️ URL is built from `MINIO_PUBLIC_ENDPOINT` (`localhost` in compose), which an emulator or phone can't reach ([[media-storage-minio]]) |
| Published-only content | everything | ❌ no list filters `isPublished`; ⚠️ no cascade, so a published unit can hold zero published exercises ([[publish-readiness]]) |
| Course/unit/exercise card metadata (subtitle, level, duration, difficulty, XP, unit description) | `62:5` `87:5` `87:104` `112:370` | 🔶 `Course.description` and `Specialization.iconUrl` only; the rest is missing or derivable (unit count, question count) |
| Course search, domain filter, language filter | `62:5`, `57:73` | 🔶 `?specializationId` only; no search; no published counts per language |
| One-request exercise payload | every lesson | ❌ N+1 today: questions → learning items → media |

Legend: ✅ works · 🔶 partial · 📐 designed in [[student-progress-planned]], not built · ❌ missing.

**Deliberately omitted** (no screen calls for it): spaced repetition and review queues, notifications backend, subscriptions and ads, teacher-facing analytics. The "Practice" tab has no frame either.

Back to [[mobile-index]].
