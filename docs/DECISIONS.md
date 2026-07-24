# Beslutningslogg

## Formål

Kronologisk logg over vesentlige beslutninger i prosjektet, med begrunnelse, kildegrunnlag, konsekvenser og status (endelig/foreløpig).

## Sammendrag

Seks innledende beslutninger fastsatt direkte av oppdragsgiver i prosjektets brief, før dyp research, pluss to oppføringer fra syntese-/tilbakemeldingsfasen: en foreløpig prototypeanbefaling (Vestfold) som oppdragsgiver ikke valgte, og oppdragsgivers endelige regionvalg (Lofoten/Vesterålen/Salten).

## Sist oppdatert

2026-07-24

## Status

foreløpig

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
