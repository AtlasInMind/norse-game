# Norse Game

## Prosjektoversikt

Et rolig, utforskende top-down 2D-eventyr for web (nettleser), bygget i Godot med GDScript. Spilleren opplever de samme geografiske stedene i to tidsperioder — et gjenkjennelig moderne nordisk/europeisk samfunn og det samme landskapet i vikingtiden — og oppdager dokumenterbare forbindelser mellom dem. Se `docs/PROJECT_VISION.md` for full kreativ retning. Spillets region er Lofoten/Vesterålen/Salten (Nordland).

Research- og dokumentasjonsfasen er ferdig (se `docs/RESEARCH_INDEX.md`). Prosjektet er nå i implementeringsfase, sporet via GitHub Issues/Milestones i dette repoet — se «Utviklingsfase» under.

## Plattform og motor

- Motor: Godot, språk: GDScript (versjon avklares i `docs/research/godot_mobile_technical_research.md`).
- **Plattform: web (nettleser) primært.** iOS er et mulig, senere sekundært eksportmål fra samme kodebase. Android ikke prioritert.

## Utviklingsfase

Prosjektet spores i GitHub Issues, gruppert i milestones M0–M5 (se `.claude/plans/federated-knitting-wolf.md` for hele planen bak dette, samt `docs/DECISIONS.md` 2026-07-24 for web-pivoten).

- **Start alltid med issue "0 — Start her"** hvis du er usikker på arbeidsflyten.
- Ta **laveste nummererte åpne issue i tidligste åpne milestone**. Ikke hopp foran i køen med mindre issuet selv sier noe annet.
- Hvert issue skal være selvstendig forståelig — les de linkede dokumentene i issuet, ikke anta kontekst fra tidligere samtaler.
- M2–M5 har foreløpig kun ett kort epic-issue hver; disse brytes ned i konkrete issues når milestonen blir aktuell — det er en gyldig oppgave i seg selv å bryte ned et epic til mindre issues.
- Placeholder-grafikk/lyd er forventet og greit fram til M3 (ekte assets kommer når oppdragsgiver har skaffet kunstner/verktøy).
- Alle kildekrav og autentisitetsprinsipper under gjelder likt for nytt spillinnhold (quests, dialog, stedsnavn) som for research-dokumentene.

## Historisk autentisitet er en hovedverdi

Dette er ikke et generisk fantasyspill. Historisk autentisitet, kildekritikk og respektfull behandling av vikingtidens samfunn (uten romantisering av vold/trelldom, uten å redusere religion til ett standardisert system, uten å behandle «vikingene» som én ensartet gruppe) er like viktig som spilldesignet. Se `docs/research/authenticity_and_sensitive_topics.md`.

## Les disse dokumentene først (i denne rekkefølgen)

1. `docs/PROJECT_VISION.md` — hva prosjektet er og hvorfor.
2. `docs/RESEARCH_INDEX.md` — inngangsport til alt kunnskapsgrunnlag, viser status per tema.
3. `docs/DECISIONS.md` — beslutninger tatt så langt, med begrunnelse.
4. `docs/OPEN_QUESTIONS.md` — ubesvarte spørsmål som påvirker retning.
5. Relevante filer i `docs/research/` og `docs/concepts/` etter behov.

**Stol ikke på tidligere samtalekontekst eller Claudes minne.** All relevant kunnskap skal finnes i `docs/`. Hvis noe viktig mangler der, er det ikke etablert ennå — ikke anta at det ble diskutert i en tidligere økt.

## Kildekrav

Alle vesentlige historiske påstander skal kildebelegges. Bruk formatet: Påstand, Geografisk område, Tidsperiode, Evidenstype, Sikkerhetsgrad (høy/middels/lav), Kilde (SRC-ID), Mulig bruk i spillet, Fare for feiltolkning. Skill alltid mellom dokumentert fakta, sannsynlig rekonstruksjon, faglig omdiskutert tolkning, og ren fiksjon/kreativ frihet — merk sistnevnte tydelig som sådan der det forekommer.

Nye kilder registreres i `docs/research/source_register.md` med en stabil ID (SRC-HIST-###, SRC-ARCH-###, SRC-REL-###, SRC-LANG-###, SRC-CONT-###, SRC-MOD-###, SRC-GAME-###, SRC-TECH-###) og refereres til med denne ID-en i andre dokumenter.

## Vedlikehold av dokumentasjonen

- Viktige beslutninger føres i `docs/DECISIONS.md` med dato, begrunnelse, kilder og konsekvens.
- `docs/RESEARCH_INDEX.md` skal holdes oppdatert — statusfeltet per tema må reflektere virkeligheten etter hver research-økt.
- Ikke overskriv eksisterende, verifisert innhold uten grunn — integrer forsiktig.
