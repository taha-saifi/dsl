---
type: feature
scope: mobile
sources: [docs/mobile/figma-screen-inventory.md]
updated: 2026-10-17
---
# Feature: static placeholder screens (MVP)

**Size:** S · **Depends on:** Slice 0, [[feat-student-accounts]] (for Profile) · **Changes [[api-contract]]:** no

## Goal
The bottom-nav destinations that have designs but no backend yet exist as **static** screens, so the app's navigation is complete (decided 2026-10-16, Q26–Q29).

## Figma screens
[[figma-screen-inventory]]:
- Certificates `111:98` and Certificate Detail `111:163`
- Leaderboard `111:213`
- the achievement rows in Home `60:5` and Profile `111:296`
- Settings `89:4`

## Mobile scope
- Hard-coded sample content with a visible "Coming soon" marker. There are **no network calls**, so nothing is mistaken for real data.
- Profile is real for name, email and Log Out. Its stats and achievements are static.
- Settings rows are static, apart from Language, Daily target and Level, which edit preferences ([[feat-onboarding-and-preferences]]).
- The Practice tab is hidden (Q34: design later).

## Backend changes
None.

## Database changes
None.

## Dashboard changes
None.

## Built (2026-10-17)
- **Certs tab** (`features/certificates/`): My Certificates with a Coming soon banner and one card marked **Sample**. Certificate Detail has a "SAMPLE" watermark, a placeholder name ("Your name"), no verification number, and disabled Download/Share, so it can't pass for a real certificate.
- **Leaderboard** (from Profile): invented "Learner A–E" rows, a Weekly/Monthly toggle, and a banner.
- **Profile:**
  - Real header from the signed-in user (initial, name, email, "goal · level · Learning <language>") and Log Out.
  - Stats show "—" (not made-up numbers); achievements are locked tiles under a banner.
  - Rows: Settings and Leaderboard.
  - The domain-name lookup from Slice 2 was dropped, so **Profile makes no network calls**.
- **Settings:**
  - Language (the languages of the student's domain), Daily Target and Experience Level edit preferences with `PATCH /auth/me`, then show "Saved.".
  - Every other row is disabled with a "Soon" badge. About DSL opens the about dialog.
- `ComingSoonBanner` / `SoonBadge` in `core/widgets/coming_soon.dart`. `PlaceholderScreen` was removed: no tab uses it any more.
- Home stays real-data only; Figma's achievements and leaderboard teaser on Home are left out until those features exist.
- Debug builds now log one line per API request (`DSL api → GET /path`, no bodies or headers) to check the "no network calls" gate.
- The Practice tab stays hidden (Q34).

## Decisions (2026-10-16)
- Each of these becomes real later: [[feat-achievements]], [[feat-certificates]], [[feat-leaderboard]], [[feat-profile-and-settings]].

Back to [[00-feature-catalog]].
