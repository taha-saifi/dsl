---
type: feature
scope: cross-cutting
sources: [docs/mobile/figma-screen-inventory.md]
updated: 2026-10-16
---
# Feature: profile and settings (later)

**Size:** S · **Depends on:** [[feat-student-accounts]] (stats need [[feat-xp-and-levels]]) · **Changes [[api-contract]]:** yes

## Goal
Students see their profile and stats, edit their name and preferences, and log out.

## Figma screens
[[figma-screen-inventory]]: Profile `111:296`, Settings `89:4`.

## Mobile scope
Profile with stats; Settings rows for language, daily target, level and edit profile. Rows with no backend (notifications, subscription, linked accounts, help) are hidden or link out.

## Backend changes
Reuses `PATCH /auth/me` from [[feat-onboarding-and-preferences]]; optional `POST /auth/change-password`.

## Database changes
None beyond preferences.

## Dashboard changes
None.

## Decisions (2026-10-16)
- Q29 → Profile shows the real name, preferences and logout. **Settings rows are static for now** (they open nothing, or a "coming soon" note), except Language, Daily target and Level, which edit the onboarding preferences once [[feat-onboarding-and-preferences]] ships.

Back to [[00-feature-catalog]].
