# Playtest — second round (M4)

## Purpose

Repeat the method of `playtest_m2_forste_runde.md` (real browser export, driven interactively via Playwright/Chromium — not the Godot editor's play button), but widened to cover all three locations/quests (Borg, Vágar, Saltstraumen) instead of one, specifically to check for regressions from the M3 rewrite (English text, new voice, citation-free dialogue/codex — issues #23/#24/#25) and to exercise the M4 polish work (loading shell, accessibility settings — issues #27/#30) together in an actual play session rather than in isolation. See GitHub issue #31.

## Method

- Exported with `godot --headless --export-release "Web" ../builds/web/index.html` (same command as prior playtests/spikes), served locally with `python3 -m http.server`.
- Driven via a persistent Chromium instance (Playwright, launched with `--remote-debugging-port`, reconnected via `connect_over_cdp` across separate script invocations) so the same page/session state could be inspected step-by-step across many tool calls, with a screenshot taken after each action. Console (`console`) and `pageerror` events were logged for the entire session.
- Covered session: main menu → Settings (set text size to Large, confirmed cascade to the main menu itself) → New Game → both eras of all three locations (Borg/Gunnhild, Vágar/Sigrun+Torolv, Saltstraumen/Bjørn), each quest played through every dialogue branch encountered to completion → Chronicle (codex) reviewed → Quest Log reviewed → full browser reload (`page.reload()`, not just a scene change) → "Continue" → Quest Log/Chronicle re-checked post-reload → pause menu → "Back to Main Menu".
- Cross-checked player-facing quest/dialogue/historical-claim resource files directly (`grep` for citation-style patterns and Norwegian-specific characters across `game/resources/`) as a second, independent check alongside reading the actual rendered screens — canvas-only rendering means there's no DOM text to search, so screenshots alone can't be grepped.

## Results — what worked

- **The full loop works end-to-end with zero console or page errors** across the entire session (main menu, all three quests in both eras, Chronicle, Quest Log, a full reload, pause menu, return to main menu).
- **All three quests completed correctly in actual play**, not just in the headless `test_quest_playthrough.gd` regression test: "The Rise in the Field" (Borg), "The Harbor That Never Stopped" (Vágar), "The Grave Under the Floor" (Saltstraumen). The non-linear completion design (`quest_manager.gd`'s `_advance_quest()` — a step's condition can be satisfied out of order, and the log "catches up" once earlier steps are also done) was directly observed live: talking to Torolv (Vágar's step 3 NPC) first left the quest showing all steps `[Pending]`, and only after the sign (step 1) and Sigrun (step 2) were also visited did the quest disappear from the active list in one jump — confirming the mechanic the M2 playtest documented still holds with real UI interaction, not just internal state.
- **No leftover citation-style text anywhere player-facing.** Both the live dialogue panels and the Chronicle screen show plain prose for every discovered historical claim (all 6: 2× Vágar, 2× Borg, 1× Saltstraumen, matching the grave already reviewed under issue #26) — no certainty tags, no `SRC-...` IDs, no bracketed qualifiers. Grepping the actual `.tres` files confirms `source_ids`/`certainty` exist only as internal authoring metadata (per `CLAUDE.md`'s "held internally, not displayed to the player") and are never read by `dialogue_ui.gd`, `chronicle_ui.gd`, or `discovery_log.gd`.
- **New voice reads consistently across all three NPCs and both eras.** Modern-era characters (Gunnhild, Sigrun, Bjørn) treat the underlying finds as real but only half-understood, with unease folded into scope/meaning rather than the fact itself, exactly matching the pattern `OPEN_QUESTIONS.md` item 2 describes: Gunnhild's "Makes you wonder what's under half the farms around here," Bjørn's "I try not to think about it too much. Doesn't stop me thinking about it." Torolv (the one Viking-Age speaker) never cites anything as documented — "That I couldn't tell you, trader - I only know here and now. But you're the one who walks both times, aren't you" — and the mast-touching/"they say the king means to build a church" material plays out exactly as the calibration note describes.
- **No leftover Norwegian text in anything player-facing.** A full grep of `game/resources/dialogue/`, `game/resources/quests/`, and `game/resources/historical_claims/` for Norwegian-specific characters (æ/ø/å) found exactly three resources with real Norwegian sentences — `dn_test_farewell.tres`, `qs_test_ask_ravnkjell.tres`, `qs_test_find_calendar.tres` (plus the related `quest_test_weekday_names.tres`/`dc_test_ask_about_tuesday.tres`). Cross-checked with `grep -rl` against `game/scenes/` and `game/scripts/`: these are referenced **only** by `test_resource_schema.gd` (a developer-facing headless regression test from issue #4/M0, run via `--script`, never part of the playable scene tree). Confirmed not a regression and not in scope for translation — they were never part of the M3 rewrite's three quests and are not reachable by a player. Everything else scanned (all real quest/dialogue/claim text) is English; the handful of remaining æ/ø/å hits are legitimate proper names and place names (Bjørn, Øystein, Vágar/Kabelvåg), not translation leftovers.
- **No Sámi-related content surfaced during play** anywhere in the Saltstraumen material (consistent with issue #26's review — the quest remains Norse-only, hedged as "a suspected Viking grave").
- **Accessibility settings (issue #30) work together with the rest of the session, not just in isolation:** text size set to "Large" from the main menu's Settings panel visibly affected the main menu, the world's top-bar buttons, dialogue text, the Quest Log, and the Chronicle — every screen touched during the session — and survived the full-page reload alongside the rest of the save.
- **Save/reload persistence is complete and correct:** era, player position, quest completion state ("No active quests" both before and after reload), and the full Chronicle (all 6 claims) all survived an actual `page.reload()`, not just a scene change.
- **Pause menu and return-to-main-menu flow (issues #20/#21) both work correctly**: the in-world "Menu" button opens a pause overlay with Resume/Volume/Back to Main Menu; returning to the main menu correctly re-hides the Chronicle/Quest Log toggle buttons until a game is active again.

## Findings — non-blocking, noted for possible follow-up

### 1. Accessibility settings aren't reachable from the in-game pause menu

The pause menu (opened via "Menu" while playing) only exposes a volume slider — text size and high contrast are only reachable via the main menu's Settings panel, meaning a player who wants larger text or higher contrast mid-session has to return to the main menu first (no progress is lost, since it's already saved, but it's an extra detour). Not blocking, and not part of issue #30's literal acceptance criteria (which only required the settings panel, not every menu). Worth a small follow-up if it comes up again during a later polish pass — not filed as its own issue given how minor it is.

### 2. First click on a not-yet-adjacent NPC/object only moves the player, doesn't interact

Clicking an NPC or interactable object that the player isn't already standing next to moves the player there but doesn't open dialogue on that same click — a second click (now that the player is adjacent) is needed. This matches the existing tap-to-move-then-interact design already implicitly exercised in the M2 playtest and is not a new regression; noted here only because it was directly, repeatedly observed this round across all three locations. No action needed.

## Acceptance criteria — status

- [x] Full session tested in an actual browser export: main menu → settings (including the new accessibility options) → new game → all three locations' quests played to completion in both eras → codex/quest log reviewed → save/reload via full page reload → continue.
- [x] Checked the M3 rewrite for regressions: no leftover Norwegian text in anything player-facing (the only Norwegian-language resources found are pre-existing, non-player-facing developer test fixtures, confirmed via cross-reference), no leftover inline citation-style text anywhere, dialogue reads consistently with the new voice across all three NPCs.
- [x] Findings documented in this file, following the M2 playtest's format.
- [x] No blocking bugs found — nothing needed fixing before closing this issue. The two non-blocking findings above are recorded for future polish, not filed as separate issues given their minor scope.
- [x] `docs/RESEARCH_INDEX.md` updated with a reference to this document.

## Last updated

2026-07-25
