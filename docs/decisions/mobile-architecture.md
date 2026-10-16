---
type: decision
scope: mobile
sources: [docs/mobile/features/00-feature-catalog.md, docs/mobile/figma-question-screens.md, dsl-teacher-dashboard/src/lib/api.ts, docker-compose.yml, dsl-backend/src/controllers/media.controller.ts]
updated: 2026-10-16
---
# ADR: `dsl-mobile/` architecture

Status: **accepted 2026-10-16** (application id `dev.ssuniverse.dsl`, Riverpod). Toolchain on the dev machine: Flutter 3.41.7 stable, Dart 3.11.5, JDK 21. Target: Android only. Features: [[00-feature-catalog]].

## Decisions
| Area | Choice | Rejected | Why |
|---|---|---|---|
| Structure | **Feature-first**: `lib/features/<feature>/{data,presentation}`, plus `lib/core/{api,auth,config,router,storage,theme,widgets}` | Layer-first (`lib/models`, `lib/screens`…) | Matches the vertical slices: one slice touches one folder. No separate `domain/` layer: the backend owns the business logic ([[adr-business-logic-backend-only]]), so the app is mostly fetch-and-render. |
| State | **Riverpod 3** (`flutter_riverpod`, hand-written providers; `AsyncNotifier` for screens with actions) | Bloc | Less code per screen, built-in async loading/error states, and easy overrides in tests. Bloc's events/states add ceremony to an app that's mostly reads. |
| Routing | **go_router**, `StatefulShellRoute` for the bottom nav, and one `redirect` that sends signed-out users to auth and students with no preferences to onboarding | auto_route; raw Navigator | First-party (flutter.dev), declarative, and the redirect gives one place for the auth and onboarding guards. auto_route needs codegen for little gain. |
| HTTP | **dio**, one `ApiClient` that unwraps `{data}`, maps `{error:{code,message}}` to `ApiException(status, code, message)`, and attaches `Authorization: Bearer` from an interceptor | `http` package | Interceptors, timeouts and cancellation. The error model mirrors the dashboard's `ApiError` ([[api-client]]). |
| 401 policy | **Only a real HTTP 401 from the API logs out** (clears the token and redirects to login). Timeouts, no connection and 5xx keep the session and show a retryable error. 403 shows the server message. | Logging out on any failure | Same rule as the dashboard ([[auth-and-roles]]). Tokens last 7 days with no refresh endpoint, so a 401 means "sign in again". |
| JSON models | **freezed + json_serializable** (build_runner); sealed unions for the per-type play payload and the answer body | Hand-written `fromJson` | 8 question payloads × 8 answer shapes is where a typo hides. Generated `==`/`copyWith` also help Riverpod. Generated files are committed (see CLAUDE.md below). |
| Secure storage | **flutter_secure_storage** for the JWT only | shared_preferences for the token | Uses the Android Keystore. Non-secret UI flags go in `shared_preferences`. |
| Local cache | **None in the MVP**: in-memory Riverpod caches (`keepAlive` for catalog and course), plus `cached_network_image` for images | drift/Isar/Hive | All grading is server-side, so a lesson can't work offline anyway. A database would add migrations with no user value yet. |
| Offline | **Online-only MVP.** Every screen has loading, error and retry states (Figma DS `52:473`, `52:495`). A failed answer submit keeps the answer on screen and offers retry. | Offline queue of attempts | Hearts, XP and locks are decided by the server; offline play would need conflict rules nobody has asked for. |
| Design system | `AppColors` and `AppTypography` as **`ThemeExtension`s** plus a light `ThemeData` (`ColorScheme.fromSeed` overridden with the exact Figma tokens). Inter is **bundled as a font asset** (OFL) rather than fetched at runtime. Shared widgets in `core/widgets`: `DslButton`, `DslTextField`, `DslProgressBar`, `DslBadge`, `DslCard`, the empty/loading/error states. The question shell and the **8 renderers** live in `features/player/presentation/renderers/`. | `google_fonts` (runtime download); Material defaults | Tokens from [[figma-question-screens]] map 1:1. Renderers take a payload and an `onAnswerChanged` callback only, mirroring the dashboard's props-only [[question-preview]]. |
| Audio | **just_audio** (stream from the media URL; one shared player per lesson; replay button) | audioplayers | Mature, good error and buffering states, and a URL source with no platform code. |
| Environments | **`--dart-define-from-file`** with `env/emulator.json`, `env/device.json`, `env/prod.json` (`API_BASE_URL`, `APP_ENV`). The emulator uses `http://10.0.2.2:5000/api`; a device uses `http://<LAN IP>:5000/api`. **A debug-only `network_security_config.xml`** allows cleartext HTTP to those hosts. Production is HTTPS only. | Android product flavors now | Flavors only pay off with several store builds. Defines give the same separation with no Gradle changes and can grow into flavors later. |
| Media URLs | The `/learn/*` responses **build media URLs at response time** from `Media.storageKey` and the current `MINIO_PUBLIC_ENDPOINT` | Rely only on `Media.url` | **Finding:** `media.controller.ts` stores the full `url` at upload time, so changing `MINIO_PUBLIC_ENDPOINT` (Q8) doesn't fix existing media, which keep `localhost`. Additive change in [[feat-exercise-player]]; no migration. |
| Android | `applicationId` **`dev.ssuniverse.dsl`** (proposal); `minSdk` 24 (Android 7.0); `compileSdk`/`targetSdk` = the Flutter 3.41 defaults; portrait only; app label "DSL". Launcher icon via `flutter_launcher_icons`, splash via `flutter_native_splash` (Android 12+ splash API), both from the Figma logo exported in Slice 0 (one Figma call). | minSdk 21 | 24 covers almost every active device and avoids old-WebView/Keystore edge cases in secure storage. |
| Testing | **Unit:** `ApiClient` envelope and error mapping, repositories against **JSON fixtures recorded from the real local API**, and model round-trips. **Widget:** each of the 8 renderers (empty, answered, feedback), the router guards and the error states, with `mocktail`. **Integration** (`integration_test`): log in → enroll → play a seeded exercise covering all 8 types, against the docker stack from the emulator. | mockito (codegen); golden tests in the MVP | Fixtures from the real API catch contract drift. Goldens are brittle across font and SDK updates; add them later for the renderers if needed. |
| Lint | `flutter_lints` + `analysis_options.yaml` with `strict-casts`, `strict-inference`, `strict-raw-types`, and rules such as `prefer_final_locals`, `always_declare_return_types`, `unawaited_futures`. Generated files excluded. `dart format` enforced. | very_good_analysis | Strict where it catches bugs, without very_good's style-only noise. |

## Repo integration
**`dsl-mobile/CLAUDE.md`**, written in Slice 0:
- the stack above and the folder rules;
- the run commands (`flutter run --dart-define-from-file=env/emulator.json`);
- verification (`dart format --set-exit-if-changed`, `flutter analyze`, `flutter test`, then an emulator check against the running API);
- the error and 401 policy;
- "follow [[api-contract]], never re-derive answers or rules client-side";
- the Figma call budget and "use [[figma-screen-inventory]] and the cached screenshots first";
- never read `.env`/credentials;
- generated `*.g.dart`/`*.freezed.dart` are committed and regenerated with `dart run build_runner build -d`.

**Docker Compose:** the app itself isn't containerized. One small change: `MINIO_PUBLIC_ENDPOINT: ${MINIO_PUBLIC_ENDPOINT:-http://localhost:9000}`, so a device test can point media at the LAN IP without editing the file. With the response-time URL building above, that's all a phone needs.

**Root `CLAUDE.md`:** add `dsl-mobile/` to the package table, and Flutter commands to "Build and lint".

> [!todo] Unverified: the Android SDK location and emulator image on this machine weren't checked (`flutter doctor` runs in Slice 0). The application id can't change after a Play Store release.

Back to [[decisions-index]] · [[mobile-index]].
