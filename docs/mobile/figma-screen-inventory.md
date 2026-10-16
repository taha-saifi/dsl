---
type: reference
scope: mobile
sources: [docs/assets/mobile-screens]
updated: 2026-10-16
---
# Figma screen inventory

File **DSL App — All Screens**, key `c0H9TY3umdMH2hr8q0gVuu`, page `0:1` (the only page). Built from one `get_metadata` call on `0:1` (2026-10-16): frame names, sizes, text layers, and prototype links (layer names like `-> Splash->Login`). **No screenshots here**: fetch them per feature when that slice is built. The six question frames are already cached in [[figma-question-screens]].

Sizes: app screens are **393×852** (scrolling screens up to 393×1320); the six question frames are older **360×800** originals. "Exits" are the prototype links on that frame (`.nav` = bottom nav).

## Auth (section `02`)
| Node | Frame | What it shows | Exits |
|---|---|---|---|
| `55:5` | 02-A · Splash Screen | Brand hero "Master the Language of Your Domain", domain chips (Medical, Aviation, Legal, Engineering…), Get Started, Sign In | Login, Sign Up |
| `55:40` | 02-B · Login | Email + password, Forgot Password?, **Continue with Google**, Sign Up link | Home, Sign Up |
| `55:68` | 02-C · Sign Up | "Step 1 of 4 — Basic Info": full name, email, password (min 8), confirm, terms checkbox | Domain, Login, Splash |

## Onboarding (section `03`)
| Node | Frame | What it shows | Exits |
|---|---|---|---|
| `57:5` | 03-A · Choose Domain | "Step 1 of 3": domain cards (Medical, Legal, Engineering, Business & Finance) with descriptions | Language, back to Sign Up |
| `57:73` | 03-B · Language Select | "Step 2 of 3": language to learn, with course counts per language; some "Coming soon" | Profile Setup, Domain |
| `57:132` | 03-C · Profile Setup | "Step 3 of 3": learning goal (Professional Dev, Academic Study, Certification, Daily Practice), daily target (5–30+ min), experience level (Beginner/Intermediate/Advanced) | Get Started (no link drawn) |

## Home and browsing (section `04–07`)
| Node | Frame | What it shows | Exits |
|---|---|---|---|
| `60:5` | 04 · Home Dashboard | Greeting; current course card (level, %, XP 2,850/4,800, hearts 5/5, Continue); stats Total XP / **Day Streak** / Rank; "today's practice" (5 exercises, est. 10 min); My Courses; Recent Units; Achievements; Weekly Leaderboard (top 3 + you) | Course Details, Unit Details, Catalog, Leaderboard, nav |
| `62:5` | 05 · Course Catalog | Search, domain filter chips, sort; course cards (domain, title, subtitle, units, duration, level, Enrolled + % or Enroll Now); Load more | Course Details, Home, nav |
| `87:5` | 06 · Course Details | Title, subtitle, %, About; stats units done / XP / completion; unit list (number, name, subtitle, +XP, % or Done or **Locked**) | Unit Details, Catalog, nav |
| `87:104` | 07 · Unit Details | Unit name, % and n/m exercises, overview text; exercise list (name, **single type label**, difficulty, minutes, +XP, Done / Start / Locked) | Exercise Intro, each question type, Course, nav |

## Lesson (sections `08`, P2)
| Node | Frame | What it shows | Exits |
|---|---|---|---|
| `112:370` | P2 · Exercise Intro | Exercise name, type, description, tip, XP reward, question count, est. time, difficulty; Start / "I'll do this later" | Flashcard Front, Unit |
| `112:424` | P2 · Flashcard Front | "Card 1 of 8", term, domain tag, IPA, audio button, language toggle EN/FR/AR; Reveal / skip | Flashcard Back, MC, Pause |
| `113:48` | P2 · Flashcard Back | Term, **definition**, **example in context**; "Knew it" / "Need practice" | MC, Pause |
| `5:3` | 09 · Matching Pairs | Terms ↔ definitions, two columns | Wrong state (`147:3`), Pause |
| `147:3` / `148:120` / `147:61` | 09 · Matching Pairs · Wrong / Retry / Correct | Matching feedback variants | Retry → Correct → Exercise Complete |
| `5:62` | 10 · Choose Picture | 2×2 labelled picture tiles | Correct, Wrong, Pause |
| `5:121` | 11 · Listening | Replay audio, type what you heard, spelling feedback | Correct, Pause |
| `5:237` | 12 · Reorder Words | "Translate:" source sentence, build the sentence from word chips | Correct, Pause |
| `6:3` | 13 · Fill in Blank | Sentence with a gap, **4 word choices**, context card | Correct, Wrong, Pause |
| `6:54` | 14 · Multiple Choice | Definition question, 4 lettered options | Correct, Wrong, Pause |
| `87:218` | 08 · Correct Answer State | Green banner with explanation, Continue | Exercise Complete |
| `87:262` | 08 · Wrong Answer State | Red banner "The correct answer is…", explanation, **−1 heart**, Try Again / Skip & Continue | MC (retry), Exercise Complete |
| `113:90` | P2 · Pause Dialog | "Question 5 of 10", 40% / 4 of 10 done, XP so far, "Quitting will reset your progress for this exercise"; Keep Going / Quit | MC, Unit |
| `113:5` | P2 · Hearts Depleted | Out of hearts, refill timer (4h 32m), XP saved; watch ad / Go Premium / Quit | MC, Catalog, Home |

`typing` and `listening_select` have no frame (the file says "All 6 interaction types"). In-lesson top bar on every screen: X, progress, `n/total`, hearts.

## Results (section `09`)
| Node | Frame | What it shows | Exits |
|---|---|---|---|
| `6:107` | 15 · Exercise Complete | Score %, XP earned, accuracy, time, progress to next level (Intermediate → Advanced) | Unit Complete, Unit |
| `111:5` | 09a · Unit Complete | Accuracy, time, "Achievement Unlocked", course progress now 44% | Next unit, Course |
| `111:52` | 09b · Course Complete | Certificate of completion (name, course, date, number), units 18/18, total XP; download/share | Certificate Detail, Certificates, Catalog |

## Certificates, social, profile (sections `10–12`)
| Node | Frame | What it shows | Exits |
|---|---|---|---|
| `111:98` | 10a · Certificates | Earned / In progress / Available counts and lists | Certificate Detail, Catalog, Home, nav |
| `111:163` | 10b · Certificate Detail | Full certificate, completion date, verification number + verify URL, share | Certificates, nav |
| `111:213` | 11 · Leaderboard | Weekly / Monthly tabs, podium, ranked list with XP, "you" row, percentile | nav |
| `111:296` | 12a · Profile | Name, role line + level, current course, stats (XP, units, courses, certs, streak, rank), achievements, Settings, Log Out | Settings, Language, Home, nav |
| `89:4` | 12b · Settings | Learning: language, daily target, level, notifications · Account: account settings, privacy, linked accounts, subscription · Support: help, feedback, rate, about · Edit Profile, Log Out | Profile, Home |

Bottom nav (5 tabs): Home, Courses, **Practice**, Certs, Profile. Every `.nav->Practice` link has **no Practice frame**.

## Design system (section `01`, `52:*`)
Color Tokens `52:5`, Typography `52:39`, Spacing `52:67`, Elevation `52:101`, Grid `52:113`, Buttons `52:129`, Inputs `52:164`, Badges `52:186`, Progress Ring `52:217`, Progress Bar `52:241`, Bottom Nav `52:266`, Course Card `52:289`, Unit Card `52:310`, Exercise Card `52:337`, Achievement `52:364`, Leaderboard Row `52:382`, Language Card `52:410`, Domain Card `52:431`, Empty State `52:460`, Loading State `52:473`, Error State `52:495`. Tokens and type scale: [[figma-question-screens]].

## Design vs data model
- **Exercises are single-type in the design** ("Multiple Choice · Easy"); ours mix any of the 8 types. **Decided (2026-10-16): exercises stay mixed-type**; an exercise holds many questions of any types, so the app shows a mix label instead of one type.
- **Term → definition** in Multiple Choice, Matching and Flashcards; our items only have **translations**. **Decided (2026-10-16): learning items get an optional definition** (a model change; not every item has one). See [[feat-item-definitions-and-flashcards]].
- Feedback banners carry explanation copy that no model stores.
- Unit/course/exercise cards show difficulty, duration, XP, subtitle and a "Locked" state; none are modelled.
- Sign Up says "Step 1 of 4"; onboarding says "Step 1 of 3" (4 in total, numbered inconsistently).
- Fill in Blank shows 4 choices; `fill_blank` has no distractors (see [[figma-question-screens]]).

Logo: `122:335` (tile) / `91:14` (image fill, 500×500 PNG), cached as `docs/assets/mobile-screens/_logo.png` and `_logo-tile.png` (Slice 0, 1 call). Splash `55:5` screenshot cached as `auth_splash.png` (Slice 1, 1 call); Login and Sign Up were built from the metadata and the DS boards. Choose Domain `57:5` cached as `onboarding_domain.png` (Slice 2, 1 call); the other two onboarding steps reuse its card style. Course Catalog `62:5` cached as `catalog.png` (Slice 4, 1 call); Course Details and Home were built from the metadata. Unit Details and Exercise Intro (Slice 5) too: 0 calls.

Back to [[mobile-index]] · capabilities: [[backend-capability-map]].
