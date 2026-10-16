---
type: feature
scope: cross-cutting
sources: [docs/mobile/figma-screen-inventory.md]
updated: 2026-10-16
---
# Feature: leaderboard (later; static screen in the MVP)

**Size:** M · **Depends on:** [[feat-xp-and-levels]] · **Changes [[api-contract]]:** yes

## Goal
Students compare weekly and monthly XP.

## Figma screens
[[figma-screen-inventory]]: Leaderboard `111:213`, Home weekly leaderboard `60:5`. DS: Leaderboard Row `52:382`.

## Mobile scope
Weekly/Monthly tabs, podium, ranked list, the student's own row and percentile.

## Backend changes
- **Additive:** `GET /learn/leaderboard?period=week|month` → top N plus the student's own rank. It aggregates XP from completed sessions in the period (`exerciseSessions.xpEarned`, `completedAt`).

## Database changes
Index on `exerciseSessions` `{completedAt, studentId}`. If aggregation gets slow, add a `weeklyXp` rollup collection.

## Dashboard changes
None.

## Decisions (2026-10-16)
- Q28 → **Out of scope for now. The app shows a static screen** with sample data. The real feature comes later.

Back to [[00-feature-catalog]].
