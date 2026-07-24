# Open Questions

## Purpose

Collect unresolved questions that affect the project's direction, why they matter, and what's needed to answer them.

## Summary

Rewritten in English as part of the 2026-07-24 creative reboot (see `DECISIONS.md`). Several of the original ten questions are now resolved or superseded by that pivot; the ones that remain genuinely open are listed below, alongside two new questions the reboot itself surfaced.

## Last updated

2026-07-25

## Status

provisional

---

## Open

### 1. How much combat should the game have, exactly

The client has said combat should be secondary to exploration, not that it's absent. This predates the reboot and wasn't resolved by it.
**Why it matters:** affects scope and which systems the next content pass needs.
**What's needed:** a decision from the client before significant new content work assumes one answer or the other. Default working assumption for planning purposes: no traditional combat system, but real tension, danger, and consequence in the writing and pacing.

### 2. Exact calibration of "belief, not fact" per content type

The reboot decided that folklore/omens/seiðr are filtered through character belief rather than confirmed as real — but the right amount of ambiguity likely varies by content type (a well-documented archaeological find delivered through a modern archaeologist NPC can probably still read as fairly matter-of-fact; older, folk-belief-flavored material is where the ambiguity should do more work).
**Why it matters:** getting this wrong in either direction either flattens back into the old "here is a verified fact" tone, or drifts into actual-supernatural territory the client didn't ask for.

**Calibrated by example** during the rewrite of the three existing quests (issue #25). The pattern that emerged, by speaker type rather than by era:

- **Modern-era characters** (Gunnhild, Sigrun, Bjørn) treat the underlying finds as real and settled within the fiction — nobody doubts a chieftain's hall or a grave was actually found — but they're only half-informed about them and read as slightly unsettled rather than authoritative. The ambiguity sits in *scope and meaning*, not in whether the event happened: "people still talk about it," "I try not to think about it too much, doesn't stop me thinking about it," rather than a flat report of the facts. This is the register from the parenthetical above (archaeologist-adjacent, fairly matter-of-fact) but with unease folded in rather than a clean fact-report.
- **Viking-Age characters** (Torolv) avoid citing anything as "documented" at all — that framing is anachronistic for someone living inside the events, not just tonally wrong. In its place: genuine period-plausible oral custom (touching the mast before rounding a point) standing in for what would otherwise be a citation, and firmly-dated events from the character's own near future (the king's church) delivered as current rumor ("they say the king means to...") rather than settled history he couldn't yet actually know. This also incidentally fixed a tense/anachronism bug in the original dialogue, where a Viking-Age speaker flatly narrated an event from *after* his own present as already-completed fact.
- **`HistoricalClaim.claim_text`** (surfaced to the player via the Chronicle panel, see issue #23) keeps the real facts, dates, and figures intact — nothing here should be invented or softened — but drops the meta "well documented, not just a story" qualifier entirely. The internal certainty/source grading stays as the authoring backbone (still cross-checked against `source_register.md`); it simply never surfaces as language in the prose itself.

The concrete replaced example: Torolv's dialogue previously branched on "Is this documented history?" / "Or is it just something people say?" — a source-criticism-as-dialogue-choice pattern that is exactly what this pivot moved away from. It's now "Why touch the mast?" / "Has this place always been this busy?", two belief-forward angles on the same underlying claim rather than a meta-question about the claim's evidentiary status.
**Status:** working pattern established and applied consistently across all three quests; still worth re-checking against new content types as M3 continues (e.g. religious/cosmological material, which `authenticity_and_sensitive_topics.md` §2.5-2.6 flags as more sensitive than what these three quests touched).

### 3. `research/dual_timeline_design.md` is still unwritten

**Unchanged by the reboot** — purely technical. The narrative framing in `concepts/prototype_recommendation.md` part (c) gives an overall recommendation, but the more technical map-strategy question — which strategy to use to represent two time layers at the same place (two separate maps, layered maps, or shared base geometry with swappable overlays) — was answered in practice by the M1 implementation (`vertical_slice_location.tscn`'s shared-ground-plus-two-dressing-layers architecture), but the dedicated research document itself was never filled in to formally record that reasoning.
**Why it matters:** low priority now that the pattern is already built and working, but worth writing up for future locations so the reasoning doesn't only live in code.
**What's needed:** a short retroactive write-up of the pattern actually used, next time a new location is built.

### 4. Several religious-history sources have only been read in summary form

**Unchanged by the reboot.** Key works (Stefan Brink's "How uniform was the Old Norse religion?", Gro Steinsland's *Norrøn religion*, Sæbjørg Walaker Nordeide's *The Conversion of Scandinavia*) were only confirmed via author background or publisher/portal summaries, not read in full text.
**Why it matters:** religion/cosmology is one of the most sensitive and contested topics in the whole project (see `authenticity_and_sensitive_topics.md` §2.5-2.6), and this doesn't change just because the delivery is now atmospheric rather than citation-forward — content that draws on these works' specific details should still be grounded in full text, not secondary summaries.
**What's needed:** obtain and read these works (or relevant chapters) in full before specific, detailed claims from them are used directly in game text.

### 5. Some specific place-claims in `continuity_into_modern_life.md` need further verification

**Unchanged by the reboot.** The document itself flags that (a) the section on medieval Oslo should be checked against a stronger primary source than general reference works (e.g. NIKU, Oslo Byarkiv, Riksantikvaren's preservation documentation), and (b) the vegvísir symbol's 19th-century origin should be cross-checked against a peer-reviewed source (currently only a popular-science source, nordicperspective.com).
**Why it matters:** both claims are used as central "aha" moments in `aha_moments.md` (moments 11 and 15) and should hold up to closer scrutiny before being written into specific game text — this matters just as much for atmospheric/belief-framed delivery as it did for citation-forward delivery, since the underlying claim still needs to be true even if it's no longer shown as a citation. (Worth noting: the vegvísir item is good material for the new direction regardless — it's already a real story about a "Viking" symbol that isn't actually from the Viking Age, which is exactly the kind of belief-vs-history gap the new tone wants to sit with rather than debunk outright.)
**What's needed:** a short, targeted follow-up search against the primary sources named above, with an update to `continuity_into_modern_life.md`'s source list.

---

## Resolved or superseded

- **Geographic scope for the first prototype** — resolved 2026-07-24: Lofoten/Vesterålen/Salten (see `DECISIONS.md`).
- **How to avoid the dual-universe becoming a time-travel-paradox puzzle** — resolved by the existing recommendation (two separate characters, no explained time-travel mechanism; the time-swap is a tool for the player, not an event the characters experience) and reconfirmed under the new frame: delivering connections as belief rather than fact doesn't reintroduce a need to explain time travel.
- **Data structure for historical claims with source citations in the game** — technically resolved (the `HistoricalClaim`/`DialogueNode`/`Quest` Resource classes exist and work), though the reboot changes how that structure is *used*: it still carries source/certainty fields for internal authoring purposes, but is no longer rendered to the player as a citation. See the M3 milestone breakdown for the issue reworking this.
- **Which Godot version to build on** — resolved in practice: the project is built on Godot 4.7.1 stable.
- **Copyright distance to Old School RuneScape** — substantially addressed by existing research (general, non-legal-advice principles on idea/expression distinction); low priority now that the primary mood references have shifted to *Edith Finch*/*Old Man's Journey*/*Outer Wilds*, though the OSRS legibility reference is still cited for UI readability specifically.
- **Sámi-Norse contact in Lofoten/Vesterålen/Salten (former item 7)** — resolved 2026-07-24 (GitHub issue #26): dedicated, source-critical research completed in `research/historical_scope.md` §12 (documented Sámi presence, Sámi-Norse contact, trade/*gafol*, the Sør-Salten conflict/coexistence debate, the Skjoldehamn find, Lule Sámi place names, reindeer-economy anachronism risk, hellegroper regional specificity) and `research/daily_life.md` §1.5, drawing on Sámi-institution and Sámi-scholar sources where available (Árran lulesamisk senter, Sámi allaskuvla/Ovttas, UiT researchers) alongside peer-reviewed work (Amundsen 2017, Svestad 2021, Holberg & Dørum 2021), registered as SRC-SAMI-001 through SRC-SAMI-012 in `source_register.md`. Concrete design guidance was written into `authenticity_and_sensitive_topics.md` §2.7. All existing Salten-adjacent game content (the Saltstraumen quest) was reviewed against that guidance — see §2.7.1 — and required no changes: it contains no Sámi-related content at all, and its Norse grave find is already appropriately hedged ("suspected"). The mandatory gate this item described is now satisfied for existing content; §2.7's guidance still applies to any *new* Salten-region content going forward.
- **Working title (former item 2)** — resolved 2026-07-25 (GitHub issue #33): six candidate titles were proposed, each grounded in specific game content or research rather than generic naming, with a quick (non-legal) collision check against existing game titles — see `docs/title_options.md`. The client chose **"What the Ground Remembers"** from the options presented. The actual code/config title update (`game/project.godot`, `main_menu.gd`) is tracked as GitHub issue #35, not bundled into #33.
