---
type: reference
scope: mobile
sources: [docs/assets/mobile-screens, dsl-teacher-dashboard/src/components/questions/preview/QuestionPreview.tsx]
updated: 2026-10-16
---
# Figma: question screens (cached)

File **DSL App — All Screens**, key `c0H9TY3umdMH2hr8q0gVuu`, page `0:1`. Fetched 2026-10-16 with two MCP calls (metadata for `0:1`, one full-canvas screenshot cropped locally). **Work from this note and the PNGs; don't call Figma again for these screens.** Colors marked *sampled* were read from the screenshots, not from Figma variables.

## Frames → question types
| Figma frame | Node | Type | Cached screenshot |
|---|---|---|---|
| 09 · Matching Pairs | `5:3` | `matching` | `docs/assets/mobile-screens/matching.png` |
| 10 · Choose Picture | `5:62` | `choose_picture` | `docs/assets/mobile-screens/choose_picture.png` |
| 11 · Listening | `5:121` | `listening_transcribe` | `docs/assets/mobile-screens/listening_transcribe.png` |
| 12 · Reorder Words | `5:237` | `arrange_sentence` | `docs/assets/mobile-screens/arrange_sentence.png` |
| 13 · Fill in Blank | `6:3` | `fill_blank` | `docs/assets/mobile-screens/fill_blank.png` |
| 14 · Multiple Choice | `6:54` | `multiple_choice` | `docs/assets/mobile-screens/multiple_choice.png` |
| — | — | `typing`, `listening_select` | **no frame**: derived from Listening + Multiple Choice |

Also cached: `_ds-color-tokens.png` (`52:5`), `_ds-typography.png` (`52:39`), `_ds-buttons.png` (`52:129`), `_ds-inputs.png` (`52:164`), `_ds-badges.png` (`52:186`), `_ds-progress-bar.png` (`52:241`), `_state-correct.png` (`87:218`), `_state-wrong.png` (`87:262`). Matching also has Wrong/Correct/Retry variants (`147:3`, `147:61`, `148:120`), not cached.

## Tokens (DS · Color Tokens `52:5`)
| Token | Hex | Role |
|---|---|---|
| Midnight Ink | `#1E1B4B` | primary BG elsewhere; **title/text ink on question screens** |
| Electric Cyan | `#06B8D4` | CTA, progress, selection |
| Gold Amber | `#F5B02A` | XP/rewards, hint cards, reorder/choose-picture badge |
| Soft Gray | `#F4F4F5` | **question screen background** |
| Success / Error | `#22C55E` / `#EF4444` | feedback, hearts |
| White / Muted | `#FFFFFF` / `#94A3B8` | cards / secondary text |
| Violet (*sampled*) | ≈`#8B5CF6` | Listening + Multiple Choice badge |

Tints (*sampled*): selected option ≈ cyan at 14% on Soft Gray (`#D7ECF0`) with a `#3AC3DB` 2px border; success banner ≈ green 13% (`#DEEFE5`) with `#B9E6CA` border; badges are their accent at ~15–20%.

## Type (DS · Typography `52:39`, Inter)
Display 34/42 ExtraBold · H1 28/36 Bold · H2 22/30 SemiBold · H3 18/26 SemiBold (question title) · Body L 16/24 · Body 14/20 · Caption 12/16 · Label 11/16 SemiBold uppercase (type badge).

## Layout (question frames are 360×800; DS grid is 393 with 16px margins, 8px gutters, 4px base)
- Top bar: X (28×28) at 16,16; progress track 6px tall between X and the counter (`n/20`, cyan 12px); three 10px hearts at y50; 1px divider at y62.
- Type badge at y72, h24, pill. Title centred at ~y105.
- Options: white cards r≈16, h70 (MC rows with a 30px letter circle and a 26px radio), 2×2 picture tiles 160×162, matching cards 158×70, word chips h40–42 r≈12.
- Inputs h54 r12 with 2px cyan border (DS · Inputs says h56 r12 15px).
- CTA "Check Answer": 312×54 at y718, full pill, cyan with ink text; disabled = white with muted text ("Select an answer first"). DS · Buttons: h52 r14 SemiBold 16.

## Divergences from our data model
- **Fill in Blank** shows four tappable word options. `fill_blank` has exactly one target and no distractors, so the preview shows a typing input instead. Either the design or the model must change before the mobile app is built.
- Choose Picture tiles carry labels ("Cardiovascular / Heart & Vessels"); the model has no per-option label, and labels would give the answer away, so tiles are image-only.
- Frames' feedback banners ("Correct! …") are explanation copy the model doesn't store.

> [!todo] Unverified (needs a Figma check, no calls left in this task's budget): exact corner radii, shadows, the violet hex, and badge text colours; get_design_context on `6:54` would settle them.

Back to [[mobile-index]] · used by [[question-preview]].
