---
type: index
scope: cross-cutting
sources: [dsl-backend/src/models, dsl-teacher-dashboard/src/types/index.ts]
updated: 2026-10-16
---
# Contracts

- [[api-contract]]: **the source of truth for the API.** Every client (dashboard, mobile) follows it. An API change updates the backend, every client, and this note in the same change.
- [[known-mismatches]]: places where the current code breaks or strains the contract.

Related: [[api-endpoints]], [[error-codes]], [[question-types]]. Back to [[00-index]].
