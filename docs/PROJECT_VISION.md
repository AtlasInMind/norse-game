# Project Vision — Norse Game

## Purpose

Describe the creative and design direction for the game as set by the client, as a foundation for further design and content work.

## Summary

An atmospheric, exploration-driven top-down 2D game for the browser, built in Godot with GDScript. The player experiences the same real places in two time periods — a recognizable modern Norwegian setting and the same landscape in the Viking Age — and pieces together what actually connects them, not through citations, but through what the people in the story believe, fear, or won't say out loud.

## Last updated

2026-07-24 (creative reboot — see `DECISIONS.md`)

## Status

provisional (creative direction reset by the client during a reboot pass; supersedes the original 2026-07-23 brief-derived direction, see `DECISIONS.md`)

---

## Platform and engine

- Engine: Godot 4.7, language: GDScript.
- **Primary platform: web (browser)**, set by the client 2026-07-24 — see `DECISIONS.md`. iOS is a possible later secondary export target from the same Godot codebase; Android not prioritized.
- Control method: tap/click-to-move as primary input, works for both touch and mouse.

## Visual and mechanical direction

- Perspective: top-down.
- Aesthetic: simple, stylized graphics — pixel art or equivalent, still to be produced (placeholder shapes until real art starts, see the M3 milestone). Readability can still draw on Old School RuneScape's legibility, without copying its protected expression — but the mood reference points are now closer to *What Remains of Edith Finch*, *Old Man's Journey*, and *Outer Wilds*: melancholic, curious, willing to leave things unresolved.
- Pace and focus: exploration and atmosphere over combat; combat is not the core mechanic (exact amount still an open question, see `OPEN_QUESTIONS.md`). Tension comes from mood, uncertainty, and consequence, not necessarily from danger to the player character.
- The world draws on real Nordic/Norwegian nature, landscape, settlements, and cultural environments.

## The dual timeline

The game's core mechanic: the same geographic place exists in two time layers —

1. A recognizable, modern Norwegian setting.
2. The same place in the Viking Age.

The player should experience connections between the two time layers that are **real and researched**, but delivered as belief rather than fact — never announced with a citation or a certainty badge. Examples of the kind of connection to build toward (see `research/continuity_into_modern_life.md` for the underlying research; delivery in-game should read as folklore, rumor, or unease, not as an information panel):

- A modern square or gathering place near what was once a market or assembly site.
- A modern road that follows an older route, for reasons nobody living quite remembers.
- A religious or social gathering place with layered history — something people sense rather than something the game states as fact.
- Burial mounds and archaeological traces in or near modern buildings, treated as unsettling rather than merely informative.
- Old Norse roots in modern words, expressions, and place names.
- Property boundaries and farmland carrying traces of older organization.
- Composite or contested connections between modern holidays, laws, or norms and older traditions.

Target feeling for the player: *unease and recognition at once — this place remembers something, and not everyone here wants to say what.*

Important boundary: reduce the felt distance between the two time periods by showing real connections, continuities, breaks, and changes — not by presenting the periods as identical, and not by resolving whether the old beliefs were true. Whether something was real is left for the player to sit with, not settle.

### Geographic scope

The game is set in **Lofoten/Vesterålen/Salten** (Nordland, Norway) — set by the client 2026-07-24, see `DECISIONS.md`. The game's own place names and geography should still be fictional composites, not a precise rendering of real places (see `concepts/location_pairs.md`). The region has a significant Sámi historical and living presence that requires its own careful treatment — see `OPEN_QUESTIONS.md` and `research/authenticity_and_sensitive_topics.md` §2.7.

## Modern visual direction

The modern setting should **not** be primarily shown through malls, skyscrapers, luxury, or "bling." Focus on down-to-earth, inhabited, credible environments that work well alongside historical versions of the same place — see the full list and research in `research/modern_environment.md` (small towns, villages, farms, harbors, churches/cemeteries, museums, rivers/fjords/coastal landscape, places where modern buildings sit close to archaeological traces, etc.).

The contrast with the Viking Age should come from changes in people, use, materials, and society — not just from extreme modern architecture.

## Historical grounding as a core value — held internally

See the `research/` folder for full coverage, and `CLAUDE.md` for how this now applies without a player-facing citation system. Key principles:

- "The Vikings" are not one homogeneous people with one lifestyle — distinguish those who went raiding or trading abroad from the broader population of Viking-Age society.
- Consistently distinguish historical fact, probable reconstruction, academically debated interpretation, and later myth or modern pop culture — internally, in the writing process, even though the game no longer labels this for the player.
- Don't romanticize violence, plunder, slavery, or social inequality. Don't reduce society to warriors, kings, and gods — everyday life, work, family, local trade, and land use matter at least as much.
- Religion should not be shown as one complete, standardized system.
- Show hard truths with real weight rather than softening them for comfort — the target audience (adults, 18-30) can hold that.

## Scope for this phase

The engine/systems foundation (M0-M2) and the original vertical-slice content are built and functional. This phase is a creative reset of tone, audience, and language before content expansion continues — see the M3 milestone breakdown on GitHub. Reused as-is: the engine, the dual-timeline architecture, the save system, the UI framework. Rewritten: all player-facing text (English, new voice), the historical-claim/citation display, and the three existing quests' dialogue.
