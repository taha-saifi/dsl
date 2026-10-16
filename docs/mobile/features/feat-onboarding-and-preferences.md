---
type: feature
scope: cross-cutting
sources: [docs/mobile/figma-screen-inventory.md]
updated: 2026-10-16
---
# Feature: onboarding and learning preferences (MVP)

**Size:** M · **Depends on:** [[feat-student-accounts]] · **Changes [[api-contract]]:** yes

## Goal
After sign-up, a student picks a domain, a language to learn, a goal, a daily target and an experience level, and the catalog uses them.

## Figma screens
[[figma-screen-inventory]]: Choose Domain `57:5`, Language Select `57:73`, Profile Setup `57:132`; Settings rows in `89:4`. DS: Domain Card `52:431`, Language Card `52:410`.

## Mobile scope
- Three onboarding steps after Sign Up, shown only while preferences are unset. Defaults filter the catalog (domain chip preselected, language filter).

## Backend changes
- **Additive:** `PATCH /auth/me` `{firstName?, lastName?, preferences?}` (students only). `GET /learn/languages`: target languages with published course counts.
- Validation: goal and level enums, daily target in {5,10,15,20,30} minutes, language 2-letter, domain = an existing specialization.

## Database changes
Embedded `User.preferences: {specializationId?, targetLanguage?, goal?, dailyTargetMinutes?, experienceLevel?}`. It's bounded and always read with the user ([[adr-embed-vs-reference]]). No migration.

## Dashboard changes
None.

## Decisions (2026-10-16)
- Q19 → **Onboarding is in the MVP** (moved to MVP #2, after accounts).
- Q20 → Experience level and goal are **informational only** in the MVP: stored, shown in the profile, and used for no filtering.
- Domain and language preselect the catalog filters.

Back to [[00-feature-catalog]].
