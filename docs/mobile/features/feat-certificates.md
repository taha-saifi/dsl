---
type: feature
scope: cross-cutting
sources: [docs/mobile/figma-screen-inventory.md]
updated: 2026-10-16
---
# Feature: certificates (later; static screen in the MVP)

**Size:** L · **Depends on:** [[feat-unit-and-course-completion]] · **Changes [[api-contract]]:** yes

## Goal
Completing a course issues a verifiable certificate that the student can view, download and share.

## Figma screens
[[figma-screen-inventory]]: Course Complete `111:52`, Certificates `111:98`, Certificate Detail `111:163`.

## Mobile scope
Certificates tab (earned / in progress / available), certificate detail, PDF download, share sheet.

## Backend changes
- **Additive:** certificate issued on course completion; `GET /learn/me/certificates`; `GET /learn/certificates/:id`; **public** `GET /certificates/verify/:number` (no auth); a PDF either rendered by the server or drawn by the app.

## Database changes
New collection `certificates` `{studentId, courseId, number (unique), issuedAt, studentName, courseName}`. It snapshots names so renames don't alter issued certificates.

## Dashboard changes
Optional: a list of issued certificates per course.

## Decisions (2026-10-16)
- Q27 → **Out of scope for now. The app shows static screens** (sample certificate, no backend). The real feature comes later.

Back to [[00-feature-catalog]].
