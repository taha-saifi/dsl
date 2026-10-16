---
type: feature
scope: cross-cutting
sources: [docs/mobile/figma-screen-inventory.md]
updated: 2026-10-16
---
# Feature: password reset (later)

**Size:** M · **Depends on:** [[feat-student-accounts]] · **Changes [[api-contract]]:** yes

## Goal
A student who forgot their password can reset it.

## Figma screens
[[figma-screen-inventory]]: "Forgot Password?" link on Login `55:40`. No reset screens exist.

## Mobile scope
Request screen and a reset-code screen (to be designed).

## Backend changes
- **Additive:** `POST /auth/forgot-password`, `POST /auth/reset-password`. **Needs an email provider** (new infrastructure).

## Database changes
`passwordResets` `{userId, tokenHash, expiresAt}` with a TTL index.

## Dashboard changes
None.

## Decisions (2026-10-16)
- Q31 → There's **no email provider**. Until there is, **the admin resets passwords** via the admin user endpoint in [[feat-student-accounts]], and the app's "Forgot password?" says "Ask your administrator". Self-service reset is deferred.

Back to [[00-feature-catalog]].
