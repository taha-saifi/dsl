---
type: roadmap
scope: mobile
sources: [docs/mobile/features/00-feature-catalog.md, docs/decisions/mobile-architecture.md]
updated: 2026-10-16
---
# Mobile roadmap (build order)

One slice at a time: **backend → dashboard → mobile → vault**, then the gates, then stop for the user's check. Features: [[00-feature-catalog]]. Architecture: [[mobile-architecture]]. 📜 = changes [[api-contract]] (and [[api-endpoints]] and [[error-codes]] in the same change).

**Standing gates for every slice**
- **Backend:** `npm run build`, then curl against the running stack (`docker compose up`) for every new route, covering the happy path, 400, 401 (no token), 403 (wrong role) and 404.
- **Dashboard** (when touched): `npm run lint && npm run build`, then a browser check of the changed page.
- **Mobile:**
  - `dart format --set-exit-if-changed .`
  - `flutter analyze` (0 issues)
  - `flutter test`
  - then a manual run on the emulator (`flutter run --dart-define-from-file=env/emulator.json`) against the docker stack
- **Vault:** listed notes updated with new `updated:` dates, and no broken wikilinks.

## Slice 0: scaffold ✅ done 2026-10-16
Not a feature; nothing in the API changes. **Gates passed on the emulator:** `/health` through `ApiClient` shows `ok` via `10.0.2.2`; with the API stopped the System check shows the error state and recovers on "Try again"; the design-system screen matches the DS boards (background verified `#1E1B4B`). `flutter analyze` 0 issues, 16 tests pass. Figma: 1 call (logo, cached as `docs/assets/mobile-screens/_logo.png`).
- **Mobile:**
  - Run `flutter doctor` (upgrade Flutter if needed), then `flutter create --org dev.ssuniverse --project-name dsl dsl-mobile`, which gives `applicationId dev.ssuniverse.dsl`. Set `minSdk 24` and portrait only.
  - Add the folder layout, `analysis_options.yaml`, and the dependencies from the ADR.
  - `core/config`: the `API_BASE_URL` env files, and a debug-only `network_security_config.xml`.
  - `core/api`: `ApiClient` (envelope unwrap, `ApiException`, the 401 rule) with unit tests.
  - `core/theme`: tokens as `ThemeExtension`s, bundled Inter, and the shared widgets: button, text field, progress bar, badge, card, and empty/loading/error states.
  - go_router shell with 5 tabs (Practice hidden).
  - Icon and splash from the Figma logo: **one Figma call**, cached under `docs/assets/mobile-screens/`.
- **Repo:**
  - `dsl-mobile/CLAUDE.md` (contents in the ADR).
  - `dsl-mobile/.gitignore`.
  - Root `CLAUDE.md` package table and commands.
  - Compose: `MINIO_PUBLIC_ENDPOINT: ${MINIO_PUBLIC_ENDPOINT:-http://localhost:9000}`.
- **Vault:** [[mobile-index]] (no longer "planned"), [[runtime-and-deployment]] (emulator and device URLs), [[conventions-index]] (link the new CLAUDE.md). Mark the ADR implemented.
- **Gates:** the app launches on the emulator. A debug "ping" calls `GET /health` through `ApiClient` and shows `ok`; with the API stopped it shows the error state, not a crash. The theme screen matches the Figma tokens.

## Slice 1: student accounts ✅ done 2026-10-16
**Gates passed.**
- curl, 25/25: register → student, `termsAcceptedAt` set; a 7-character password, a missing name or a bad email → 400; duplicate → 409; `role` in the body is ignored; a student calling `POST /courses` or `/admin/users` → 403; a teacher calling `/admin/users` → 403; no token → 401; an admin creates a teacher, who can then sign in; the admin resets that password → the old one fails with 401 and the new one works; reset of an unknown id → 404 `USER_NOT_FOUND`.
- Browser: the admin sees Users and adds a teacher (duplicate email shows the server message); after a reset the old password is refused; the new teacher signs in, has no Users link, and `/users` sends them to `/`.
- Emulator: Sign Up validation (short password, mismatch, terms) → account created (`role: student` in Mongo) → Home "Hi, Amina". After killing and reopening the app the student is still signed in. With the API stopped: a retry screen and still signed in; "Try again" recovers once the API is back. Profile → Log out → Welcome. A wrong password shows "Invalid credentials."; a teacher sees "This app is for students". A token signed with another secret → Sign In with "Your session has ended".
- `flutter analyze` 0 issues; 50 tests pass. Figma: 1 call (Splash `55:5`, cached as `auth_splash.png`).
- Bug found on the device and fixed: the keyboard's Next on Password focused the eye toggle instead of Confirm.

## Slice 2: onboarding ✅ done 2026-10-16
**Gates passed.**
- curl, 23/23: `PATCH /auth/me` saves all five preferences; it rejects a bad goal, level, daily target (including `"10"` as a string) and language code (400), an unknown specialization (404 `SPECIALIZATION_NOT_FOUND`), unknown keys and a non-object (400). A rejected PATCH changes nothing; `null` clears a key; `role` in the body is ignored; teacher → 403, no token → 401. `/learn/specializations` lists only domains with published courses; `/learn/languages` counts per domain (a drafts-only domain gives `[]`; an unknown id → 404, a bad id → 400).
- Emulator: a new sign-up goes straight to Step 1; Continue and Get Started stay disabled until there's a choice; saved preferences match in Mongo. After a restart the student lands on Home (no onboarding again) and Profile lists the choices. An existing student without preferences is sent to onboarding at sign-in; Log out on Step 1 works.
- 66 tests pass (Back keeps the choice, empty catalog can be skipped, load error has a retry, save error is shown). Figma: 1 call (Choose Domain `57:5`, `onboarding_domain.png`).
- Moved to Slice 4: "choices preselect the catalog filters" (no catalog yet).
- Fixed while building: grid cards with a fixed height overflowed with large text (now sized to their content); the save error appeared below the fold (now above the button).
- Brought forward from Slice 3: `GET /learn/specializations` (see [[feat-onboarding-and-preferences]]).

## MVP slices
| # | Slice | 📜 | Backend | Dashboard | Mobile |
|---|---|---|---|---|---|
| 1 ✅ | [[feat-student-accounts]] | 📜 | register → student; password ≥ 8; `termsAcceptedAt`; `/admin/users` (create teacher/admin, list, reset password); admin seed script | admin-only Users page and nav entry | Splash, Login, Sign Up, secure token, `/auth/me` bootstrap, logout, "students only" screen |
| 2 ✅ | [[feat-onboarding-and-preferences]] | 📜 | `PATCH /auth/me` with `preferences`; `GET /learn/languages` | — | Domain → Language → Profile Setup; router redirect while preferences are unset |
| 3 | [[feat-published-content-api]] | 📜 | `/api/learn` router (specializations, courses, course, unit); fully-published filter; media URLs built from `storageKey`; authoring GETs teacher-only | — | repositories and models only (fixture tests) |
| 4 | [[feat-catalog-and-enrollment]] | 📜 | `enrollments` model and index; enroll, unenroll, `GET /learn/me/courses`; `isEnrolled` | — | Catalog (search, domain chips), Course Details, Home (My Courses, Continue) |
| 5 | [[feat-unit-and-exercise-overview]] | 📜 | `questionCount`, `questionTypes` on unit exercises | — | Unit Details, Exercise Intro (type mix chips) |
| 6 | [[feat-exercise-player]] | 📜 | play-payload service (derivation moved from the dashboard's `questionPreview.ts`); `GET /learn/exercises/:id/play` | optional: no change | question shell, 8 renderers, audio, Pause |
| 7 | [[feat-answer-checking-and-sessions]] | 📜 | `exerciseSessions` model; start, answer, complete, abandon; checking service with `correct`/`almost`/`wrong`; new error codes | — | Check → feedback sheet, Try Again / Skip, Exercise Complete (score, accuracy, time) |
| 8 | [[feat-learning-progress]] | 📜 | progress, `nextExerciseId`, per-exercise status and best score, computed from sessions | — | progress bars and rings, Done badges, Continue targets |
| 9 | [[feat-static-screens]] | — | — | — | static Certificates, Leaderboard, achievements, Settings rows; real Profile header and logout |

### Vault notes per slice
- **1:** [[auth-and-roles]], [[user]], [[api-contract]], [[api-endpoints]], [[error-codes]]. Deleted the old known-mismatch entry for the teacher default. Also [[routing-and-pages]] (Users page).
- **2:** [[user]] (preferences), contract, endpoints.
- **3:** contract, endpoints, [[publish-readiness]] (the student filter), [[media-storage-minio]] (response-time URLs), [[backend-capability-map]].
- **4:** contract, endpoints, [[student-progress-planned]] (enrollments now built; split out an `enrollment` model note).
- **5:** contract, endpoints.
- **6:** contract, endpoints, [[question-types]] (derivation now in a backend service), [[question-preview]] (note the shared logic).
- **7:** contract, endpoints, error codes, [[question-types]] (comparison rule), a new `exercise-session` model note, and a new ADR for the answer-normalization rule.
- **8:** contract, endpoints, [[student-progress-planned]].
- **9:** [[mobile-index]] only.

### Gates per slice (on top of the standing gates)
1. **Accounts.**
   - curl: register → `role:"student"`; a 7-character password → 400; a student calling `POST /courses` → 403.
   - Admin creates a teacher → that teacher logs into the dashboard. Admin resets a password → the old password fails. A teacher calling `/admin/users` → 403.
   - Browser: the Users page appears for an admin and is hidden for a teacher.
   - Emulator: sign up, kill the app and reopen (still signed in), log out. With the API stopped, the app shows a retry and is **not** logged out. A tampered token → back to Login.
2. **Onboarding.**
   - curl: `PATCH /auth/me` rejects a bad enum and an unknown specialization.
   - Emulator: a new student is forced through onboarding once; the choices survive a restart and preselect the catalog filters.
3. **Published content.**
   - curl, with a seeded mix of drafts, an empty published unit and a fully published chain: only the full chain appears; a draft id → 404; a student calling `GET /learning-items` → 403.
   - Media URLs use the current `MINIO_PUBLIC_ENDPOINT`.
4. **Catalog and enrollment.**
   - curl: enroll twice → one document; enrolling in a draft → 404.
   - Emulator: the onboarding domain and language preselect the catalog filters (moved from Slice 2).
   - Emulator: search and chips filter; Enroll → the course appears on Home.
5. **Unit overview.**
   - curl: the counts and type list match the seeded exercise.
   - Emulator: the Intro shows the type mix.
6. **Player.**
   - curl: **the play payload contains no answer material** (script check: no target translation text for typing, no blank word, nothing marking the correct option); the order differs between two calls.
   - Emulator: the seeded 8-type exercise renders every type with image and audio (on the emulator via `10.0.2.2`, and on one physical device via the LAN IP).
7. **Checking and sessions.**
   - curl, per type: right → `correct`, an accent-only miss → `almost`, wrong → `wrong` with `correctAnswer`; answering after complete → 409; another student's session → 404.
   - Mongo: attempts are stored, with score from first attempts only.
   - Emulator: play all 8 types through to the results screen; Quit abandons the session.
8. **Progress.**
   - curl: % moves after a completion; replaying keeps the best score; unpublishing an exercise changes the totals.
   - Emulator: the bars update after finishing an exercise, and Continue opens the next one.
9. **Static screens.**
   - Emulator: every tab opens with no network calls (checked in the dio log) and a visible "Coming soon".

## Later slices (same template, in this order)
| Slice | 📜 | Dashboard work |
|---|---|---|
| [[feat-content-locking]] | 📜 | unit form: prerequisite multi-select; delete guard |
| [[feat-course-metadata]] | 📜 | course `level`, exercise `difficulty` inputs |
| [[feat-item-definitions-and-flashcards]] | 📜 | definition and example per translation; MC and matching definition-mode toggle and preview |
| [[feat-xp-and-levels]] | 📜 | — (confirm the level thresholds first) |
| [[feat-hearts]] | 📜 | — |
| [[feat-streaks-and-daily-goal]] | 📜 | — |
| [[feat-unit-and-course-completion]] | 📜 | — |
| [[feat-teacher-student-insights]] | 📜 | course Stats panel; per-question accuracy |
| [[feat-profile-and-settings]], [[feat-achievements]], [[feat-certificates]], [[feat-leaderboard]] | 📜 | — (these replace the static screens) |
| [[feat-google-sign-in]], [[feat-password-reset]] | 📜 | blocked: test Google account, email provider |

Each later slice gets its gate list written when it's picked up, using the same pattern.

Back to [[mobile-index]] · project roadmap: [[roadmap]].
