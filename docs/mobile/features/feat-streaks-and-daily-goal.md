---
type: feature
scope: cross-cutting
sources: [docs/mobile/figma-screen-inventory.md]
updated: 2026-10-16
---
# Feature: streaks and daily goal (later)

**Size:** S · **Depends on:** [[feat-answer-checking-and-sessions]], [[feat-onboarding-and-preferences]] · **Changes [[api-contract]]:** yes

## Goal
A student builds a daily streak and sees today's practice toward their daily target.

## Figma screens
[[figma-screen-inventory]]: Home `60:5` (Day Streak, "Ready for today's practice? 5 exercises · est. 10 min"), Profile `111:296` (streak).

## Mobile scope
Streak count on Home and Profile; today's practice card with remaining exercises.

## Backend changes
- **Additive:** `GET /learn/me/stats` adds `{currentStreak, longestStreak, todayMinutes}`; `GET /learn/me/today` suggests next exercises up to the daily target.
- A streak day = at least 1 completed session that calendar day **in the student's timezone** (the client sends `X-Timezone` or a stored preference).

## Database changes
`studentStats.currentStreak`, `longestStreak`, `lastActivityDate` (designed); add `timezone` to preferences.

## Dashboard changes
None.

## Decisions (2026-10-16)
- Q24 → A streak day = **at least one completed exercise** that day.

Back to [[00-feature-catalog]].
