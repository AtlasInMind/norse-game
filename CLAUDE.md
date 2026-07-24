# Norse Game

## Prosjektoversikt

Et rolig, utforskende top-down 2D-eventyr for web (nettleser), bygget i Godot med GDScript. Spilleren opplever de samme geografiske stedene i to tidsperioder — et gjenkjennelig moderne nordisk/europeisk samfunn og det samme landskapet i vikingtiden — og oppdager dokumenterbare forbindelser mellom dem. Se `docs/PROJECT_VISION.md` for full kreativ retning. Spillets region er Lofoten/Vesterålen/Salten (Nordland).

Research- og dokumentasjonsfasen er ferdig (se `docs/RESEARCH_INDEX.md`). Prosjektet er nå i implementeringsfase, sporet via GitHub Issues/Milestones i dette repoet — se «Utviklingsfase» under.

## Plattform og motor

- Motor: Godot, språk: GDScript (versjon avklares i `docs/research/godot_mobile_technical_research.md`).
- **Plattform: web (nettleser) primært.** iOS er et mulig, senere sekundært eksportmål fra samme kodebase. Android ikke prioritert.

## Utviklingsfase

Prosjektet spores i GitHub Issues, gruppert i milestones M0–M5 (se `.claude/plans/federated-knitting-wolf.md` for hele planen bak dette, samt `docs/DECISIONS.md` 2026-07-24 for web-pivoten).

Arbeidsflyt per issue:

1. Ta **laveste nummererte åpne issue i tidligste åpne milestone** (Milestones-fanen: M0 før M1 før M2, osv.). Ikke hopp foran i køen med mindre issuet selv sier noe annet under "Avhengigheter".
2. Åpne issuet og les "Relevante dokumenter"-lenkene i det — de peker til `docs/`-filer med all nødvendig bakgrunn. Hvert issue skal være selvstendig forståelig; ikke anta kontekst fra tidligere samtaler.
3. Følg "Akseptansekriterier" i issuet.
4. **Før commit/push: få koden gjennomgått av en frisk, uavhengig agent** uten kontekst fra samtalen (den skal finne bakgrunn selv, fra repoet/`docs/`, ikke bli briefet om hva som nettopp ble bygget). Rett opp reelle funn før du går videre — dette er en kvalitetssjekk, ikke en formalitet.
5. Når kriteriene er oppfylt og reviewen er håndtert: commit arbeidet, push til `main`, og lukk issuet med en kort kommentar om hva som ble gjort. **Ikke commit/push uten at issuets akseptansekriterier er oppfylt** — små, verifiserbare steg er bedre enn store, uverifiserte hopp.
6. **Før du går videre til neste issue: verifiser at det er trygt å kjøre `/clear`.** `git status` skal være rent (ingen ukommitterte/uspora filer), lokal `main` skal være i sync med `origin/main` (ingen ahead/behind), og issuet skal være lukket med en oppsummerende kommentar. Anta at neste økt ikke har noen minne om denne — all kontekst den trenger skal finnes i git-historikk + GitHub-issuer/kommentarer, ikke i samtaleminnet. Hvis et issue ikke ble fullført i økten, ikke lukk det og ikke lat som det er ferdig — la det stå åpent, ev. med en kommentar om status så langt.
7. Gå tilbake til punkt 1 og finn neste issue.

**Hvis issuet er merket `epic`:** det betyr det ikke er detaljert ennå. Oppgaven er da å bryte epicet ned i konkrete, mindre issues (bruk issue-malen `.github/ISSUE_TEMPLATE/task.md`), knyttet til samme milestone, basert på hva som faktisk er bygget så langt i prosjektet. Referer til de research-/concept-dokumentene i `docs/` som er relevante for akkurat den delen av epicet du bryter ned. M2–M5 har foreløpig kun ett kort epic-issue hver.

Placeholder-grafikk/lyd er forventet og greit fram til milestone M3 (ekte assets kommer når oppdragsgiver har skaffet kunstner/verktøy) — ikke vent på ekte assets for å gjøre fremgang på systemer/mekanikk. Alle kildekrav og autentisitetsprinsipper under gjelder likt for nytt spillinnhold (quests, dialog, stedsnavn) som for research-dokumentene.

## Historisk autentisitet er en hovedverdi

Dette er ikke et generisk fantasyspill. Historisk autentisitet, kildekritikk og respektfull behandling av vikingtidens samfunn (uten romantisering av vold/trelldom, uten å redusere religion til ett standardisert system, uten å behandle «vikingene» som én ensartet gruppe) er like viktig som spilldesignet. Se `docs/research/authenticity_and_sensitive_topics.md`.

**Region: Lofoten/Vesterålen/Salten.** Samisk historie i denne regionen skal behandles med samme varsomhet som beskrevet i `docs/research/authenticity_and_sensitive_topics.md` §2.7 og `docs/OPEN_QUESTIONS.md` punkt 10 — ikke som bakgrunnsdekor.

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
