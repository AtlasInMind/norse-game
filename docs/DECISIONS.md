# Beslutningslogg

## Formål

Kronologisk logg over vesentlige beslutninger i prosjektet, med begrunnelse, kildegrunnlag, konsekvenser og status (endelig/foreløpig).

## Sammendrag

Seks innledende beslutninger fastsatt direkte av oppdragsgiver i prosjektets brief, før dyp research, pluss to oppføringer fra syntese-/tilbakemeldingsfasen: en foreløpig prototypeanbefaling (Vestfold) som oppdragsgiver ikke valgte, og oppdragsgivers endelige regionvalg (Lofoten/Vesterålen/Salten). **Update (2026-07-24, English):** after M0-M2 were built, the client requested a creative reboot — deeper/more mystic tone, an 18-30 audience, and English going forward — see the final entry below for the full rationale and confirmed decisions. This log continues in English from that entry onward; earlier entries stay in Norwegian as historical record.

## Sist oppdatert / Last updated

2026-07-24

## Status

foreløpig / provisional

---

### 2026-07-23 — Motor og språk: Godot + GDScript

**Begrunnelse:** Valgt av oppdragsgiver (spørsmål om tech-stack besvart eksplisitt).
**Kilder/researchgrunnlag:** Bruker-brief, ingen teknisk research gjennomført ennå.
**Konsekvenser:** All teknisk research målrettes mot Godot; se `research/godot_mobile_technical_research.md`.
**Status:** foreløpig — bør bekreftes som fortsatt riktig valg etter teknisk research (versjon, mobilstøtte).

### 2026-07-23 — Plattform: iPhone/iPad først, Android senere

**Begrunnelse:** Fastsatt av oppdragsgiver.
**Kilder/researchgrunnlag:** Bruker-brief.
**Konsekvenser:** Første prototype trenger ikke Android-spesifikk testing. iOS safe areas og berøringsergonomi prioriteres i teknisk research.
**Status:** foreløpig.

### 2026-07-23 — Kontrollmetode: tap-to-move

**Begrunnelse:** Fastsatt av oppdragsgiver som primær inputmetode for små berøringsskjermer.
**Kilder/researchgrunnlag:** Bruker-brief.
**Konsekvenser:** Pathfinding/navigasjon må researches spesifikt for Godot; se teknisk research.
**Status:** foreløpig.

### 2026-07-23 — Kjernemekanikk: dobbeltunivers (moderne + vikingtid på samme geografiske steder)

**Begrunnelse:** Fastsatt av oppdragsgiver som spillets sentrale idé.
**Kilder/researchgrunnlag:** Bruker-brief. Krever dokumenterbare forbindelser, ikke fri fantasi — se `research/continuity_into_modern_life.md`.
**Konsekvenser:** Historisk research må eksplisitt lete etter sted-par med dokumenterte kontinuiteter. Se `concepts/location_pairs.md`.
**Status:** foreløpig (retning endelig, konkret gjennomføring avhenger av research).

### 2026-07-23 — Moderne visuell retning: jordnære miljøer, ikke kjøpesenter/skyskrapere/luksus

**Begrunnelse:** Fastsatt av oppdragsgiver for å understøtte kontrast mot vikingtiden uten «bling».
**Kilder/researchgrunnlag:** Bruker-brief.
**Konsekvenser:** Styrer research i `research/modern_environment.md`.
**Status:** foreløpig.

### 2026-07-23 — Estetisk referanse: lesbarhet/atmosfære inspirert av Old School RuneScape, uten kopiering

**Begrunnelse:** Fastsatt av oppdragsgiver, med eksplisitt krav om å unngå å kopiere OSRS' beskyttede uttrykk.
**Kilder/researchgrunnlag:** Bruker-brief.
**Konsekvenser:** Krever bevisst opphavsrettslig avstand; se åpent spørsmål 5 i `OPEN_QUESTIONS.md`.
**Status:** foreløpig.

### 2026-07-23 — Prototypeanbefaling: Vestfold-klyngen som geografisk avgrensning, og tidslagsbytte uten forklart tidsreise som narrativ hovedramme

**Begrunnelse:** Etter fullført førstepass-research på alle 12 research-temaer (unntatt `research/dual_timeline_design.md`, som fortsatt er tomt) er `concepts/prototype_recommendation.md` skrevet som en syntese av funnene. Den anbefaler: (a) **Vestfold (Larvik/Horten-klyngen: Kaupang, Bommestad, Borrehaugene)** som geografisk inspirasjonsgrunnlag for spillets første, fiktive lokasjon — valgt fordi dette er det tetteste, best dokumenterte området med flere sterke stedpar-kandidater (både kontinuitet og brudd) innenfor kort avstand av hverandre, se `concepts/location_pairs.md`; (b) en liten vertikal prototype begrenset til ett sammensatt kystnært sted, med kun tap-to-move, tidslagsbytte og et minimalt faktasystem — uten kamp, skylagring, Android eller prosedural generering, i tråd med `research/godot_mobile_technical_research.md` punkt 16; og (c) en narrativ hovedramme der spilleren styrer to atskilte figurer (én per tidslag) og tidslagsbyttet fungerer som et verktøy for spilleren, ikke en forklart tidsreise-mekanisme i selve fiksjonen — dette svarer på `OPEN_QUESTIONS.md` spørsmål 2 uten å kreve nye, kompliserte spillsystemer.
**Kilder/researchgrunnlag:** `research/continuity_into_modern_life.md` (stedpar-kandidater og sikkerhetsgrader), `research/modern_environment.md`, `research/settlements_and_landscape.md`, `research/game_design_references.md` (designlærdommer om ikke-forklart tidsbytte og «liten, tett verden»), `research/godot_mobile_technical_research.md` (hva som bør utelates fra første prototype). Full begrunnelse i `concepts/prototype_recommendation.md`.
**Konsekvenser:** Dersom godkjent, kan teknisk Godot-oppsett og videre stedsspesifikk research (navnegransking, detaljert miljødesign) målrettes mot Vestfold-inspirert geografi og den foreslåtte vertikale skiven. `docs/OPEN_QUESTIONS.md` spørsmål 1 og 2 oppdatert med henvisning til denne anbefalingen.
**Status:** **ikke valgt** — oppdragsgiver har i stedet fastsatt Lofoten/Vesterålen/Salten som geografisk avgrensning, se oppføringen under (2026-07-24). Anbefalingene i del (b) og (c) (liten vertikal prototype uten kamp/skylagring/Android; tidslagsbytte uten forklart tidsreise) står fortsatt ved lag som generelle prinsipper — det er kun selve regionvalget i del (a) som er erstattet.

### 2026-07-24 — Endelig regionvalg: Lofoten/Vesterålen/Salten

**Begrunnelse:** Oppdragsgiver har eksplisitt bestemt at spillets geografiske avgrensning skal være Lofoten/Vesterålen/Salten (Nordland), ikke den syntese-anbefalte Vestfold-klyngen. Dette er et direkte oppdragsgiver-valg, ikke utledet fra hvilken region som hadde tettest/sikrest kildedekning i førstepass-researchen.
**Kilder/researchgrunnlag:** Bruker-instruksjon (2026-07-24). Eksisterende research nevner allerede regionen delvis (Borg i Lofoten/Lofotr Vikingmuseum som langhus-eksempel i `research/settlements_and_landscape.md`; Lofoten som miljøeksempel i `research/modern_environment.md`), men regionspesifikk stedpar-research (tilsvarende dybden Vestfold fikk) gjenstår.
**Konsekvenser:**
- `concepts/location_pairs.md` del B, `concepts/prototype_recommendation.md` del (a) og relevante regionspesifikke eksempler i `concepts/aha_moments.md` må oppdateres med Lofoten/Vesterålen/Salten-kandidater — dette er startet som eget oppfølgingsarbeid (se `RESEARCH_INDEX.md`).
- Regionen har en vesentlig større og mer synlig samisk historisk og nålevende tilstedeværelse enn Vestfold (særlig Salten, lulesamisk område). Dette krever egen, varsom research på samisk-norrøn kontakt i jernalder/vikingtid i nettopp dette området, i tråd med prosjektets krav om å ikke redusere eller ekskludere folkegrupper — se nytt spørsmål i `OPEN_QUESTIONS.md`.
- Del (b) og (c) i `concepts/prototype_recommendation.md` (vertikal prototype-omfang og narrativ hovedramme) er ikke geografisk avhengige av regionvalget og kan i hovedsak videreføres, men bør sjekkes mot de nye stedpar-kandidatene når disse foreligger.
**Status:** endelig (regionvalget selv er bestemt av oppdragsgiver; konkrete stedpar innenfor regionen er fortsatt under arbeid).

### 2026-07-24 — Pivot til web som primærplattform; behold Godot

**Begrunnelse:** Oppdragsgiver ønsker web-spill (spillbart i nettleser) i stedet for iOS/iPad-først, med iOS som mulig senere sekundær eksport. Godot støtter offisielt HTML5/Web-eksport fra samme prosjekt som iOS/Android, og alt fullført teknisk research (`research/godot_mobile_technical_research.md`, `research/dual_timeline_design.md`) er motor-nivå (NavigationServer2D, TileMapLayer, Resource-basert datamodell) og uavhengig av eksportmål. Å bytte motor/rammeverk ville kastet bort dette arbeidet uten faglig grunn.
**Kilder/researchgrunnlag:** Bruker-instruksjon (2026-07-24). Eksisterende Godot-research bekrefter offisiell Web-eksportstøtte i prinsippet, men et web-spesifikt teknisk research-tillegg (lastetid, WASM-størrelse, mobilnettleser-ytelse) er ikke gjort ennå — flagget som tidlig oppgave (se GitHub-issue for M0-spiken).
**Konsekvenser:** `PROJECT_VISION.md` oppdatert. Prosjektet går nå over i implementeringsfase med et eget GitHub-repo (`AtlasInMind/norse-game`, privat) for teknisk og innholdsmessig arbeid, strukturert i milestones M0–M5 — se `.claude/plans/federated-knitting-wolf.md` for full plan.
**Status:** endelig (regionvalg og motorvalg er bestemt; web-ytelse i praksis skal verifiseres tidlig i M0 som egen spike, ikke antas).

---

### 2026-07-24 — Creative reboot: tone, audience, and language pivot

*(Written in English — see the language decision below. All entries above this point are historical record from the original Norwegian-language phase and are left as-is.)*

**Rationale:** With M0-M2 built (engine foundation, vertical-slice content, core UI systems — 21 closed issues), the client reviewed the result and found the direction read as childish/educational — closer to a museum app than a game aimed at adults. A structured review confirmed this concretely: every historical claim rendered to the player as literal citation text (e.g. "[Sannsynlig] ... (SRC-HIST-095)"), dialogue was written as a source-criticism catechism, `aha_moments.md` was built around "corrective" myth-busting beats, and no antagonists or real danger existed anywhere in the design. Against that, the project's own cited design references (*What Remains of Edith Finch*, *Old Man's Journey*, *Outer Wilds*) were already atmospheric and melancholic, and the "landscape remembers" framing already contained inherently eerie material (a longhouse plowed up under a field, a grave under a modern house's foundation) that was being defused with disclaimers rather than played up. Of everything decided before this point, only the region (Lofoten/Vesterålen/Salten) and the platform/engine (Godot, web) were actually marked final — tone, narrative frame, combat level, and language were all still open, making a pivot straightforward rather than disruptive.

**Requested by client:** a deeper, more mystic tone, a target audience of adults (roughly 18-30), and English instead of Norwegian for the game and project work going forward.

**Decisions confirmed with the client (2026-07-24):**
1. **Mystic scope:** folklore, omens, and seiðr appear in the fiction, but always filtered through what characters believe or fear — never confirmed as objectively real. No literal-magic mechanics.
2. **Sourcing system:** dropped substantially from player-facing UI. No more inline certainty tags or source IDs in dialogue or the codex. Internal research discipline (source register, certainty grading) stays as an authoring tool for accuracy and respect.
3. **Language:** English for everything going forward — `CLAUDE.md`, `docs/`, GitHub issues/commits, and in-game content. The existing Norwegian `research/`/`concepts/` corpus stays as an archived reference, translated piecemeal only when its content is actively adapted into new material.
4. **Historical grounding:** stays tight — same region, same real documented sites (Borg, Vágar, Saltstraumen), same internal rigor, just written with more atmosphere and maturity.

**Sources/basis:** Client instruction (2026-07-24), informed by a structured review of `PROJECT_VISION.md`, this decision log, `OPEN_QUESTIONS.md`, the `concepts/` documents, `research/authenticity_and_sensitive_topics.md`, the closed GitHub issues in milestones M0-M2, and the actual in-game dialogue/quest/UI text as built. Full planning record: `.claude/plans/i-want-you-to-bright-brooks.md`.

**Consequences:**
- `CLAUDE.md`, `PROJECT_VISION.md`, `OPEN_QUESTIONS.md`, and `GLOSSARY.md` rewritten in English for the new direction.
- `research/*.md` and `concepts/*.md` (12 + 4 files) remain Norwegian, archived/reference status — not retranslated wholesale.
- The M3 "Content expansion" epic (issue #11) rewritten to sequence: rework existing docs/systems/content first, then new content expansion, with the mandatory Sámi sensitivity review requirement carried over unchanged.
- M0-M2's closed issues and built systems (navigation, era-switching, dialogue tree, quest tracking, save system, UI framework) are unaffected — they're tone-agnostic and stay reused as-is. What changes is content and presentation, not architecture.
- The authenticity/sensitivity safeguards themselves (no romanticizing violence/slavery/inequality, no ethnic-purity framing, Sámi §2.7 requirements) are unchanged — they were never in tension with a more mature tone, and this pivot doesn't loosen them.
- Combat level remains an open question (see `OPEN_QUESTIONS.md`) — not resolved by this pivot; default working assumption is no combat system but real tension/danger/consequence.

**Status:** final (tone/audience/language direction is set; specific new content written under it is ongoing work, tracked via the M3 milestone).

### 2026-07-24 — Sámi sensitivity review completed (GitHub issue #26)

**Rationale:** `OPEN_QUESTIONS.md` (former item 7) and `authenticity_and_sensitive_topics.md` §2.7 required dedicated, source-critical research on Sámi presence and Sámi-Norse contact in Lofoten/Vesterålen/Salten before any Salten-associated content — existing or new — could be considered finished. A prior session had already written the core research (`research/historical_scope.md` §12, `research/daily_life.md` §1.5) and design guidance (`authenticity_and_sensitive_topics.md` §2.7), but the issue's remaining acceptance criteria — updating `RESEARCH_INDEX.md`'s status and reviewing existing Salten-adjacent content against the guidance — were not done, and several cross-references still pointed at `OPEN_QUESTIONS.md`'s pre-reboot item numbering.

**What was done:** all existing game content (`game/resources/`) was searched for Sámi-related material (characters, place names, symbols, religious references) — none exists yet, anywhere. The only Salten-adjacent content, the "The Grave Under the Floor" quest (a real, documented Norse grave find near Saltstraumen, SRC-HIST-090/091), was reviewed against §2.7's recommendations and required no changes: it makes no ethnic/cultural claims beyond an appropriately hedged "suspected Viking grave." This review is recorded in `authenticity_and_sensitive_topics.md` §2.7.1. `RESEARCH_INDEX.md` and `OPEN_QUESTIONS.md` were updated to reflect the research track as complete, and stale "OPEN_QUESTIONS.md punkt 10" cross-references (left over from the reboot's renumbering, now item 7 in the resolved section) were corrected in `source_register.md`, `daily_life.md`, `historical_scope.md`, and `concepts/prototype_recommendation.md`.

**Sources/basis:** `research/historical_scope.md` §12 (SRC-SAMI-001 through SRC-SAMI-012, plus SRC-HIST-093 and SRC-ARCH-022); `research/daily_life.md` §1.5; `authenticity_and_sensitive_topics.md` §2.7-2.7.1.

**Consequences:** the mandatory research/documentation gate for Salten-associated content is satisfied for everything in the repo as of this date. It does **not** expire — §2.7's guidance (avoid stereotyping, exoticizing, or erasing Sámi presence; don't flatten the coexistence/conflict question; use regionally precise material culture; consider institutional review for concrete Sámi content) still applies in full to any new Salten-region content written from here forward, and each new piece of such content should be checked against it before being considered finished.

**Status:** final.

### 2026-07-25 — Repo made public; GitHub Pages chosen for web hosting

**Rationale:** GitHub issue #32 (M5, web hosting) needed a hosting decision. GitHub Pages was preferred over Netlify/Vercel/Cloudflare Pages because it needs no new third-party account or credentials — the project already lives in this GitHub repo. GitHub Pages does not support serving from a private repository on a free plan, so the repo's visibility was the actual decision point. Presented to the client directly (repo made public vs. keeping it private on a paid plan vs. switching to a different host that supports private-repo deploys); the client chose making the repo public.

**Sources/basis:** Client instruction (2026-07-25), given directly in response to the trade-off as presented.

**Consequences:**
- `AtlasInMind/norse-game` is now a public GitHub repository — full source, `docs/` research corpus, and commit history are publicly visible, not just the hosted game itself.
- A quick scan for secrets/credentials in the full commit history was done before flipping visibility (none found) — this was precautionary due diligence, not a formal security audit.
- The game is deployed from a `gh-pages` branch (orphan, build output only, not project source) to `https://atlasinmind.github.io/norse-game/`. GitHub auto-enabled Pages on first push to that branch.
- Verified live: GitHub Pages serves `index.wasm` with gzip compression (confirmed via `Content-Encoding: gzip`) but **not** Brotli (requesting `br` returns the full uncompressed file) — see `docs/deployment.md` for the full measurement. This is worse than the Brotli-capable hosts considered but not chosen; revisit only if load time becomes a real concern once real (non-placeholder) assets are added.
- Deployment is currently manual (documented in `docs/deployment.md`); CI-driven auto-deploy on push to `main` was deliberately not built yet, since it requires a heavier Godot-in-CI setup and deploys aren't frequent enough yet to justify it.

**Status:** final (hosting choice and repo visibility are settled; revisiting either would be its own future decision, not an open item).
