# Prosjektvisjon — Norse Game

## Formål

Beskrive den kreative og designmessige retningen for spillet slik den er fastsatt av oppdragsgiver, som utgangspunkt for videre research og designarbeid.

## Sammendrag

Et rolig, utforskende top-down 2D-eventyr for iPhone/iPad (senere Android), bygget i Godot med GDScript. Spilleren opplever de samme geografiske stedene i to tidsperioder — et gjenkjennelig moderne nordisk/europeisk samfunn og det samme landskapet i vikingtiden — og oppdager dokumenterbare forbindelser mellom dem.

## Sist oppdatert

2026-07-23

## Status

foreløpig (kreativ retning fastsatt av oppdragsgiver i innledende brief; ikke justert av research ennå)

---

## Plattform og motor

- Motor: Godot (versjon avklares i `research/godot_mobile_technical_research.md`), språk: GDScript.
- **Primærplattform: web (nettleser)**, fastsatt av oppdragsgiver 2026-07-24 — se `DECISIONS.md`. iOS er et mulig, senere sekundært eksportmål fra samme Godot-kodebase; Android ikke prioritert.
- Kontrollmetode: tap/klikk-til-bevegelse som primær input, fungerer for både berøring og mus.

## Visuell og mekanisk retning

- Perspektiv: top-down.
- Estetikk: enkel, stilisert grafikk — pixel art eller tilsvarende. Inspirert av lesbarheten og atmosfæren i Old School RuneScape, **uten** å kopiere OSRS' grafikk, figurer, grensesnitt eller andre beskyttede uttrykk. Se `research/authenticity_and_sensitive_topics.md` og senere IP-vurderinger i teknisk research.
- Tempo og fokus: rolig utforskning, miljøfortelling, oppdagelser og «aha»-øyeblikk vektlegges over kamp. Kamp er ikke hovedmekanikken.
- Verdenen bygger på nordisk og europeisk natur, landskap, bosetninger og kulturmiljøer.

## Dobbeltuniverset

Kjernemekanikken i spillet: samme geografiske sted eksisterer i to tidslag —

1. Et gjenkjennelig, moderne nordisk/europeisk samfunn.
2. Det samme stedet i vikingtiden.

Spilleren skal oppleve **dokumenterbare** forbindelser mellom tidslagene — ikke fri fantasi og ikke en påstand om at samfunnene er like. Eksempler på forbindelsestyper som skal undersøkes (se `research/continuity_into_modern_life.md`):

- Moderne torg/møteplasser som kan ha historiske markeds- eller tingsteder i nærheten.
- Moderne veier som følger eldre ferdselsårer.
- Religiøse/sosiale samlingssteder med lagvis historie (må aldri fremstilles som fakta uten dokumentasjon).
- Gravhauger og kulturminner i eller ved moderne bebyggelse.
- Norrøne røtter i moderne ord, uttrykk og stedsnavn.
- Eiendomsgrenser og jordbrukslandskap med spor av eldre organisering.
- Sammensatte eller omdiskuterte forbindelser mellom moderne høytider/lover/normer og eldre tradisjoner.

Målfølelse for spilleren: *«Dette er ikke en helt fremmed verden. Historien ligger fremdeles i landskapet, språket og samfunnet rundt meg.»*

Viktig avgrensning: reduser opplevd avstand mellom tidsperiodene ved å vise dokumenterbare forbindelser, videreføringer, brudd og endringer — ikke ved å fremstille periodene som identiske.

### Geografisk avgrensning

Spillet er lagt til **Lofoten/Vesterålen/Salten** (Nordland) — fastsatt av oppdragsgiver 2026-07-24, se `docs/DECISIONS.md`. Spillets egne stedsnavn og geografi skal likevel være fiktive sammensetninger, ikke en presis gjengivelse av virkelige steder (jf. `concepts/location_pairs.md`). Regionen har en vesentlig samisk historisk og nålevende tilstedeværelse som krever egen, varsom behandling — se `docs/OPEN_QUESTIONS.md` punkt 10.

## Moderne visuell retning

Det moderne samfunnet skal **ikke** primært fremstilles gjennom kjøpesentre, skyskrapere, luksus eller «bling». Fokus på jordnære, bebodde, troverdige miljøer som fungerer godt sammen med historiske versjoner av samme sted — se full liste og research i `research/modern_environment.md` (mindre byer/tettsteder, bygder, gårder, havner, kirker/kirkegårder, museer, elver/fjorder/kystlandskap, steder der moderne bygg ligger tett på arkeologiske spor, m.m.).

Kontrasten mot vikingtiden skal komme fra endringer i mennesker, bruk, materialer og samfunn — ikke bare fra ekstrem moderne arkitektur.

## Historisk autentisitet som kjerneverdi

Se `research/`-mappen for full dekning. Nøkkelprinsipper:

- «Vikingene» er ikke én ensartet folkegruppe med én livsstil — skill mellom de som dro på vikingferd og den bredere befolkningen i vikingtidens samfunn.
- Skill konsekvent mellom historiske fakta, sannsynlige rekonstruksjoner, faglig omdiskuterte tolkninger, og senere myter/moderne populærkultur.
- Ikke romantiser vold, plyndring, trelldom eller sosial ulikhet. Ikke reduser samfunnet til krigere, konger og guder — hverdagsliv, arbeid, familie, lokal handel og landskapsbruk er minst like viktig.
- Religion skal ikke fremstilles som ett komplett, standardisert system.

## Avgrensning for denne fasen

Dette er en research- og dokumentasjonsfase. Ingen spillkode, ingen full Godot-prosjektstruktur, ingen ferdige spillressurser produseres ennå. Målet er et grundig, etterprøvbart og varig kunnskapsgrunnlag i `docs/` som senere økter (Claude Code, Codex, mennesker) kan bygge videre på uten å stole på chat-historikk.
