---
type: feature
scope: mobile
sources: [docs/mobile/figma-screen-inventory.md]
updated: 2026-10-16
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

## Decisions (2026-10-16)
- Each of these becomes real later: [[feat-achievements]], [[feat-certificates]], [[feat-leaderboard]], [[feat-profile-and-settings]].

Back to [[00-feature-catalog]].
