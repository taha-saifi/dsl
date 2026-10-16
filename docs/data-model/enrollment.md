---
type: model
scope: backend
sources: [dsl-backend/src/models/Enrollment.ts, dsl-backend/src/services/enrollment.service.ts, dsl-backend/src/services/studentCatalog.service.ts]
updated: 2026-10-16
---
# Enrollment

`dsl-backend/src/models/Enrollment.ts`. A student's explicit "Enroll Now" in a course (decision Q6 in [[feat-catalog-and-enrollment]]).

| Field | Type | Notes |
|---|---|---|
| `studentId` | ObjectId → [[user]] | required |
| `courseId` | ObjectId → [[course]] | required |
| `enrolledAt` | Date | required, defaults to now |
| `completedAt` | Date? | not set yet; course completion is a later feature |

Indexes: **unique `{studentId, courseId}`** (one enrollment per student and course, even with concurrent taps) and `{courseId}` (for teacher views later). No timestamps or `updatedAt`.

**Referenced, not embedded in User:** it has its own lifecycle and grows with use ([[adr-embed-vs-reference]]).

Behaviour (`enrollment.service.ts`):
- Enroll is idempotent: 201 when created, 200 when it already existed; a duplicate-key race returns the existing document. Only courses visible to students can be enrolled in (404 otherwise, see [[publish-readiness]]).
- Unenroll deletes the document; idempotent, and allowed even if the course has since been hidden.
- A course that stops being visible drops out of `GET /learn/me/courses` but **the enrollment is kept**, so it comes back if the course is republished (decision Q5).

Endpoints: [[api-endpoints]] (`/learn/courses/:id/enroll`, `/learn/me/courses`). Back to [[data-model-index]].
