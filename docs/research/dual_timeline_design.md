# Design for to tidslag på samme sted

## Formål

Oversette historisk og teknisk research til konkrete designforslag for hvordan samme geografiske sted representeres i to tidsperioder — kart-strategi (to kart / lagdelte kart / delt grunngeometri), hvordan objekter/hendelser i én tid kan påvirke den andre, og datastrukturer for oppdrag/dialog/historiske fakta med kildehenvisning.

## Sammendrag

Anbefalingen er **delt grunngeometri med lagdelt, tidslags-spesifikk "dressing"** innenfor **én og samme Godot-scene per lokasjon** — ikke to helt separate scener/kart. Terreng, ferdselslinjer og navigerbart areal er (jf. `modern_environment.md`) den mest stabile kontinuitetsfaktoren mellom tidslagene, mens bygninger og gjenstander er det som faktisk endrer seg — dette taler for én delt koordinatramme der kun "overflaten" byttes ut. Tidslagsbytte skjer ved å veksle synlighet på `TileMapLayer`-lag og tidslags-merkede objekter, ikke ved å laste en ny scene, slik at byttet oppleves umiddelbart og uten lasteskjerm — dette støtter den rolige, utforskende tempoet og "aha"-designprinsippet om at miljøet skal snakke først (jf. `concepts/quest_opportunities.md` del 1). Punkter der navigerbart areal faktisk *bør* avvike mellom tidslagene (f.eks. en moderne bygning som blokkerer det som var åpen mark i vikingtiden) behandles som en bevisst miljøgåte-mekanikk, ikke en feil å unngå. Historiske faktapåstander, dialog og oppdrag knyttes til tidslag/sted/kildeID gjennom de `Resource`-baserte datastrukturene som allerede er anbefalt i `godot_mobile_technical_research.md` punkt 12.

## Sist oppdatert

2026-07-24

## Status

foreløpig (designanbefaling syntetisert fra fullført research; ikke testet i praksis med ekte innhold ennå)

---

## 1. Kjernevalg: delt grunngeometri, ikke to separate kart

### Alternativene som ble vurdert

1. **To fullstendig separate kart/scener** (én for moderne-laget, én for vikingtidslaget), koblet sammen via en manuelt vedlikeholdt korrespondanse mellom posisjoner.
2. **Lagdelte kart** — samme scene, men med separate, uavhengig konstruerte lag for hvert tidslag, uten et felles "grunnlag".
3. **Delt grunngeometri med tidslags-spesifikk dressing** — én scene, ett felles koordinatsystem/terrengoppsett, der kun de øverste, visuelle/interaktive lagene (bygninger, dekorasjon, NPC-er, navigasjonsavvik) byttes ut per tidslag.

### Anbefaling: alternativ 3

**Begrunnelse:**
- `research/modern_environment.md` og `research/continuity_into_modern_life.md` peker begge på at *terreng, ferdselslinjer og gårds-/tunplassering* er den mest pålitelige kontinuitetsfaktoren mellom tidslagene (kategori c i a–g-systemet), mens bygninger, materialer og bruk er det som faktisk endrer seg. Dette betyr at et delt, felles grunnlag ikke bare er teknisk enklere, men også **designmessig riktigere** — det er nøyaktig den typen kontinuitet spillet skal formidle.
- Alternativ 1 (to separate kart) krever manuell synkronisering av hver eneste posisjon spilleren kan gjenkjenne på tvers av tidslag (en sti, en gravhaug, et gjerde), noe som er en betydelig, feilutsatt vedlikeholdskostnad — og gir en reell risiko for at kartene "driver fra hverandre" over tid i produksjon.
- Alternativ 2 (lagdelte, men uavhengig konstruerte kart) løser ikke synkroniseringsproblemet, bare flytter det til å gjelde lag i stedet for scener.
- Alternativ 3 lar innholdsforfattere/nivådesignere bygge terrenget/navigasjonen **én gang**, og deretter kun style/møblere de to tidslagene ulikt oppå samme grunnlag — i tråd med Godots `TileMapLayer`-arkitektur (se punkt 2).

## 2. Scene-strategi: én scene per lokasjon, tidslagsbytte via synlighet

- Hver spillbar "lokasjon" (f.eks. den vertikale prototypens kystvik, se `concepts/prototype_recommendation.md`) bygges som **én Godot-scene**, ikke to.
- Inne i scenen organiseres innholdet i separate `TileMapLayer`-noder (jf. `godot_mobile_technical_research.md` punkt 11), gruppert i tre lag-familier:
  - **Felles grunnlag** (delt mellom tidslag): bakke/terreng-tekstur, vann, hovedferdselslinjer, høydevariasjon. Dette laget er identisk uansett hvilket tidslag spilleren er i, og bør normalt ikke inneholde tidslags-spesifikke detaljer.
  - **Moderne-lag** (kun synlig i moderne-tidslaget): moderne bygninger, veiskilt, biler/båter, gjerder, moderne vegetasjon/bruksmønster.
  - **Vikingtids-lag** (kun synlig i vikingtids-tidslaget): langhus/naust/gårdsbygninger, gravhauger i aktiv bruk (i motsetning til moderne-lagets "gressbevokst haug"), vikingtids-vegetasjon/bruksmønster.
- **Tidslagsbytte** implementeres som en enkel tilstandsvariabel (f.eks. et globalt `CurrentEra`-enum/autoload) som styrer `visible`-egenskapen på de tidslags-spesifikke lagene og aktiverer/deaktiverer tidslags-merkede noder (NPC-er, gjenstander). Byttet bør ledsages av en kort, rask visuell overgang (f.eks. en 0,2–0,3 sekunders fargetone-/blend-overgang) fremfor et umiddelbart, hakkete hopp — men uten lasteskjerm eller sceneomlasting.
- **Hvorfor ingen sceneomlasting:** En lasteskjerm bryter tempoet i nettopp det øyeblikket spillet skal skape en følelse av gjenkjennelse ("dette er samme sted!") — sammenhengen mellom tidslagene er sterkest når byttet er umiddelbart. For en liten, avgrenset vertikal prototype er minnekostnaden ved å holde begge tidslags fulle innhold lastet samtidig i én scene lav nok til at dette er uproblematisk på moderne iPhone/iPad-maskinvare; dette bør likevel verifiseres med et ekte ytelsestest-pass når prototypen har reelt innhold (jf. `godot_mobile_technical_research.md` punkt 8).

## 3. Navigasjon: delt grunnlag, tidslags-spesifikke avvik som gåte-verktøy

- Bygg én hoved-`NavigationRegion2D`/`NavigationPolygon` for terreng som er navigerbart i **begge** tidslag (jf. anbefalingen om `NavigationServer2D`/`NavigationAgent2D` i `godot_mobile_technical_research.md` punkt 3, valgt fordi verdenen er håndtegnet/organisk, ikke rutenettbasert).
- Der et tidslag skal ha et areal som **ikke** er navigerbart i det andre (f.eks. en moderne bygning står midt i det som i vikingtiden var en åpen sti, eller omvendt — en vikingtids gravhaug/palisade blokkerer et areal som i dag er åpent jorde), legges dette til som et **eget, mindre navigasjons-/kollisjonsavvik** koblet til tidslags-tilstanden, ikke som en full omskrivning av navigasjonsmeshen.
- **Design-implikasjon:** Slike avvik bør brukes bevisst som miljøfortelling/mikro-gåter ("hvorfor kan jeg ikke gå her i det ene tidslaget, men det kan jeg i det andre?") — i tråd med prinsippet fra `concepts/quest_opportunities.md` om at spilleren skal gjøre koblingen selv. De skal ikke oppstå tilfeldig som følge av slurvete innholdsproduksjon.

## 4. Objekt- og NPC-representasjon på tvers av tidslag

- Interaktive objekter og NPC-er merkes med et eksportert tidslags-felt (f.eks. `era: Era` med verdiene `MODERN` og `VIKING_AGE`, eventuelt utvidet senere med flere perioder om nødvendig). Noder/instanser vises og aktiveres kun når `CurrentEra` samsvarer med deres merking.
- For steder der spillet bevisst skal vise et **fysisk spor** av det andre tidslaget uten å bytte fullt tidslag (f.eks. en forhøyning i bakken i moderne-laget som antyder en grav som er tydelig synlig i vikingtidslaget, jf. `concepts/quest_opportunities.md` oppdrag A) — bruk en egen, alltid-synlig "spor"-node i det aktive lagets dressing, separat fra selve tidslagsbytte-mekanikken. Dette sikrer at antydningen er en bevisst plassert detalj, ikke en tilfeldig konsekvens av lagoppsettet.

## 5. Datastruktur for innhold: gjenbruk av `Resource`-mønsteret

Bygg videre på anbefalingen i `godot_mobile_technical_research.md` punkt 12, med eksplisitt tidslags-/stedskobling:

- **Historisk faktapåstand-`Resource`:** felter for påstandstekst, tidslag/sted den er knyttet til, sikkerhetsgrad (fastslått/sannsynlig/omdiskutert/myte — gjenbruk kategoriseringen fra `concepts/aha_moments.md`), og en liste over kilde-ID-er som peker direkte til rader i `docs/research/source_register.md` (f.eks. et `source_ids: Array[String]`-felt med verdier som `"SRC-CONT-014"`). Dette unngår at spilldata og research-dokumentasjon får to parallelle, usynkroniserte kildelister.
- **Dialog-`Resource`:** gren-/valgstruktur som i `godot_mobile_technical_research.md`, med et ekstra felt for hvilket tidslag NPC-en/dialogen tilhører, og — der relevant — en kobling til én eller flere faktapåstand-`Resource`-er som dialogen kan referere til eller låse opp.
- **Oppdrag-`Resource`:** mål/steg/betingelser som i `godot_mobile_technical_research.md`, pluss et felt for hvilke(t) tidslag oppdraget krever besøk i (mange oppdrag i `concepts/quest_opportunities.md` krever eksplisitt besøk i begge).
- Alle tre gjenbruker samme sted-/tidslags-taksonomi som scene-strukturen i punkt 2–4, slik at innholdsforfattere kan filtrere/søke i data etter sted og tidslag konsekvent.

## 6. Skalering utover den vertikale prototypen

Den vertikale prototypen (`concepts/prototype_recommendation.md`) trenger kun én slik lokasjonsscene. Når/hvis verden utvides:

- Organiser verden som **flere separate lokasjonsscener** (én per sted-par), lastet/losset etter hvor spilleren beveger seg — ikke som én enorm, sammenhengende scene med alt innhold lastet samtidig. Dette er standard mobilvennlig praksis for minnebruk og er forenlig med delt-grunngeometri-mønsteret over: hver lokasjonsscene har sitt eget interne "felles grunnlag + to dressing-lag"-oppsett.
- Overgangen mellom lokasjonsscener (f.eks. spilleren går fra vik til bygdesenter) kan da bruke en kort overgang/lasting, mens tidslagsbytte **innenfor** én lokasjon forblir øyeblikkelig.

## 7. Grenser og usikkerhet

- Dette er en designanbefaling syntetisert fra fullført teknisk research (`godot_mobile_technical_research.md`) og historiske kontinuitetsfunn (`modern_environment.md`, `continuity_into_modern_life.md") — den er **ikke** verifisert mot en faktisk implementasjon med ekte kart/assets ennå.
- Kamera-/pixel-snapping-anbefalingene i `godot_mobile_technical_research.md` punkt 4 (jitter ved pikselsnapping ) bør testes sammen med den umiddelbare tidslags-overgangen beskrevet i punkt 2 over, siden en fargetone-/blend-overgang kombinert med pikselsnapping ikke er verifisert i kombinasjon i denne researchen.
- Nøyaktig terskel for hvor mye navigasjonsavvik (punkt 3) som er "gåte" versus "forvirrende" er en spilldesign-avveining som bør testes med faktiske spillere når prototypen finnes, ikke noe research alene kan avgjøre.
