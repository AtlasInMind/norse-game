# Åpne spørsmål

## Formål

Samle uløste spørsmål som påvirker prosjektets retning, hvorfor de er viktige, og hva som kreves for å besvare dem.

## Sammendrag

Ti åpne spørsmål: de seks opprinnelige, identifisert direkte fra det innledende briefet før dyp research var gjennomført, tre oppdaget under den kreative syntesefasen (7–9), og ett nytt (10) oppdaget etter at oppdragsgiver fastsatte endelig region. Spørsmål 1 er nå **løst** (se `docs/DECISIONS.md`, 2026-07-24). Spørsmål 2 har fortsatt en foreløpig anbefaling som ikke er regionavhengig.

## Sist oppdatert

2026-07-24

## Status

foreløpig

---

## 1. Geografisk avgrensning for første prototype — LØST

**Hvorfor viktig:** All historisk research (bosetninger, stedsnavn, arkeologi) blir langt mer presis og etterprøvbar hvis den knyttes til ett konkret sted/region fremfor "Norden generelt".

**Løsning (2026-07-24):** Oppdragsgiver har bestemt **Lofoten/Vesterålen/Salten** som spillets geografiske avgrensning — se `docs/DECISIONS.md`, 2026-07-24. Dette erstatter syntesefasens Vestfold-anbefaling. Regionspesifikk stedpar-research (tilsvarende dybden Vestfold-anbefalingen fikk) er igangsatt som eget oppfølgingsarbeid; se `RESEARCH_INDEX.md` for status på `concepts/location_pairs.md`, `concepts/prototype_recommendation.md` og regionspesifikke tillegg i `research/`-mappen.

## 2. Hvordan unngå at dobbeltuniverset blir et tidsreiseparadoks-puslespill

Brukeren har eksplisitt bedt om et forslag til hovedkonflikt som ikke gjør tidsreiser unødvendig kompliserte.
**Hvorfor viktig:** Uten en enkel narrativ ramme risikerer dobbeltunivers-mekanikken å kreve mye forklaring, noe som bryter med målet om rolig utforskning fremfor forelesning.
**Hva kreves:** Designforslag i `research/dual_timeline_design.md` og `concepts/prototype_recommendation.md`.

**Foreløpig anbefaling (2026-07-23/24 — venter på oppdragsgivers godkjenning):** `concepts/prototype_recommendation.md` del (c) foreslår at spilleren styrer to atskilte figurer (én per tidslag) på samme sted, uten at noen tidsreise-mekanisme forklares i selve fiksjonen — tidslagsbyttet er et verktøy for spilleren, ikke en hendelse figurene opplever. Dette løser problemet for en vertikal prototype, men `research/dual_timeline_design.md` (teknisk kart-strategi: to kart / lagdelte kart / delt grunngeometri) er fortsatt ikke skrevet — se nytt punkt 7 under.

## 3. Datastruktur for historiske påstander med kildehenvisning i spillet

**Hvorfor viktig:** Brukeren krever at spillinnhold (oppdrag, dialog, historiske fakta) kan kobles til kildegrunnlag uten å hardkode alt i enkeltscript.
**Hva kreves:** Teknisk anbefaling i `research/godot_mobile_technical_research.md`.

## 4. Hvilken Godot-versjon skal legges til grunn

**Hvorfor viktig:** iOS/iPadOS/Android-støtte, TileMap-arbeidsflyt og eksport-verktøy endrer seg mellom Godot-versjoner.
**Hva kreves:** Avklares i `research/godot_mobile_technical_research.md` med henvisning til offisiell, versjonsspesifikk dokumentasjon.

## 5. Opphavsrettslig avstand til Old School RuneScape

Brukeren har bedt om lesbarhet/atmosfære inspirert av OSRS, men uten å kopiere beskyttede uttrykk.
**Hvorfor viktig:** Uklar avstand kan skape juridisk risiko eller tvinge frem sen redesign.
**Hva kreves:** Konkrete, generelle prinsipper (ikke juridisk rådgivning) i `research/godot_mobile_technical_research.md` og/eller `research/authenticity_and_sensitive_topics.md`.

## 6. Hvor mye kamp skal spillet ha, presist

Brukeren sier kamp skal vektlegges mindre enn utforskning, men ikke at kamp er fraværende.
**Hvorfor viktig:** Påvirker omfang og hvilke systemer prototypen trenger.
**Hva kreves:** Beslutning i `docs/DECISIONS.md` når `concepts/prototype_recommendation.md` er klar — trolig et spørsmål å avklare med oppdragsgiver før prototype-fasen, ikke noe research alene kan svare på.

## 7. `research/dual_timeline_design.md` er fortsatt ikke skrevet

**Nytt spørsmål, oppdaget under syntesefasen (2026-07-24).** Dette er det eneste av de 12 opprinnelige research-temaene som fortsatt er tomt. `concepts/prototype_recommendation.md` del (c) gir en foreløpig, overordnet narrativ anbefaling, men den mer tekniske/designmessige delen av spørsmålet — hvilken kart-strategi som skal brukes for å representere to tidslag på samme sted (to separate kart, lagdelte kart, eller delt grunngeometri med utskiftbare overlegg) — er ikke besvart.
**Hvorfor viktig:** Dette er en forutsetning for faktisk Godot-implementasjon av tidslagsbyttet, og bør avklares før teknisk oppsett starter (se `RESEARCH_INDEX.md`, «Neste steg for neste agent»).
**Hva kreves:** En fremtidig research-/designøkt bør fylle ut `research/dual_timeline_design.md` i tråd med dets opprinnelige formål, med henvisning til de tekniske rammene i `research/godot_mobile_technical_research.md` (TileMapLayer-arbeidsflyt, `NavigationServer2D`).

## 8. Flere religionshistoriske kilder er kun lest i sammendrag/portalform

**Nytt spørsmål, oppdaget under syntesefasen (2026-07-24), hentet fra `research/religion_and_worldview.md`s egne kildenotater.** Sentrale verk (Stefan Brinks «How uniform was the Old Norse religion?», Gro Steinslands *Norrøn religion*, Sæbjørg Walaker Nordeides «The Conversion of Scandinavia») er kun bekreftet via forfatterbakgrunn/forlagsomtale eller forskningsportal-sammendrag, ikke lest i fulltekst, i denne research-runden.
**Hvorfor viktig:** Religion/kosmologi er et av de faglig mest sensitive og omdiskuterte temaene i hele prosjektet (jf. `authenticity_and_sensitive_topics.md` 2.5–2.6), og spillinnhold som siterer disse verkenes detaljer direkte bør bygge på fulltekst, ikke sekundærsammendrag.
**Hva kreves:** Skaff og les disse verkene (eller relevante kapitler) i fulltekst før spesifikke, detaljerte påstander fra dem brukes direkte i spilltekst.

## 9. Enkelte konkrete stedspåstander i `continuity_into_modern_life.md` bør verifiseres videre

**Nytt spørsmål, oppdaget under syntesefasen (2026-07-24), hentet fra dokumentets egen «Videre research anbefalt»-seksjon.** Dokumentet flagger selv at (a) Middelalderbyen Oslo-avsnittet bør verifiseres mot en sterkere primærkilde enn allmenne oppslagsverk (f.eks. NIKU, Oslo Byarkiv, Riksantikvarens fredningsdokumentasjon), og (b) vegvísir-symbolets 1800-tallsopprinnelse bør krysssjekkes mot en fagfellevurdert kilde (per nå kun populærfaglig nordicperspective.com).
**Hvorfor viktig:** Begge påstandene brukes som sentrale «aha»-øyeblikk i `concepts/aha_moments.md` (øyeblikk 11 og 15) og bør derfor tåle nærmere kildegranskning før de eventuelt formuleres direkte i spilltekst.
**Hva kreves:** Et kort, målrettet oppfølgingssøk mot de nevnte primærkildene, med oppdatering av `continuity_into_modern_life.md`s kildeliste.

## 10. Samisk-norrøn kontakt i Lofoten/Vesterålen/Salten er ikke undersøkt

**Nytt spørsmål, oppdaget 2026-07-24 da oppdragsgiver fastsatte regionen.** All hittil gjennomført research (spesielt `continuity_into_modern_life.md` og `authenticity_and_sensitive_topics.md`) er skrevet med Sør-/Midt-Norge og generelle nordiske forhold som implisitt bakteppe. Lofoten/Vesterålen/Salten har en vesentlig større og mer synlig samisk historisk og nålevende tilstedeværelse (særlig Salten, lulesamisk område) enn f.eks. Vestfold.
**Hvorfor viktig:** Prosjektets eget krav om å ikke redusere eller ekskludere folkegrupper, og om å behandle sosial organisering/kulturmøter kildekritisk (jf. `PROJECT_VISION.md` og `authenticity_and_sensitive_topics.md`), gjelder like mye for samisk-norrøne forhold som for norrøn indre sosial lagdeling. Å legge spillet til denne regionen uten å undersøke og bevisst forholde seg til samisk historie ville være en alvorlig kunnskapsmangel, ikke en nøytral utelatelse.
**Hva kreves:** Dedikert, kildekritisk research på dokumentert samisk tilstedeværelse og samisk-norrøn kontakt (handel, sameksistens, konflikt, overlappende landbruk) i nettopp dette området i jernalder/vikingtid, med prioritet på samiske institusjoners og fagfolks egne kilder (f.eks. Sametinget, Samisk høgskole, Árran lulesamisk senter, relevant fagfellevurdert forskning), samt konkret designveiledning for hvordan spillet unngår stereotypisering, eksotisering eller usynliggjøring. Igangsatt som eget forskningsspor 2026-07-24.
