# Norse Game

## Project overview

An atmospheric, exploration-driven top-down 2D game for the browser, built in Godot with GDScript. The player experiences the same real places in two time periods — a recognizable modern Norwegian setting and the same landscape in the Viking Age — and gradually pieces together what actually connects them. The connections are grounded in real research, but the game never hands the player a citation: they arrive as things people believe, fear, half-remember, or won't talk about. See `docs/PROJECT_VISION.md` for the full creative direction. The game's region is Lofoten/Vesterålen/Salten (Nordland, Norway).

**Target audience: adults, roughly 18-30. Tone: atmospheric, a little uneasy, willing to sit with hard truths rather than soften them.** Not horror, not fantasy-with-magic-that-works — folklore and belief are present in the fiction, but the game never confirms them as objectively true. See "Historical grounding" below for how this interacts with source rigor.

This is a creative-direction pivot from the project's original framing (calm, gentle, citation-forward, general-audience, Norwegian). See the **2026-07-24 "Creative reboot" entry in `docs/DECISIONS.md`** for the full rationale and the confirmed decisions behind it. Research and factual grounding from the earlier phase remain valid and are still used internally — what changed is tone, audience, presentation, and language.

**Language: English, going forward**, for this file, `docs/`, GitHub issues/commits, and all in-game content. The existing Norwegian research corpus (`docs/research/`, `docs/concepts/`) stays in place as an archived reference — see "Documents to read first" below.

Research and documentation-phase foundations are indexed in `docs/RESEARCH_INDEX.md`. The project is in implementation phase, tracked via GitHub Issues/Milestones in this repo — see "Development phase" below.

## Platform and engine

- Engine: Godot 4.7, language: GDScript.
- **Platform: web (browser), primary.** iOS is a possible, later secondary export target from the same codebase. Android is not prioritized.

## Development phase

The project is tracked in GitHub Issues, grouped into milestones M0–M5 (see `.claude/plans/federated-knitting-wolf.md` for the plan behind this structure, `docs/DECISIONS.md` 2026-07-24 for the web pivot, and the 2026-07-24 "Creative reboot" entry for this direction change).

Workflow per issue:

1. Take the **lowest-numbered open issue in the earliest open milestone** (Milestones tab: M0 before M1 before M2, and so on). Don't jump ahead in the queue unless the issue itself says otherwise under "Dependencies."
2. Open the issue and read its "Relevant documents" links — they point to `docs/` files with all necessary background. Every issue should be understandable on its own; don't assume context from earlier conversations.
3. Follow the issue's "Acceptance criteria."
4. **Before commit/push: get the code reviewed by a fresh, independent agent** with no context from the conversation (it should find background itself, from the repo/`docs/`, not be briefed on what was just built). Fix real findings before moving on — this is a quality check, not a formality.
5. Once the criteria are met and the review is handled: commit the work, push to `main`, and close the issue with a short comment on what was done. **Don't commit/push unless the issue's acceptance criteria are met** — small, verifiable steps beat large, unverified leaps.
6. **Before moving to the next issue: verify it's safe to run `/clear`.** `git status` should be clean (no uncommitted/untracked files), local `main` should be in sync with `origin/main` (no ahead/behind), and the issue should be closed with a summary comment. Assume the next session has no memory of this one — all the context it needs should live in git history + GitHub issues/comments, not in conversation memory. If an issue wasn't finished in the session, don't close it and don't pretend it's done — leave it open, optionally with a status comment.
7. Go back to step 1 and find the next issue.

**If the issue is labeled `epic`:** it hasn't been detailed yet. The task is then to break the epic down into concrete, smaller issues (use the issue template `.github/ISSUE_TEMPLATE/task.md`), tied to the same milestone, based on what's actually been built in the project so far. Reference the `docs/` documents relevant to the specific part of the epic being broken down. M4–M5 currently each have one short epic issue.

Placeholder graphics/audio are expected and fine until real art/audio work actually starts under M3 (it depends on the client securing an artist/tools) — don't wait for real assets to make progress on systems/mechanics. All source requirements and authenticity principles below apply equally to new game content (quests, dialogue, place names) as to the research documents.

## Historical grounding is a core value — held internally, not displayed to the player

This is not a generic fantasy game, and it doesn't romanticize or launder Viking-Age society. Historical grounding, source criticism, and respectful treatment of Viking-Age society — without romanticizing violence/slavery, without reducing religion to one standardized system, without treating "the Vikings" as one homogeneous group — matter as much as the game design. See `docs/research/authenticity_and_sensitive_topics.md`.

**Important change from the original direction:** the game used to show its sourcing directly to the player — every historical claim in dialogue displayed a certainty tag and source ID inline (e.g. "[Probable] ... (SRC-HIST-095)"). That's gone. The research discipline stays **internal**: every claim that grounds a piece of writing should still be traceable to `docs/research/source_register.md`, and writers (including future Claude sessions) should still know whether something is documented fact, plausible reconstruction, debated interpretation, or later legend — but none of that apparatus is printed on screen. In the fiction, it shows up as belief: a character who avoids a field, a rumor half-told, a modern account nobody wants to investigate properly. Whether it was "true" is never resolved for the player.

**Region: Lofoten/Vesterålen/Salten.** Sámi history in this region must be treated with the same care described in `docs/research/authenticity_and_sensitive_topics.md` §2.7 and `docs/OPEN_QUESTIONS.md` — not as background decoration. This requirement is unchanged by the tone pivot; nothing about "more mature/mystic" licenses stereotyping, exoticizing, or erasing Sámi presence.

## Documents to read first (in this order)

1. `docs/PROJECT_VISION.md` — what the project is and why.
2. `docs/RESEARCH_INDEX.md` — entry point to the research corpus, shows status per topic. Its indexed research files are still in Norwegian — see the archive note at the top of that document.
3. `docs/DECISIONS.md` — decisions made so far, with rationale.
4. `docs/OPEN_QUESTIONS.md` — unanswered questions that affect direction.
5. Relevant files in `docs/research/` and `docs/concepts/` as needed (Norwegian; consult for factual grounding — no need to translate unless you're actively adapting that specific content into new game text).

**Don't rely on prior conversation context or Claude's memory.** All relevant knowledge should be in `docs/`. If something important is missing there, it hasn't been established yet — don't assume it was discussed in an earlier session.

## Source requirements (internal authoring discipline)

Every significant historical claim used to ground a piece of writing should be traceable to a source. Use the format: Claim, Geographic area, Time period, Evidence type, Certainty (high/medium/low), Source (SRC-ID), Possible use in the game, Risk of misinterpretation. Always distinguish, in the authoring process, between documented fact, probable reconstruction, academically debated interpretation, and pure fiction/creative license — mark the latter clearly as such wherever it's tracked, even though none of this grading is shown to the player directly (see "Historical grounding" above).

New sources are registered in `docs/research/source_register.md` with a stable ID (SRC-HIST-###, SRC-ARCH-###, SRC-REL-###, SRC-LANG-###, SRC-CONT-###, SRC-MOD-###, SRC-GAME-###, SRC-TECH-###) and referenced by that ID in other documents.

## Maintaining the documentation

- Important decisions go in `docs/DECISIONS.md` with date, rationale, sources, and consequence.
- `docs/RESEARCH_INDEX.md` should be kept up to date — the status field per topic must reflect reality after each research/content session.
- Don't overwrite existing, verified content without reason — integrate carefully.
- New documents, and any existing document being substantially reworked, should be written in English. The Norwegian `docs/research/` and `docs/concepts/` corpus stays as an archived reference — translate specific passages on demand when actively adapting that content into new material, not wholesale.
