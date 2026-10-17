# dsl-mobile: DSL student app (Flutter, Android only)

Students learn the content teachers publish in the dashboard. This app is a
client of the one DSL API. Inside this folder, this file takes precedence for
Flutter-specific rules; the root `CLAUDE.md` still applies (API contract,
vertical slices, never read `.env`/credential files, commit only when asked).

**Status:** MVP complete: Slices 0–9 done (scaffold, student accounts, onboarding, published-content repository, catalog and enrollment, unit overview, exercise player, answer checking and sessions, learning progress, static screens). Later features follow the roadmap. Build order, per-slice tasks and gates:
`docs/mobile/mobile-roadmap.md`. Features and decisions:
`docs/mobile/features/00-feature-catalog.md`. Architecture and the reasons
behind every choice below: `docs/decisions/mobile-architecture.md`.

## Stack
| Concern | Choice |
|---|---|
| Flutter / Dart | 3.41 stable / 3.11 |
| State | Riverpod 3 (`flutter_riverpod`), hand-written providers; `AsyncNotifier` for screens with actions |
| Routing | go_router: `StatefulShellRoute` for the bottom nav, one `redirect` for guards |
| HTTP | dio, wrapped by `core/api/ApiClient` |
| Models | freezed + json_serializable (build_runner) |
| Token | flutter_secure_storage (`core/storage/token_storage.dart`), JWT only |
| Font | Inter, bundled in `assets/fonts/inter/` (OFL), static weights 400–800 |
| Audio | just_audio (question audio in the player) |

## Folder layout
```
lib/
  main.dart, app.dart
  core/
    api/        ApiClient, ApiException, error messages, providers
    auth/       AppUser, AuthRepository, AuthController (session state)
    config/     AppConfig (dart-defines)
    router/     appRouterProvider, Routes, authRedirect (the one guard)
    storage/    TokenStorage
    theme/      AppColors / AppTypography (ThemeExtensions), AppTheme, AppSpacing, AppRadii
    widgets/    DslButton, DslTextField, DslProgressBar, DslBadge, DslCard,
                DslBottomNav, Loading/Empty/ErrorView, ProgressLine,
                ComingSoonBanner / SoonBadge (sample content)
  features/<feature>/
    data/          repositories + models (talk to ApiClient)
    presentation/  screens and feature widgets
```
- One feature per slice lives in one folder. No `domain/` layer: business
  rules live in the backend.
- Shared widgets go in `core/widgets` only once a second feature needs them.

## Rules
- **Students read content only through `/learn/*`** (`features/learn/data/LearnRepository`). The authoring routes answer them 403.
- **Follow `docs/contracts/api-contract.md`.** Never derive answers, scores,
  progress, locks or any other rule in the app. If the app needs a rule, it's
  an API change (backend + contract + clients in one slice).
- **Errors:** every call goes through `ApiClient` and fails with
  `ApiException(failure, status, code, message)`. Show it with `ErrorView` /
  `describeError`. Server messages are shown as-is.
- **Session rule:** only a genuine HTTP 401 on a request that carried a token
  ends the session (`AuthInterceptor` → `AuthController` → Sign In). Network
  errors, timeouts, 403 and 5xx keep the token and show a retryable error.
- **Guards** live only in `core/router/auth_redirect.dart` (a pure function,
  unit-tested); screens never navigate after sign-in/out, the redirect does.
- **No automatic retries:** `ProviderScope(retry: noAutomaticRetry)`. Error
  states offer "Try again" (`ref.invalidate`).
- **Every screen that loads data has loading, empty and error states.**
- **Styling:** colours and type only through `context.colors` / `context.type`
  and `AppSpacing` / `AppRadii`; no raw hex or font sizes in feature code.
  The app is drawn on Midnight Ink; lesson screens use the light Soft Gray
  surface locally (slice 6).
- `Routes` holds every path. Debug-only screens (`/dev/*`) are registered only
  under `kDebugMode`.
- Copy: sentence case, plain verbs, say what to do next ("Try again").

## Figma
File `c0H9TY3umdMH2hr8q0gVuu`. The account allows about 1–2 MCP calls per hour.
- First use `docs/mobile/figma-screen-inventory.md` (every frame and node id),
  `docs/mobile/figma-question-screens.md` (tokens) and the cached PNGs in
  `docs/assets/mobile-screens/`.
- Fetch a screenshot only for the screens of the slice being built, cache it
  there, and record the call in the slice report.

## Running
```bash
flutter pub get
flutter run --dart-define-from-file=env/emulator.json      # emulator → http://10.0.2.2:5000/api
cp env/device.example.json env/device.json                 # then put your LAN IP in it (git-ignored)
flutter run --dart-define-from-file=env/device.json        # physical phone on the same Wi-Fi
```
- Without `API_BASE_URL` the app stops at startup with a message naming the
  missing define.
- Debug builds log every API request as `DSL api → METHOD /path` (logcat tag `flutter`; no bodies or headers).
- Debug builds allow cleartext HTTP (`android/app/src/debug/res/xml/network_security_config.xml`);
  release builds don't.
- Images and audio come from MinIO URLs built with the backend's
  `MINIO_PUBLIC_ENDPOINT`. For a phone, start compose with
  `MINIO_PUBLIC_ENDPOINT=http://<LAN IP>:9000 docker compose up`.
- **Memory:** Gradle is capped at 3 GB (`android/gradle.properties`). On a 16 GB
  machine, build before booting the emulator, or stop the daemons first
  (`cd android && ./gradlew --stop`). The emulator `dsl_pixel_api34` runs fine
  with `-memory 1536`.
- Launcher icon and splash: `dart run flutter_launcher_icons && dart run flutter_native_splash:create`
  (sources in `assets/branding/`, from the Figma logo).
- Code generation: `dart run build_runner build -d`. Generated `*.g.dart` /
  `*.freezed.dart` files are committed.

## Verification (before calling a slice done)
1. `dart format --set-exit-if-changed .`
2. `flutter analyze` (0 issues)
3. `flutter test`
4. On the emulator against the running stack, walk every gate listed for the
   slice in `docs/mobile/mobile-roadmap.md`, including the failure paths (API
   stopped, wrong role, bad input). Report explicit pass/fail per gate.

Tests: unit tests for repositories/models against JSON recorded from the real
local API (`test/fixtures/`); widget tests per screen state with `mocktail` and
provider overrides; `test/helpers/fake_adapter.dart` fakes Dio responses.
