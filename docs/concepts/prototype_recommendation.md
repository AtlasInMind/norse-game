# Anbefaling for vertikal prototype

## Formål

Anbefale geografisk avgrensning for første versjon, en liten vertikal prototype, og et forslag til hovedkonflikt som ikke gjør dobbeltunivers-mekanikken unødvendig komplisert.

## Viktig: dette er en anbefaling, ikke en beslutning

Alt i dette dokumentet er et **forslag til oppdragsgiver**, syntetisert fra research-fasen. Ingenting her er endelig før oppdragsgiver har godkjent det. Se `docs/DECISIONS.md` for en tilsvarende, eksplisitt merket "foreløpig, venter på godkjenning"-oppføring, og `docs/OPEN_QUESTIONS.md` spørsmål 1 og 2 for hvilke åpne spørsmål denne anbefalingen svarer på (uten å lukke dem endelig).

## Sammendrag

**Oppdatert 2026-07-24:** Oppdragsgiver har fastsatt at spillets geografiske avgrensning skal være **Lofoten/Vesterålen/Salten** (se `docs/DECISIONS.md`), ikke den tidligere syntese-anbefalte Vestfold-klyngen. Del (a) under er derfor skrevet om fullstendig: den anbefaler nå **Vestvågøy/Vågan-klyngen i Lofoten (Borg + Vágar/Kabelvåg)** som den konkrete underregionen for selve den vertikale prototypen, ut fra samme resonnement som tidligere (tettest, best dokumenterte klynge — nå anvendt på den nye regionen). Del (b) og (c) — omfang for den vertikale prototypen og narrativ hovedramme — er i hovedsak uendret, siden disse anbefalingene ikke var geografisk avhengige av Vestfold-valget, men enkelte konkrete stedshenvisninger er oppdatert til den nye regionen der det er naturlig. Prototypen bør fortsatt begrense seg til **ett lite, fiktivt, sammensatt sted**, med kun to systemer i sentrum: tidslagsbytte og tap-to-move-utforskning, uten kamp, uten prosedural generering, uten skylagring. Hovedkonflikten anbefales fortsatt løst **uten** en forklart tidsreise-mekanisme.

## Sist oppdatert

2026-07-24 (del (a) skrevet om for Lofoten/Vesterålen/Salten; del (b)/(c) videreført med oppdaterte stedshenvisninger)

## Status

foreløpig — anbefaling, venter på oppdragsgivers godkjenning (regionvalget i seg selv er endelig fastsatt, se `docs/DECISIONS.md`; den konkrete underregionen for prototypen i del (a) er fortsatt en anbefaling)

---

## (a) Anbefalt underregion for den vertikale prototypen: Vestvågøy/Vågan-klyngen (Borg + Kabelvåg), Lofoten

### Anbefaling
Bruk **Vestvågøy kommune** (Borg) og nabokommunen **Vågan** (Kabelvåg/Vágar) som research- og inspirasjonsgrunnlag for spillets første, konkrete geografiske område innenfor den fastsatte regionen. Spillets faktiske stedsnavn, gårder og NPC-er skal likevel være **fiktive sammensetninger** — ikke en presis gjengivelse av de virkelige stedene (jf. `location_pairs.md`).

### Begrunnelse (kort)
1. **Geografisk tetthet av dokumenterte stedpar-typer.** Sentral-Lofoten har den samme typen tette klynge av sterke kandidater som gjorde Vestfold attraktivt i den forrige anbefalingen: **Borg** (`location_pairs.md` B1, kategori c, høy sikkerhet — et 83 meter høvdinghus oppdaget ved pløying i 1981, i dag Lofotr Vikingmuseum) ligger i Vestvågøy kommune, og **Vágar/Kabelvåg** (B2, kategori b/c/d, lav-middels til høy sikkerhet avhengig av delkilde — et dokumentert handels-/fiskevær med kontinuerlig tilknytning til Lofotfisket fra middelalder til i dag) ligger i nabokommunen Vågan, kort avstand unna på E10.
2. **Variasjon i "type forbindelse" på ett sted.** Klyngen gir tilgang til **både** et "skjult funn under ordinær bruk"-eksempel (Borg — pløyd opp av en bonde, samme mønster som Gjellestad) **og** et sjeldent **reell kontinuitet**-eksempel (Vágar/Kabelvåg — motsatt av Kaupangs brudd-mønster, se `continuity_into_modern_life.md` seksjon 15.1) — igjen den nyanserte blandingen prosjektvisjonen etterspør.
3. **Solid, om enn noe mer sammensatt, kildegrunnlag.** Borg er svært godt dokumentert arkeologisk (museum, fagfellevurdert-nivå formidling). Vágar/Kabelvåg har et sammensatt kildebilde — sagaomtaler med lavere sikkerhet, men en solid arkeologisk bosetningsdatering og en høyt pålitelig middelaldersk administrativ kilde (1384-forordningen) — se `historical_scope.md` seksjon 10.2 for full drøfting av hvorfor dette kildebildet er lagdelt, ikke jevnt sikkert.
4. **God match med "jordnær moderne visuell retning" og fiskevær-tematikken.** Lofoten generelt, og denne klyngen spesielt, har akkurat den typen jordnære, arbeidende kystmiljøer (fiskevær, rorbuer, fiskehjeller, aktiv fiskerinæring) som `modern_environment.md` miljøtype 17 og `PROJECT_VISION.md` etterspør — ikke storby, ikke kjøpesenter.

### Alternativ vurdert
**Saltstraumen/Skjerstad-klyngen i Salten** (Ljønes høvdingsete, den nylig funnede vikinggraven under et bolighus, selve Saltstraumen-fenomenet som et uforanderlig naturlig ankerpunkt) er også en sterk kandidat, og har den fordelen at den kombinerer et dramatisk, lett gjenkjennelig naturfenomen med dokumentert arkeologi. Klyngen er likevel noe mer geografisk spredt enn Vestvågøy/Vågan (Ljønes og selve strømmen ligger noen kilometer fra hverandre, og begge et godt stykke fra Bodø sentrum), og det sterkeste enkeltfunnet der (2021-vikinggraven) er mindre i skala enn Borg-hallen. Salten-klyngen anbefales derfor som en **sekundær kandidat** — godt egnet til en senere utvidelse av spillverdenen, eller dersom produksjonshensyn (f.eks. nærhet til Bodø lufthavn) gjør Salten mer praktisk enn Lofoten. Steigen/Engeløya (tingsted/lagmannssete) bør uansett vurderes som inspirasjon for én lokasjon i spillet uavhengig av hovedområde, på samme måte som Mære-mønsteret ble anbefalt videreført uavhengig av regionvalg i den opprinnelige Vestfold-versjonen av dette dokumentet.

### Hva anbefalingen IKKE betyr
- Spillet skal **ikke** gjengi Borg, Kabelvåg eller andre navngitte, reelle steder presist eller navngi dem direkte som spillsteder.
- Regionvalget låser ikke spillets fiksjonelle geografi til virkelige norske stedsnavn — spillets egen verden skal ha oppdiktede navn, riktignok bygget etter ekte navnegranskingsprinsipper (jf. `research/language_and_place_names.md`).
- Anbefalingen tar ikke stilling til den samiske historiske og nålevende tilstedeværelsen i regionen utover å henvise videre — se `docs/OPEN_QUESTIONS.md` (tidligere punkt 10, nå løst) og den samisk-norrøne kontakt-researchen (`research/authenticity_and_sensitive_topics.md` 2.7, `research/historical_scope.md` 12), som nå er fullført — se `docs/RESEARCH_INDEX.md`.

---

## (b) Anbefalt vertikal prototype

### Omfang: ett lite, sammensatt sted
Bygg **ett** fiktivt, kystnært fiskevær — en liten vik med et gårdstun/høvdingtun, et fiskevær med rorbuer og fiskehjeller, og et gravfelt, inspirert av Borg + Vágar/Kabelvåg-mønstrene i del (a) — fremfor et stort kart. Dette er direkte i tråd med `game_design_references.md`s tverrgående lærdom "prioriter tett, detaljert innhold i en liten verden fremfor stor, tynn verden" (A Short Hike-lærdommen).

**Konkret forslag til vertikal skive:**
- **Modernt lag:** et lite, aktivt fiskevær med rorbuer, kai og fiskehjeller (jf. `modern_environment.md` miljøtype 17), et jorde med en synlig, gressbevokst haug i utkanten, og et kort stykke kyst med en enkel fergekai eller båtutsett.
- **Vikingtidslag:** samme geografi — et gårdstun med langhus og naust ved viken (jf. Borg-mønsteret), en aktiv gravhaug i bruk, og en landings-/ferdselsplass som følger nøyaktig samme linje som fiskeværet/kaien i moderne-laget.
- **Innhold:** 2–3 av oppdragene fra `quest_opportunities.md`, valgt fordi de krever minst systemkompleksitet (ingen kampsystem, ingen store dialogtrær) og likevel demonstrerer kjernefølelsen fullt ut. Merk at `quest_opportunities.md` fortsatt er skrevet med generelle/Vestfold-orienterte eksempler (Bommestad/Borre-typen "Veien som alltid har vært der", "Kollen i hagen") — disse mønstrene fungerer fortsatt som oppdragstype (jorde/haug/ferdselsåre finnes også i Lofoten-versjonen over), men bør sjekkes mot en regional oppdatering av `quest_opportunities.md` før produksjon, se `docs/OPEN_QUESTIONS.md`.

### Systemer som SKAL være med i prototypen
- Tap-to-move via `NavigationServer2D`/`NavigationAgent2D` (anbefalt i `godot_mobile_technical_research.md` for organisk, håndtegnet terreng).
- Tidslagsbytte-mekanikk (se del c under for narrativ ramme).
- Et minimalt `Resource`-basert datasystem for 2–3 dialoger/faktapåstander med sikkerhetsgrad-felt (jf. `godot_mobile_technical_research.md` punkt 12) — nok til å bevise konseptet, ikke et fullt opplevelsessystem.
- Lokal lagring (`FileAccess` + JSON i `user://`).
- Grunnleggende safe-area-håndtering for iPhone (siden dette er enkelt å bygge inn fra start, men vanskelig å ettermontere).

### Systemer som SKAL utelates fra prototypen
Direkte i tråd med `godot_mobile_technical_research.md` punkt 16:
- Android-eksport, skylagring/synkronisering, flerspiller/nettverk, in-app-kjøp/push-varsler.
- Avansert kampsystem (visjonen er eksplisitt at kamp ikke er hovedmekanikken — se likevel `OPEN_QUESTIONS.md` spørsmål 6, som fortsatt trenger et oppdragsgiver-svar på *hvor mye* kamp som skal finnes på sikt).
- Stort, generelt dialog-/questrammeverk — bygg det minimale skjemaet for 2–3 oppdrag først.
- Full skjermleser-/tilgjengelighetsdekning, prosedural verdensgenerering, flere skjermstørrelse-strategier samtidig (velg én stretch-strategi, test den, utsett resten).

---

## (c) Anbefalt narrativ hovedramme (svar på `OPEN_QUESTIONS.md` spørsmål 2)

### Problemet
Oppdragsgiver har eksplisitt bedt om at dobbeltuniverset **ikke** skal bli et tidsreiseparadoks-puslespill som krever mye forklaring (tidsmaskiner, kausallogikk, "hva skjer hvis jeg endrer fortiden" osv.) — dette bryter med målet om rolig utforskning fremfor forelesning.

### Anbefaling: tidslagsbytte som grensesnitt, ikke som forklart hendelse i fiksjonen
Fremfor å finne opp en tidsreise-mekanisme (portaler, magiske gjenstander, forskningsprosjekter) som krever egen forklaring og risikerer å introdusere paradokser, anbefales det at:

1. **Spilleren styrer to atskilte figurer** — én i moderne-laget, én i vikingtidslaget — på samme geografiske sted. De møtes aldri, snakker aldri sammen, og påvirker aldri hverandres tidslinje direkte innad i fiksjonen.
2. **Byttet mellom tidslagene er et verktøy spilleren har, ikke en hendelse figurene opplever.** Dette ligner måten et kart-lag/informasjonsvisning fungerer i mange strategi- og utforskningsspill: spilleren "ser" begge lag, men figurene i hvert lag trenger ikke vite at det andre laget finnes. Dette unngår helt behovet for å forklare *hvordan* tidsreise fungerer, fordi ingen i historien reiser i tid — kun spilleren, som leser landskapet på tvers av tid.
3. **Løs, lett diegetisk ramme (valgfri, ikke påkrevd):** Dersom oppdragsgiver ønsker en tynn fiksjonell begrunnelse for byttet (fremfor et rent ikke-diegetisk grensesnitt), foreslås en "landskapet husker"-ramme inspirert av `game_design_references.md`s analyse av *What Remains of Edith Finch* og *Old Man's Journey*: stedet selv bærer synlige spor fra begge tider (en bygning bygget oppå en eldre grunnmur, en kolle i et jorde), og spillerens evne til å "se" det andre laget er en presentasjonsmekanikk for spilleren — ikke en magisk evne figuren i fiksjonen besitter eller reflekterer over. Dette unngår tidsreiseparadokser fullstendig, fordi det aldri postuleres en kausal kobling mellom lagene i selve historien.
4. **Hovedkonflikt forankres i hvert tidslag for seg, ikke i "reparere tidslinjen"-plott.** Anbefalt hovedkonflikt for prototypen: en **stedbunden, ikke-tidsreise-basert undring** — f.eks. "hvorfor ser dette stedet ut som det gjør, og hva forteller landskapet oss om hvordan det ble sånn?" — drevet av nysgjerrighet (jf. Outer Wilds-lærdommen), ikke av en trussel som må avverges i én av tidslinjene for å redde den andre.

### Hvorfor dette svarer på spørsmål 2 uten å late som det er endelig avgjort
Denne rammen krever ingen ny historisk research og ingen kompliserte spillmekaniske systemer (ingen "endre fortiden → se konsekvens i nåtiden"-logikk), og er dermed den enkleste løsningen å bygge i en vertikal prototype. Den utelukker likevel ikke at oppdragsgiver senere ønsker en tynnere eller tykkere diegetisk ramme — det er nettopp derfor punkt 3 er presentert som valgfritt tillegg, ikke en fast del av anbefalingen.

---

## Oppsummering av anbefalingen (for rask referanse)

| Spørsmål | Anbefaling | Status |
|---|---|---|
| Geografisk region (overordnet) | Lofoten/Vesterålen/Salten (Nordland) | **Endelig, fastsatt av oppdragsgiver 2026-07-24** — se `docs/DECISIONS.md` |
| Underregion for vertikal prototype | Vestvågøy/Vågan-klyngen i Lofoten (Borg + Vágar/Kabelvåg) som inspirasjon; fiktiv spillgeografi | Anbefaling, venter på godkjenning |
| Vertikal prototype | Ett lite, sammensatt fiskevær/kystnært sted; tap-to-move + tidslagsbytte + minimalt faktasystem; kamp/skylagring/Android utelatt | Anbefaling, venter på godkjenning |
| Hovedkonflikt/narrativ ramme | To atskilte figurer per tidslag; tidslagsbytte som spillerverktøy, ikke forklart tidsreise i fiksjonen; konflikt drevet av stedbunden nysgjerrighet | Anbefaling, venter på godkjenning |

Se `docs/DECISIONS.md` for den formelt loggførte, tilsvarende merkede oppføringen, og `docs/OPEN_QUESTIONS.md` for hvordan dette forholder seg til spørsmål 1, 2 og 6.
