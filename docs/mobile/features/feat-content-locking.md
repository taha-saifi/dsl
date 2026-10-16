---
type: feature
scope: cross-cutting
sources: [docs/mobile/figma-screen-inventory.md]
updated: 2026-10-16
---
# Feature: sequential unlocking (later)

**Size:** M · **Depends on:** [[feat-learning-progress]] · **Changes [[api-contract]]:** yes

## Goal
Exercises unlock in order inside a unit. Units unlock when the prerequisite units a teacher chose are complete.

## Figma screens
[[figma-screen-inventory]]: Locked units on Course Details `87:5` ("Complete Unit 3 to unlock"), locked exercises on Unit Details `87:104`. DS: Unit Card `52:310`.

## Mobile scope
Locked rows with the unlock hint; tapping one explains why.

## Backend changes
- **Additive:** `/learn/*` adds `isLocked` and `unlockHint`. **Behavior:** starting a session on a locked exercise is refused with 409 `EXERCISE_LOCKED`.
- Rule computed on read from completed sessions and `orderIndex`.

## Database changes
Computed, so no collection is needed. The designed `unitProgress` collection stays unbuilt unless teachers need manual unlocks.

## Dashboard changes
Unit form: a prerequisite-units multi-select (see Decisions).

## Decisions (2026-10-16)
- Q25 → **Exercises lock sequentially within a unit:** a student can start exercise *n+1* only after completing exercise *n*. This is always on.
- **Units are free by default.** A teacher can mark **prerequisite units**: `Unit.prerequisiteUnitIds[]`, same course only, no cycles; validated by the backend with new 400 codes `INVALID_PREREQUISITE` and `PREREQUISITE_CYCLE`. A unit is locked until all its prerequisites are complete.
- **Dashboard:** the unit form gets a "requires these units" multi-select. Unit deletion must clean up or refuse when other units reference it (new delete guard, [[delete-guards]]).
- **Database:** `Unit.prerequisiteUnitIds: ObjectId[]`, default `[]`, no migration. Locks are still computed on read, and there's no `unitProgress` collection.

Back to [[00-feature-catalog]].
