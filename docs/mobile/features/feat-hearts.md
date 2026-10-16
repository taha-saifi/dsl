---
type: feature
scope: cross-cutting
sources: [docs/mobile/figma-screen-inventory.md]
updated: 2026-10-16
---
# Feature: hearts (later)

**Size:** M · **Depends on:** [[feat-answer-checking-and-sessions]] · **Changes [[api-contract]]:** yes

## Goal
Students have 5 hearts, lose one per wrong answer, and wait for a timed refill when out.

## Figma screens
[[figma-screen-inventory]]: hearts in every lesson top bar, Wrong `87:262` (−1), Hearts Depleted `113:5`, Home `60:5` (HP 5/5).

## Mobile scope
Hearts in the top bar and Home; the Hearts Depleted screen with a refill countdown and Quit. **Ads and Premium are left out** (no backend for them).

## Backend changes
- **Additive:** answer responses include `hearts`; a wrong answer at 0 hearts is refused with 409 `NO_HEARTS_LEFT`. `GET /learn/me/stats` adds `{hearts, nextHeartAt}`.
- Refill computed lazily from `heartsUpdatedAt` (no cron).

## Database changes
`studentStats.hearts` (default 5, designed) and new `heartsUpdatedAt`. `exerciseSessions.heartsLost` (designed).

## Dashboard changes
None.

## Decisions (2026-10-16)
- Q23 → **Hearts are in scope**, and **replays cost hearts too**. Refill: 1 heart per hour up to 5 (proposed), computed lazily.

Back to [[00-feature-catalog]].
