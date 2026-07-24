# Working title options

## Purpose

Propose candidate titles for client decision — see `docs/OPEN_QUESTIONS.md`'s former item 2 and GitHub issue #33. The game currently has no real title; `game/project.godot`'s `config/name` and `main_menu.gd` both still show "Norse Game," the repo's own placeholder name. This document proposes options grounded in the game's actual, current content (the three rewritten quests, the region's real research, the settled tone) rather than in the abstract. **This document does not decide the title** — that's the client's call.

## How these were chosen

Each option is tied to specific game content or research below it, not picked for sounding evocative in the abstract. All are plain English, matching the register of the project's own mood references (*What Remains of Edith Finch*, *Old Man's Journey*, *Outer Wilds* — see `docs/PROJECT_VISION.md`) rather than fantasy-coded naming, since the game explicitly isn't "fantasy-with-magic-that-works." None use a real, undisguised place name as the title itself, per `docs/concepts/location_pairs.md`'s own principle for in-game place names ("use real name-research principles, but invent the actual name — don't use a real, precise place name for a fictional location that's meant to diverge from reality").

## Candidates

### 1. What the Ground Remembers
Directly echoes the target feeling stated in `PROJECT_VISION.md`: *"this place remembers something, and not everyone here wants to say what."* Also literal: Borg's quest premise is a farmer's field with something the ground has been hiding (an 83-metre chieftain's hall), and Saltstraumen's is a house built over an unmarked grave.

### 2. Two Tides
Ties together the dual-timeline mechanic (Torolv, the game's one Viking-Age speaker, calls the player "the one who walks both times") and Saltstraumen — the world's strongest tidal current, a real, dramatic, geographically unchanging landmark used as a location pair in `docs/concepts/location_pairs.md` §18.

### 3. Under the Rise
"The Rise in the Field" is the actual in-game title of the Borg quest (a barely-visible rise in a modern field that turns out to be a buried chieftain's hall). The pattern repeats at all three locations — something ordinary on the surface, something else underneath — so this title generalizes the game's central visual/narrative device rather than naming just one quest.

### 4. What They Say
Echoes the recurring dialogue framing used throughout the M3 rewrite to keep claims belief-forward rather than fact-forward: Torolv's "They say the king himself... means to build a church," Sigrun's "I've never gotten a straight answer on that," the "have you heard what they sing about this place?" hook. Names the game's core narrative technique directly.

### 5. Doesn't Stop Me
A direct quote from Bjørn's line in the Saltstraumen quest: *"I try not to think about it too much. Doesn't stop me thinking about it."* Concise, captures the "unease and recognition at once" target feeling in the modern-era voice specifically. Riskier as a title than the others — it reads as an unfinished sentence out of context, which is intentional but won't be self-explanatory on a store page without the line it's drawn from nearby.

### 6. Where the Current Turns
`docs/research/modern_environment.md` environment type 17 documents that Saltstraumen forces up to ~400 million cubic metres of water through the strait every sixth hour — a real, geographically fixed detail. A current that strong changing that dramatically four times a day is, in practice, a current reversing direction (a commonly cited characteristic of Saltstraumen specifically, though the research document itself describes volume/timing rather than stating "reverses" in those exact words) — worth flagging as an inference on top of the cited source, not a direct quote from it. Doubles as a metaphor for the game's belief/fact ambiguity and the player moving back and forth between eras.

## Quick collision check (not a legal/trademark search)

A fast, non-exhaustive gut-check against game titles I'm aware of — **not a substitute for an actual trademark search**, which `docs/research/godot_mobile_technical_research.md` point 15 explicitly flags as a separate legal question this project hasn't done:

- An earlier draft of this list included **"Salt and Iron"** — dropped before presenting, because it's too close to the existing "Salt and Sanctuary" / "Salt and Sacrifice" franchise's naming pattern ("Salt and ___") to be a safe choice. Replaced with "Where the Current Turns," which keeps the Saltstraumen grounding without the collision risk.
- The remaining six don't match any specific existing game title I recognize, but several (particularly "Two Tides") use common enough words that a proper trademark/store-listing search is worth doing on whichever option is actually chosen, before it's locked in.

## Decision

**Chosen 2026-07-25: "What the Ground Remembers."** The interactive decision prompt used to present these to the client is capped at 4 choices, so options 1-4 (What the Ground Remembers, Two Tides, Under the Rise, What They Say) were offered directly, with options 5-6 (Doesn't Stop Me, Where the Current Turns) named as available alternatives in the same prompt and this full document linked for complete rationale on all six. The client picked from the four presented directly. Recorded in `docs/DECISIONS.md`; the actual code/config title update is tracked as GitHub issue #35, not bundled into issue #33.

## Next step

Once a direction is chosen (or a client-supplied alternative is decided on instead), the actual title update — `game/project.godot`'s `config/name`, the literal string in `main_menu.gd`, and anywhere else "Norse Game" appears as a title rather than a repo/internal reference — is tracked as GitHub issue #35, not bundled into this one (per issue #33's acceptance criteria).

## Last updated

2026-07-25
