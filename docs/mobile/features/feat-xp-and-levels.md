---
type: feature
scope: cross-cutting
sources: [docs/mobile/figma-screen-inventory.md]
updated: 2026-10-16
---
# Feature: XP and levels (later)

**Size:** M · **Depends on:** [[feat-answer-checking-and-sessions]] · **Changes [[api-contract]]:** yes

## Goal
Completing exercises earns XP; total XP moves the student through levels.

## Figma screens
[[figma-screen-inventory]]: Exercise Complete `6:107` (XP earned, progress to next level), Home `60:5` stats, card "+XP" on `87:5` `87:104` `112:370`, Profile `111:296`. DS: Badges `52:186`.

## Mobile scope
XP on results, cards, Home and Profile; level badge and progress-to-next-level bar.

## Backend changes
- **Additive:** session completion returns `xpEarned`; `GET /learn/me/stats` returns `{totalXp, level, nextLevelXp}`; `/learn/*` cards add `xpReward` (sum of question `points`).
- Rule (proposed): XP = points of first-try-correct questions; only the **first completion** of an exercise (or improvements on the best score) earns XP.

## Database changes
New collection `studentStats` (as designed: one doc per student, unique `studentId`), updated in the same operation as session completion. Level thresholds in code, not the DB.

## Dashboard changes
None (later: show XP in [[feat-teacher-student-insights]]).

## Decisions (2026-10-16)
- Q21 → XP = the `points` of first-try-correct questions, earned **on the first completion only**, plus any improvement on the best score.
- Q22 → **Proposed (no answer given):** levels are XP thresholds, Beginner 0 · Intermediate 1,000 · Advanced 3,000. These thresholds are constants in code, kept separate from the onboarding "experience level" and the course level. Confirm before this slice.

Back to [[00-feature-catalog]].
