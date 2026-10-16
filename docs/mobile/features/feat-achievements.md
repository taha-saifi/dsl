---
type: feature
scope: cross-cutting
sources: [docs/mobile/figma-screen-inventory.md]
updated: 2026-10-16
---
# Feature: achievements (later; static screen in the MVP)

**Size:** M · **Depends on:** [[feat-xp-and-levels]], [[feat-streaks-and-daily-goal]] · **Changes [[api-contract]]:** yes

## Goal
Students earn badges for milestones.

## Figma screens
[[figma-screen-inventory]]: Home and Profile achievement rows, "Achievement Unlocked" on Unit Complete `111:5`. DS: Achievement `52:364`.

## Mobile scope
Earned and locked badges with progress; an unlock toast on results.

## Backend changes
- **Additive:** `GET /learn/me/achievements`; session completion returns newly earned ones. Definitions (milestone rules) live in code.

## Database changes
New collection `studentAchievements` `{studentId, achievementKey, earnedAt}`, unique on `(studentId, achievementKey)`. Definitions are code constants, not stored.

## Dashboard changes
None.

## Decisions (2026-10-16)
- Q26 → **Out of scope for now. The app shows a static screen** (hard-coded badges, no backend). The real feature comes later.

Back to [[00-feature-catalog]].
