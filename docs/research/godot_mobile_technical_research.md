# Godot og mobilteknisk research

## Formål

Dokumentere hvordan konseptet kan realiseres teknisk i Godot/GDScript for iOS/iPadOS (og senere Android): tap-to-move/pathfinding, mobilvennlig kamera og pixel art, skjermstørrelser/sideforhold, safe areas, berøringsvennlig UI, ytelse/batteribruk, lokal lagring, TileMap/TileSet-arbeidsflyt, datastrukturer for innhold, tilgjengelighet, samt overordnede hensyn til TestFlight/App Store/Google Play og opphavsrett.

## Sammendrag

Godot 4.x (per juli 2026 er stabil gren 4.7, se versjonsnotat under) er godt egnet til dette prosjektet: 2D-verktøyene er modne, GDScript er enkelt å komme i gang med, og motoren har offisiell, om enn fortsatt noe umoden, støtte for iOS/iPadOS- og Android-eksport. Tap-to-move kan bygges enten på `NavigationServer2D`/`NavigationAgent2D` (navigasjonsmesh, anbefalt for organiske top-down-kart) eller `AStarGrid2D` (rutenettbasert). Pixel art krever eksplisitt "nearest"-tekstur­filtrering og bevisste valg for stretch mode/aspect for å unngå uskarphet og feil skalering på tvers av iPhone/iPad-skjermer. Safe areas på iOS/iPadOS må håndteres manuelt via `DisplayServer`, det finnes ikke en ferdig, feilfri innebygget løsning. Lokal lagring dekkes godt av `FileAccess` + JSON i `user://`; skylagring er bevisst utsatt til senere. TileMap-arbeidsflyten er migrert fra `TileMap` til `TileMapLayer`-noder (fra Godot 4.3), og dette bør legges til grunn fra dag én for å unngå migreringsarbeid senere. Innhold (oppdrag, dialog, historiske fakta, kildehenvisninger) bør modelleres som egendefinerte `Resource`-klasser (`.tres`-filer) framfor hardkodet i scripts eller rå JSON, siden dette gir typesikkerhet, redigerbarhet i editoren og gjenbruk. Tilgjengelighet i selve spillet (tekststørrelse, kontrast) må bygges bevisst — Godots egne 4.5-tilgjengelighetsforbedringer gjelder primært skjermleserstøtte for `Control`-noder og editoren, ikke automatisk tekstskalering i spill. TestFlight/App Store og Google Play-prosessene er godt dokumentert og forutsigbare, men begge har ventetid og krav (Apple Developer-konto, Google sitt 14-dagers lukkede testkrav for nye kontoer) som bør legges inn i tidsplanen tidlig. Opphavsrettslig er hovedprinsippet at spillmekanikker og generelle stilideer (top-down, tap-to-move, "gjenkjennelig men ikke identisk" fantasy-tolkning av historiske kulturer) normalt ikke er beskyttet, mens konkret grafikk, UI-design, figurer, logoer og tekst er det — dette er **ikke juridisk rådgivning**, kun en oppsummering av kjente, allment aksepterte prinsipper.

## Sist oppdatert

2026-07-23 (tillegg 2026-07-24: gjennomført ytelsespass under punkt 8, se eget avsnitt der, GitHub-issue #29; tillegg 2026-07-24: tekststørrelse/høykontrast implementert under punkt 13, GitHub-issue #30)

## Status

foreløpig

---

> **Tillegg 2026-07-24 — pivot til web som primærplattform.** Denne researchen ble opprinnelig gjort med iOS/iPadOS som primærmål (se punkt 2 og 14, samt opphavsrettsvurderingen i punkt 15, som fortsatt gjelder uendret). Oppdragsgiver har siden bestemt web (nettleser) som primær eksportplattform, med iOS som mulig senere sekundærmål — se `docs/DECISIONS.md`, 2026-07-24. Punktene om `NavigationServer2D`, `TileMapLayer`, `Resource`-datamodell, lagring, tilgjengelighet og opphavsrett (punkt 1, 3–4, 9, 11–13, 15–16) er motor-nivå og gjelder uendret for web. Punktene om iOS/Android-eksport (2), safe areas (6) og App Store/Google Play (14) gjelder primært når/hvis iOS forfølges senere. **Et eget, web-spesifikt research-tillegg gjenstår** (WASM-bundlestørrelse, førstelastingstid, mobilnettleser-ytelse/kompatibilitet, hosting) — dette er en tidlig oppgave i GitHub-repoets M0-milestone, ikke noe som er undersøkt her ennå.

## 0. Versjonsgrunnlag — hvilken Godot-versjon denne researchen bygger på

Godot-dokumentasjonens "stable"-URL (`docs.godotengine.org/en/stable/...`) pekte ved research­tidspunktet (23.07.2026) til **Godot 4.7**-dokumentasjonen, og nedlastingssiden til motoren oppga **4.7.1** (utgitt 14.07.2026) som gjeldende stabile versjon [1][2]. Godot 4.5 (utgitt 2025) og 4.6 var tidligere stabile utgaver i samme 4.x-linje [3][4].

**Usikkerhet å merke seg:** Fordi Godot utgir hyppige minor- og patch-versjoner, og fordi dette er informasjon hentet live og ikke fra generell velkjent kunnskap, bør prosjektteamet ved faktisk prosjektoppstart verifisere gjeldende stabile versjon direkte på `godotengine.org/download` før man låser en versjon for prosjektet. Denne researchen bruker "Godot 4.x, med 4.7 som referansepunkt" gjennomgående, og presiserer versjon per punkt der det er kjent API-endringer mellom versjoner (f.eks. TileMap → TileMapLayer, som kom i 4.3).

**Anbefaling:** Legg til grunn nyeste stabile 4.x-patch ved prosjektstart (skriv den ned i `PROJECT_VISION.md` eller et eget teknisk beslutningsdokument når koding starter), ikke en spesifikk versjon fastsatt nå i research-fasen.

---

## 1. Godot og GDScript for top-down 2D

Godot har en dedikert 2D-renderer (ikke en tilpasset 3D-motor) og et offisielt "Your first 2D game"-opplæringsløp som dekker `CharacterBody2D`, `Area2D`, input og enkel bevegelse [5]. GDScript er Godots innebygde, Python-lignende skriptspråk, tett integrert med editor og noder, og er et fornuftig valg for et team uten tunge C++/C#-behov. For et top-down-eventyr uten fysikkbasert kamp er `CharacterBody2D` for spillerfiguren, `Node2D`/`Sprite2D` for verdensobjekter, og scene-basert komposisjon (én scene per "sted"/rom, instansiert ved behov) en velprøvd struktur i Godot-fellesskapet, men dette er allmenn praksis snarere enn én bestemt anbefalt mal fra offisiell dokumentasjon.

## 2. Godots støtte for iOS, iPadOS og Android (2026-status)

- **iOS/iPadOS:** Eksport krever en Mac med Xcode installert. Godot bygger et Xcode-prosjekt/rammeverk som deretter kompileres og signeres i Xcode. Man trenger en gyldig Apple Developer Team ID og en bundle-ID i omvendt DNS-format [2]. Prosjektet kan enten eksporteres på nytt for hver endring, eller kobles til Xcode via en referanse-fil-arbeidsflyt for raskere iterasjon [2]. iOS-simulatoren støtter kun "Compatibility"-rendereren, ikke full Forward+/Mobile-rendering [2].
- **Kjent begrensning (iOS):** Godots eksporterte Xcode-prosjekt setter som standard opp kapabiliteter for "In-App Purchases" og "Push Notifications" i prosjektfilen, noe som kan være problematisk for kontoer/prosjekter som ikke trenger eller ikke har rettigheter til dette, og som i praksis krever manuell redigering av Xcode-prosjektfilen (`project.pbxproj`) for å fjerne [6]. Native iOS-plugins (f.eks. IAP) er dessuten et område community selv beskriver som tynt vedlikeholdt [6].
- **Android:** Eksport har lavere terskel enn iOS — krever Android SDK og (for enkel eksport) ferdige eksportmaler, eller en "custom build"-arbeidsflyt for prosjekter som trenger egne Android-plugins/tillatelser [7]. Siden Android er en uttalt senere målplattform i dette prosjektet (se `PROJECT_VISION.md`), er dette lavere prioritet nå, men arkitekturen (input, lagring, UI) bør ikke gjøre iOS-spesifikke antagelser som hindrer senere Android-eksport.
- **Generelt:** Godot er et open source-prosjekt, og mobil-eksport (spesielt iOS) er historisk sett et område med jevnlige, mindre friksjonspunkter (signering, provisioning, pluginøkosystem) sammenlignet med desktop-eksport. Dette er ikke unikt for dette prosjektet, men bør tas høyde for i tidsestimering — sett av tid til iterasjon på eksport-oppsettet tidlig i utviklingen, ikke først rett før innlevering.

## 3. Tap-to-move, pathfinding og navigasjon

Godot 4.x tilbyr to hovedspor for stiplanlegging i 2D [8][9]:

1. **`NavigationServer2D` / `NavigationAgent2D` / `NavigationRegion2D`** — navigasjonsmesh-basert. Man baker et `NavigationPolygon` inn i en `NavigationRegion2D`, og en `NavigationAgent2D` på spillerens `CharacterBody2D`-node kan da spørre etter korteste vei mellom to fritt valgte punkter i det navigerbare området — ikke bare forhåndsdefinerte celler. Dette egner seg godt for organiske, håndtegnede top-down-kart der spilleren kan trykke hvor som helst innenfor gangbart terreng. Viktig teknisk detalj fra dokumentasjonen: man må vente til første fysikk-frame før man spør navigasjonsserveren om en vei, fordi kartsynkronisering skjer etter første frame [9].
2. **`AStarGrid2D`** (og det mer generelle `AStar2D`) — rutenett-/celle-basert stifinning, best egnet når verden naturlig er inndelt i diskrete, like store celler (f.eks. et strengt rutenett-TileMap) og man ikke trenger fri bevegelse til vilkårlige posisjoner [10][11].

**Anbefaling for tap-to-move i dette prosjektet:** Gitt at spillet skal ha et håndlaget, atmosfærisk landskap (ikke et strengt rutenettbasert brettspill), peker dette mot `NavigationServer2D`/`NavigationRegion2D`/`NavigationAgent2D` som førstevalg, med `AStarGrid2D` som et alternativ dersom deler av verden (f.eks. interiør, definerte "rom") heller modelleres rutenettbasert. Begge tilnærminger er dokumentert og aktivt vedlikeholdt i Godot 4.x; dette er ikke et enten/eller-valg låst for hele prosjektet, men kan avgjøres per kart-type. Selve "tap"-delen (å oversette en berøring til et navigasjonsmål) er ikke en egen Godot-funksjon, men bygges av prosjektet selv ved å lese touch-/museinput (se punkt 6) og sende posisjonen videre til navigasjonssystemet.

## 4. Mobilvennlig kamera og lesbar pixel art

- **Tekstur­filtrering:** Godot 4 bruker som standard lineær (bilineær) tekstur­filtrering, som gjør pixel art uskarp/utflytende ved skalering. For skarp pixel art må "Default Texture Filter" settes til "Nearest" i Project Settings → Rendering → Textures, og/eller per-tekstur i importinnstillingene, med mulighet til å sette dette som standardforvalg for alle Texture2D-importer [12][13].
- **Pikselperfekt skalering:** Anbefalingen i fellesskapet (og delvis i offisiell dokumentasjon) er å bruke heltalls-skalering («integer scaling») der mulig, slik at ett pixel-art-piksel alltid tilsvarer et helt antall skjermpiksler, for å unngå ujevn skalering og «shimring» [14]. Godot har prosjektinnstillinger under Rendering → 2D for pikselsnapping («Snap 2D Transforms to Pixel», GPU-pikselsnap), som kan redusere flimring for bevegelige sprites og TileMaps [14].
- **Kamera:** `Camera2D` er standard kameranode for 2D. Det er en kjent, dokumentert utfordring i Godot-fellesskapet at kombinasjonen av pikselsnapping og jevn/glidende kamerabevegelse kan gi synlig "jitter" (hakkete bevegelse), og vanlige avbøtende tiltak er små "drag margins" på kameraet eller å holde kamera-posisjonen selv heltallsjustert per frame [15]. Dette er ikke fullstendig løst i motoren og bør testes tidlig med faktiske pixel-art-assets, ikke antas løst automatisk.
- **Anbefaling:** Sett "Nearest" som standard tekstur­filter fra prosjektstart, bruk en fast, lav intern rendering-oppløsning (base-oppløsning) med heltallsskalering til skjerm, og test kamerabevegelse med ekte pixel-art-tiles tidlig for å avdekke ev. jitter før det er kostbart å endre.

## 5. Forskjellige skjermstørrelser og sideforhold

Godot styrer dette via prosjektinnstillingene for oppløsning og "Stretch Mode" / "Stretch Aspect" [16]:

- **Stretch Mode:** `disabled` (ingen skalering, 1 enhet = 1 skjermpiksel), `canvas_items` (2D skaleres til å dekke skjermen, kan gi delvis piksel-posisjoner), og `viewport` (renderer til en fast intern oppløsning som deretter skaleres opp — nyttig for lavoppløst pixel art, men kan gi mer synlig skalerings-artefakter enn `canvas_items` avhengig av innstillinger) [16].
- **Stretch Aspect:** `keep` (bevarer sideforhold, legger til svarte kanter/letterboxing), `keep_width`/`keep_height` (utvider i én retning — `keep_height` egner seg ofte godt for liggende mobilbruk), og `expand` (tilpasser seg friest til enhetens faktiske sideforhold, uten svarte kanter, men viser mer eller mindre av verden avhengig av skjerm) [16].
- **Praktisk anbefaling for iPhone/iPad:** Siden iPhone og iPad har vesentlig ulike sideforhold (iPhone er smalere/høyere i portrettmodus enn iPad), og fordi spillet er top-down med utforsking som kjernefølelse, peker dette mot `expand`-aspekt (vise mer/mindre av verden avhengig av skjerm, uten sorte kanter) framfor `keep` (som ville gitt permanente svarte kanter på mange enheter). Dette valget bør likevel testes visuelt på faktiske simulator-/enhetsstørrelser før det låses, siden `expand` kan gi enkelte spillere mer informasjon synlig enn andre (kan ha spillbalanse-implikasjoner i et utforskningsspill, men neppe kritisk for et rolig, ikke-konkurransedrevet spill som dette). UI/HUD-elementer bør uansett ankres med Control-node-ankere, ikke absolutte piksel-koordinater, slik at de forblir korrekt plassert uavhengig av stretch-innstilling.

## 6. Safe areas på iPhone og iPad

Godot har ingen fullautomatisk, feilfri "sett innhold innenfor safe area"-løsning innebygd, men eksponerer den nødvendige informasjonen:

- `DisplayServer` har en funksjon for å hente enhetens "safe area" (det synlige, ikke-tildekkede området som ikke overlappes av innslag som iPhones "dynamic island"/hakk eller avrundede hjørner) [17][18]. Det finnes også en eldre, delvis kjent-problematisk `OS.get_window_safe_area()`-variant i community-diskusjoner, med rapporterte tilfeller der returnert areal er større enn faktisk konfigurert oppløsning [17].
- **Anbefalt mønster fra fellesskapet:** Lag en liten kontrollscript på en `MarginContainer` (eller tilsvarende rotcontainer for UI) som ved oppstart (og ved orientasjonsendring) leser safe area-verdiene og setter marginer, slik at UI-elementer (menyer, HUD, dialogtekst) aldri havner under hakk, kamera-utsparinger eller avrundede hjørner [18]. Det finnes også et ferdig community-verktøy ("Notchz") for dette formålet i Godots asset library, som et alternativ til å skrive det selv [19].
- **Anbefaling:** Behandle safe area som noe som må bygges og testes eksplisitt for dette prosjektet — spesielt fordi tap-to-move-spill ofte har interaktive elementer nær skjermkantene (f.eks. inventar-knapper, dialogbokser), og fordi prosjektet skal støtte både iPhone (med hakk/dynamic island på nyere modeller) og iPad (uten hakk, men med andre sideforhold og evt. hjemmeindikator nederst).

## 7. Berøringsvennlig interaksjon og menyer

- **Input-events:** Godot håndterer berøring via `InputEventScreenTouch` (trykk/slipp, med indeks for multi-touch) og `InputEventScreenDrag` (dra-bevegelse) [20][21]. Dokumentasjonen/fellesskapet påpeker at `index`-verdien for multi-touch ikke nødvendigvis er konsistent definert på tvers av plattformer, noe som er relevant hvis man senere vil støtte flerfingerbevegelser (zoom, panorering) [20].
- **Godot 4.7 la til en innebygd `VirtualJoystick`-node** (med modusene «fixed», «dynamic» og «following») som innebygd erstatning for tidligere community-plugins for berøringsbaserte styrespaker [22]. Dette er ikke direkte relevant for tap-to-move (som er hovedkontrollen her), men er nyttig å vite om — dersom prosjektet på et senere tidspunkt ønsker en sekundær kontrollmetode (f.eks. finjustering av bevegelse), finnes det nå en offisiell, vedlikeholdt løsning i motoren i stedet for en tredjeparts-plugin.
- **Menyer/UI:** Godots `Control`-noder (knapper, paneler, containere) er i utgangspunktet laget for mus/tastatur-først, men fungerer godt for touch dersom knappestørrelser dimensjoneres romslig (generell mobil UX-praksis — ikke en Godot-spesifikk regel — tilsier gjerne minimum ca. 44×44 punkter á la Apples egne grensesnittretningslinjer, som ikke er hentet fra Godot-dokumentasjon men fra generell mobil-UI-praksis og bør verifiseres mot gjeldende Apple Human Interface Guidelines før implementering).
- **Anbefaling:** Design tap-to-move slik at et trykk i verden alltid tolkes som bevegelsesmål, mens trykk på UI-elementer (Control-noder) fanges separat og ikke propagerer videre til verdens-input — dette er standard Godot input-håndteringsmønster (input-hendelser konsumeres av `Control`-noder øverst i treet før de når spillverdenen), og bør testes eksplisitt slik at spilleren ikke ved et uhell flytter figuren når de egentlig trykker på en meny-knapp.

## 8. Batteribruk og ytelse på mobil

Offisiell Godot-dokumentasjon har generell 3D-ytelsesdokumentasjon, men mindre samlet, offisiell dokumentasjon spesifikt om 2D-mobilytelse/batteri — mye av det konkrete rådet under kommer fra anerkjente, men ikke-offisielle, utviklerressurser, og bør derfor behandles som god praksis/tommelfingerregler snarere enn Godot-spesifiserte krav [23]:

- Minimer antall "draw calls" (tegnekall til GPU-en) — dette er en generell sannhet på tvers av spillmotorer, ikke Godot-spesifikt, men gjelder også i Godot [23].
- Bruk komprimerte teksturformater støttet på mobil (f.eks. ETC2 på Android) for å redusere minne-/båndbreddebruk [23].
- Reduser bildefrekvens/prosesseringsintensitet når spillet er i bakgrunnen eller pauset, for å spare batteri — et generelt mobilprinsipp som også gjelder Godot-prosjekter [23].
- Unngå unødvendig komplekse shadere; for et rolig, stilisert 2D-eventyr uten tunge partikkeleffekter eller sanntids-lyssetting i stor skala er dette sannsynligvis et mindre problem enn i actiontunge spill, men bør likevel overvåkes med Godots innebygde profileringsverktøy («Debugger»-panelet med ytelsesmonitorer) etter hvert som innhold legges til.
- **Anbefaling:** Dette punktet krever mer prosjektspesifikk, praktisk testing (på faktiske eldre/nyere iPhone/iPad-enheter) enn det generell research kan svare endelig på. Sett av tid til et enkelt ytelses- og batteritest-pass på reelle enheter når en spillbar vertikal skive («vertical slice») med tidslags-veksling og et par kart eksisterer, framfor å prøve å optimalisere teoretisk nå.

### Oppdatering 2026-07-24: gjennomført ytelsespass (GitHub-issue #29)

Den betingelsen anbefalingen over satte («når en spillbar vertikal skive... eksisterer») er nå oppfylt (M1-M3: Borg/Vágar/Saltstraumen, tidslagsbytte, dialog, oppdrag). Dette avsnittet dokumenterer det gjennomførte passet.

**Viktig metodisk forbehold — dette er IKKE en fysisk enhetstest.** Et ekte iPhone/iPad eller Android-enhet var ikke tilgjengelig i denne økten. Det som faktisk ble gjort er nest best, ikke en erstatning: Chromium (via Playwright) med Googles egen mobil-emuleringsprofil («iPhone 13» — 390×664 logisk viewport, 3× pikseltetthet, touch-hendelser, mobil user-agent-streng) kombinert med CDP `Emulation.setCPUThrottlingRate` satt til 4× (samme «Mid-tier mobile»-terskel som Chrome DevTools selv bruker) for å simulere en svakere mobil-CPU enn utviklingsmaskinen. Dette fanger opp åpenbare ytelsesproblemer (høyt draw-call-tall, fps-fall, hakking ved tidslagsbytte), men bekrefter **ikke**: faktisk GPU-driveratferd på ARM-mobilbrikker, ekte batteriforbruk (kan ikke måles uten fysisk maskinvare i det hele tatt), eller Safari/WebKit-spesifikke kvirker på ekte iOS (Chromium-emulering av en iPhone-profil er fortsatt Chromium-rendering, ikke WebKit). **Et faktisk fysisk enhets-spot-check anbefales fortsatt før lansering** — dette passet lukker ikke det behovet permanent, bare det som var praktisk mulig i denne økten.

**Metode:** Prosjektet ble midlertidig utstyrt med et diagnose-script (fjernet igjen etter målingen, ikke committet) som logget Godots faktiske `Performance`-monitorer (`TIME_FPS`, `RENDER_TOTAL_DRAW_CALLS_IN_FRAME`, `RENDER_TOTAL_PRIMITIVES_IN_FRAME`, `OBJECT_COUNT`, `MEMORY_STATIC`) til konsollen hvert 2. sekund — reelle motor-interne tall, ikke gjettet fra utsiden. En Playwright-styrt økt (iPhone 13-profil, 4× CPU-trottling) spilte gjennom: hovedmeny → nytt spill → flere tap-to-move-bevegelser → fire tidslagsbytter (E-tast) → forsøk på NPC-interaksjon, med skjermbilder tatt underveis for å bekrefte at klikkene faktisk traff riktige koordinater i det (mindre) mobile viewportet.

**Resultater:**
- **Bildefrekvens:** stabilt 44-51 fps gjennom hele økten, selv under 4× CPU-trottling — ingen fps-fall observert ved tidslagsbytte eller bevegelse.
- **Draw calls:** 10 ved hovedmenyen, 14 i verdensscenen under normal utforsking, kortvarige topper til 18 under selve tidslagsbytte-overgangen (fade-effekten legger til noen få tegnekall midlertidig). Alle tall er lave i absolutt forstand — godt innenfor normal budsjett for et rolig 2D-spill med plassholder-grafikk.
- **Objekttall/minne:** `OBJECT_COUNT` gikk fra ~1497 (hovedmeny) til ~1570 (verdensscenen lastet) og var deretter stabilt — ingen tegn til minnelekkasje over økten. `MEMORY_STATIC` ble lest som 0,0 MB gjennom hele økten, som mest sannsynlig er en artefakt av web-eksportens minnehåndtering/monitor-tilgjengelighet i akkurat denne konteksten, ikke en reell nullmåling — bør ikke tolkes som at spillet ikke bruker minne.
- **Ingen feil:** verken `console`-feilmeldinger eller `pageerror`-hendelser i noen del av økten.
- **Bekreftet reell interaksjon, ikke bare en stillestående skjerm:** spillerfiguren flyttet seg synlig mellom skjermbilder (tap-to-move fungerte i mobil-viewportet), og draw-call-tallet endret seg konsistent med tidslagsbytte-overgangene, som bekrefter at E-tasten faktisk trigget `EraTransitionController`.

**Vurdering:** ingen konkrete ytelsesproblemer funnet innenfor det denne metoden kan fange opp. Ingen kodeendringer var nødvendige. Draw-call-tallene er så lave (14-18) at det er god margin igjen før dette blir en reell bekymring selv når placeholder-grafikken erstattes med ekte kunst under M3s kunst-fase.

**Kilder/metodikk:** Playwright 1.61 med Chromium, `p.devices["iPhone 13"]`-enhetsprofil, CDP `Emulation.setCPUThrottlingRate`; Godots `Performance`-singleton-API (`Performance.get_monitor()`), offisiell Godot 4.x-funksjonalitet. Målt 2026-07-24, samme utviklermaskin som øvrige spiker i dette dokumentet.

## 9. Lagring lokalt på enheten

Godots offisielle "Saving games"-veiledning beskriver et enkelt, robust mønster som passer godt for dette prosjektet [24]:

- Objekter/spilltilstand som skal lagres merkes (f.eks. via en gruppe, "Persist"), og hvert slikt objekt/system implementerer en funksjon som returnerer relevant tilstand som en `Dictionary`.
- `JSON.stringify()` konverterer dictionary til tekst, som skrives til en fil under `user://` (f.eks. `user://savegame.save`) via `FileAccess` [24].
- Ved lasting: sjekk at filen finnes (`FileAccess.file_exists`), les med `FileAccess.READ`, hent tekst med `get_as_text()`, og parse med `JSON.parse_string()` — med eksplisitt null-sjekk før man leser nøkler, siden ugyldig/korrupt JSON gir `null` [24][25].
- **Begrensning:** JSON støtter ikke Godot-native typer (`Vector2`, `Color` osv.) direkte — disse må konverteres manuelt til/fra tall/lister/dictionaries. For mer komplekse tilstander nevner dokumentasjonen `get_var`/`store_var` (binær serialisering) som alternativ, men JSON er å foretrekke der data skal være lesbart/redigerbart for feilsøking, og der man ønsker robusthet mot at en spiller har en fil som ikke kan kjøre vilkårlig kode (i motsetning til f.eks. innlasting av kjørbare scripts) [24][25].
- `user://` er den riktige, plattformuavhengige stien for spillerdata i Godot — den peker til appens egne data-/dokumentmappe på hver plattform, og er adskilt fra prosjektets `res://`-ressurser [24].
- **Anbefaling for dette prosjektet:** Bruk `Dictionary` → `JSON` → `FileAccess`-mønsteret for lagring av spillerprogresjon (hvilke tidslag/steder er besøkt, oppdragsstatus, oppdagede historiske forbindelser). Skriv gjerne til en midlertidig fil og "rename" til endelig filnavn ved vellykket skriving, som er en vanlig, anerkjent teknikk for å unngå korrupte lagringsfiler ved appavbrudd — dette er generell god praksis nevnt i flere ikke-offisielle Godot-ressurser, ikke eksplisitt i selve den offisielle veiledningen, så det bør bekreftes/testes av utviklerne selv [26].

## 10. Skylagring — kort notat

Skylagring (f.eks. synkronisering av spillfremgang på tvers av enheter, iCloud/Google Play Games-lagringstjenester) er **bevisst utsatt** og ikke del av første prototype, i tråd med prosjektets fase-avgrensning. Når det blir aktuelt, bør det undersøkes som egen sak (bl.a. plattformspesifikke tjenester som iCloud Key-Value Storage/CloudKit for iOS og Google Play Games Services for Android, samt om en tredjeparts-backend er ønskelig) — dette er ikke undersøkt i dybden her.

## 11. TileMap/TileSet-arbeidsflyt

- Fra **Godot 4.3** er den gamle `TileMap`-noden (som holdt flere lag internt, valgt via faner) formelt merket som **deprecated** («foreldet» — den fjernes ikke umiddelbart, men får ingen nye funksjoner), og erstattet av **`TileMapLayer`**, der hvert lag er en egen scenenode, med rekkefølge styrt av plassering i nodetreet, og der flere `TileMapLayer`-noder deler samme `TileSet`-ressurs [27][28]. Godot-editoren tilbyr et verktøy for å konvertere en eksisterende `TileMap` til et sett `TileMapLayer`-noder automatisk [27].
- **Arbeidsflyt:** Man oppretter først en `TileSet`-ressurs (definerer tiles, kollisjonsformer, terreng-sett for automatisk sammenkobling av kanter/hjørner, og eventuelt navigasjons-polygoner og "scene tiles" — hele scener, f.eks. dekorasjonsobjekter, plassert som tiles), og bruker den deretter på én eller flere `TileMapLayer`-noder for faktisk kartbygging [29]. Terreng-systemet har to moduser: "Connect" (automatisk sammenkobling av tilstøtende tiles) og "Path" (kunstnerstyrt sammenkobling innenfor ett penselstrøk) [29].
- **Navigasjon fra TileMap:** `TileMapLayer` kan ha innebygde navigasjonspolygoner, men dokumentasjonen anbefaler å bake disse til en mer optimalisert navigasjonsmesh via `NavigationRegion2D`/`NavigationServer2D` for bedre stifinningsytelse, framfor å stole på TileMap-lagets navigasjonsdata direkte i produksjon [29].
- **Anbefaling:** Bygg kart­arbeidsflyten på `TileMapLayer` fra første dag (ikke den gamle `TileMap`-noden), siden prosjektet uansett starter etter at denne migreringen fant sted i Godot, og for å unngå unødvendig ryddearbeid senere. Vurder separate `TileMapLayer`-noder for bakke/terreng, dekorasjon/overlegg, og kollisjon/navigasjon, slik at hvert lag har ett tydelig ansvar — dette er i tråd med den generelle designintensjonen bak `TileMapLayer`-omleggingen (mindre rot, enklere API) [27].

## 12. Datastrukturer for oppdrag, dialog, historiske fakta og kildehenvisninger

Kjerneproblemet prosjektet må løse: mye innhold (oppdrag, dialoglinjer, historiske faktapåstander med kildehenvisning, mulige forgreninger per tidslag) skal kunne skrives/redigeres av innholdsforfattere uten å hardkode alt i individuelle GDScript-filer.

- **Godots anbefalte mønster er egendefinerte `Resource`-klasser.** `Resource` er Godots basisklasse for serialiserbare, gjenbrukbare datacontainere — de er referansetalte (arver fra `RefCounted`), kan lagres til og lastes fra disk (som `.tres`/`.res`-filer), kan inneholde andre ressurser (nøstet struktur, godt egnet for f.eks. en dialog-graf eller et oppdrag med flere trinn), og Godot cacher/gjenbruker samme instans ved gjentatt lasting av samme fil [30].
- **Praktisk mønster (fra flere anerkjente, ikke-offisielle Godot-ressurser, men i tråd med Godots egen dokumenterte `Resource`-filosofi):** Man skriver et script som arver fra `Resource` med `class_name` og `@export`-variabler (f.eks. `speaker`, `text`, `choices`, `conditions`, `next_node`), og oppretter deretter konkrete data-instanser direkte i Godot-editorens filsystempanel ("New Resource" → velg egen klasse → rediger felter visuelt → lagre som `.tres`) [31][32]. Dette gir innholdsforfattere et strukturert skjema å fylle ut i editoren, uten å skrive kode, og gir samtidig typesikkerhet og autofullføring for utviklere som leser dataene i script.
- **Anbefalt struktur for dette prosjektets spesifikke behov:**
  - En egen `Resource`-klasse for **historiske faktapåstander/kildehenvisninger** (f.eks. felter for påstandstekst, sikkerhetsgrad — fastslått/sannsynlig/omdiskutert/myte —, kildehenvisning(er), og hvilket tidslag/sted den er knyttet til), som kan gjenbrukes både i dialog, oppdragstekst og eventuelle "oppdagelses"-UI-elementer. Dette bør designes i samråd med `docs/research/source_register.md`-strukturen, slik at kildereferanser i spilldata og kildereferanser i research-dokumentasjonen kan spores til samme kilder uten dobbeltarbeid.
  - En egen `Resource`-klasse for **dialog** (gren-/valgstruktur: hver node har tekst, valgfri taler, og en liste over "kanter" til neste node/valg) — et vanlig, dokumentert mønster i Godot-fellesskapet for både lineær og forgrenet dialog [32].
  - En egen `Resource`-klasse for **oppdrag** (mål, tilstand/steg, betingelser for fullføring, kobling til tidslag/sted), gjerne kombinert med signaler for løs kobling mellom oppdragslogikk og resten av spillet [32].
  - Rå JSON-filer (lastet med `JSON.parse_string()`) er et akseptabelt alternativ eller supplement for spesielt enkle, flate datasett (f.eks. en ordliste over norrøne ord/uttrykk med moderne motsvar, jamfør `research/language_and_place_names.md`), men gir ikke samme editor-integrasjon, typesikkerhet eller nøsting som `Resource`-baserte `.tres`-filer, og anbefales derfor primært for data som uansett redigeres utenfor Godot-editoren (f.eks. generert fra et regneark).
- **Usikkerhet:** Det finnes ingen offisiell, "kanonisk" Godot-mal spesifikt for dialog/oppdragssystemer i historiske/narrative spill — mønsteret over er syntetisert fra Godots dokumenterte `Resource`-API kombinert med gjentatte, samstemte anbefalinger fra flere uavhengige, anerkjente Godot-utviklerressurser, ikke fra én autoritativ offisiell kilde. Det finnes også modne, populære community-plugins for dialog (f.eks. "Dialogue Manager") som kan vurderes framfor å bygge helt fra bunnen — dette er ikke undersøkt i dybden i denne researchen og bør vurderes som egen, senere avgjørelse når innholdsvolumet er bedre forstått.

## 13. Tilgjengelighet: tekststørrelse og fargebruk

- **Godot 4.5 la til eksperimentell skjermleser-støtte for `Control`-noder** (via rammeverket AccessKit), samt tilgjengelighetsbeskrivelser for GUI-elementer — dette gjelder i første omgang primært selve Godot-editoren/Prosjektbehandleren, men den underliggende AccessKit-integrasjonen er ment å gjøre det mulig for skjermlesere å gjenkjenne og lese opp `Control`-baserte grensesnittelementer generelt [33]. Dette er eksplisitt beskrevet som en ny og fortsatt eksperimentell funksjon, ikke en ferdig, komplett løsning [33].
- **Tekststørrelse i spillet er ikke automatisk skalerbar** — siden Godot 4.0 er fontstørrelse en egenskap på noden/temaet som bruker fonten, ikke på selve fontressursen, og Godot skalerer ikke automatisk tekststørrelse når en Control-node endrer størrelse [34]. Det finnes et prosjekt-innstilling for global tema-skala (`gui/theme/default_theme_scale`), men å tilby spilleren en egen "tekststørrelse"-innstilling i spillets meny er noe prosjektet må bygge selv (typisk: en innstilling som lagres i spillerens lagringsdata, og som ved oppstart/endring justerer font-størrelse-overstyringer i temaet eller på enkeltnoder) [34][35].
- **Fargebruk:** Godot har ingen innebygd, automatisk fargeblindhet-simulering eller -korrigering for spillinnhold (dette finnes som utviklerverktøy i noen andre motorer/plugins, men er ikke identifisert som en offisiell Godot-spillfunksjon i denne researchen — usikkerhet merkes eksplisitt her). Generell, anerkjent tilgjengelighetspraksis (ikke Godot-spesifikk) tilsier: ikke bruk farge som eneste signal for viktig informasjon (f.eks. hvilke tidslag-elementer som er interaktive), sørg for tilstrekkelig fargekontrast i tekst/UI, og test med faktiske fargeblindhets-simuleringsverktøy (f.eks. i bildebehandlingsprogramvare) som en del av kvalitetssikringen — dette er allmenn UI/UX-praksis, ikke hentet fra Godot-dokumentasjon.
- **Anbefaling:** Planlegg for en egen "tilgjengelighet"-fane i innstillingsmenyen fra tidlig i produksjonen (tekststørrelse-valg, høy-kontrast-palett-valg), siden dette er enklere å bygge inn i UI-arkitekturen fra start enn å legge til i etterkant, men treng ikke prioriteres i selve research-/første-prototype-fasen.

### Oppdatering 2026-07-24: implementert (GitHub-issue #30)

`SettingsSystem` (autoload) bygger nå en `Theme`-ressurs fra to persisterte innstillinger — `text_size_index` (Normal/Large/Largest, faktor 1.0/1.25/1.5 på `default_font_size`) og `high_contrast` (boolsk) — og tildeler den til `get_tree().root`. Siden all UI i prosjektet allerede er bygget som CanvasLayer-autoloads uten egne lokale temaoverstyringer (hovedmeny, dialog, oppdragslogg, kodex/chronicle, pausemeny), fanger Godots vanlige tema-nedarving fra rot-vinduet opp alt UI fra dette ene stedet, uten at hver enkelt skjerm måtte endres individuelt. Begge innstillingene er eksponert i det eksisterende innstillingspanelet (`main_menu.gd`) og følger samme lagre-ved-endring/last-ved-oppstart-mønster som `master_volume`.

En egen gjennomgang av eksisterende UI-kode (`grep` etter `Color(`/`modulate` i `game/scripts/`) fant kun ett sted som bruker farge til å formidle tilstand — oppdragsstegs ferdig/gjenstår-status i `quest_log_ui.gd` — og der er fargen allerede kombinert med eksplisitt "[Done]"/"[Pending]"-tekst, ikke det eneste signalet. Ingen kodeendring var nødvendig for dette punktet.

Verifisert i faktisk nettleser-eksport (ikke bare editoren): tekststørrelse og høykontrast endrer synlig utseende på både innstillingspanelet og hovedmenyen (bekrefter at nedarvingen faktisk fanger opp hele treet, ikke bare panelet der innstillingen ble endret), begge overlever en faktisk `page.reload()`, og den deaktiverte "Continue"-knappen forblir visuelt atskilt fra aktive knapper (ingen lys kant) selv i høykontrastmodus — et eksempel til på at tilstand ikke formidles med farge alene.

## 14. TestFlight, App Store og Google Play — overordnet prosess

Dette er en overordnet prosessbeskrivelse, ikke juridisk eller kontraktuell rådgivning, og detaljerte krav endrer seg jevnlig hos begge plattformer.

**Apple (TestFlight → App Store):**
- Krever en betalt Apple Developer-konto for å distribuere til eksterne testere eller App Store.
- Man laster opp en build til App Store Connect, fyller ut testinformasjon (beskrivelse, hva som skal testes, kontakt for tilbakemelding), og kan så invitere **interne testere** (inntil 100 personer med tilgang i teamet, får bygg umiddelbart etter prosessering) og **eksterne testere** (inntil 10 000 personer, mottar bygg kun etter at Apples TestFlight-betareview har godkjent bygget) [36].
- Et bygg kan testes i inntil 90 dager før det må erstattes med et nytt [36].
- Selve App Store-innsendingen krever fullstendige metadata (beskrivelse, skjermbilder, aldersgrense, personvernopplysninger) og går gjennom Apples App Review før publisering [37].

**Google (Google Play Console):**
- Nye apper må publiseres som Android App Bundle (`.aab`), ikke rå `.apk` [38].
- **Viktig for nye utviklerkontoer:** siden slutten av 2024 må nye kontoer gjennomføre en lukket test med minst 12 testere i minst 14 sammenhengende dager før de kan søke om produksjonstilgang — dette legger reelt sett til minst to uker før første offentlige lansering er mulig, og bør legges inn i tidsplanen tidlig dersom Android-lansering planlegges [39].
- Etter innsending går appen til gjennomgang; behandlingstid er typisk fra noen timer til rundt 7 dager, men kan ta lenger tid for nye kontoer eller visse kategorier [40][41].
- Fra og med 31.08.2026 må nye apper og oppdateringer være rettet mot (target) Android API-nivå 36 (Android 16) eller høyere — relevant hovedsakelig når Android-eksport faktisk planlegges, ikke for iOS-første-prototypen [39].
- **Anbefaling:** Siden Android eksplisitt er en senere målplattform, trenger ikke disse Google-spesifikke fristene/kravene påvirke iOS-prototypen nå, men bør noteres som en kjent "oppstartskostnad i tid" (minst ~2 uker lukket testperiode) når Android-lanseringen faktisk planlegges.

## 15. Opphavsrettslige hensyn ved inspirasjon fra RuneScape og andre spill

**Dette er ikke juridisk rådgivning** — kun en oppsummering av generelle, velkjente og allment aksepterte copyright-prinsipper (primært amerikansk rett, som er sentral i spillbransjens praksis internasjonalt, men prinsippene har brede paralleller i mange lands lovgivning, inkludert Norge, gjennom skillet mellom idé og konkret uttrykk). Prosjektet bør innhente faktisk juridisk rådgivning før eventuell kommersiell lansering, spesielt hvis navn, logoer eller sterkt gjenkjennelige visuelle elementer fra andre spill vurderes brukt selv indirekte.

- **Idé/prosedyre vs. uttrykk ("idea/expression dichotomy"):** Et grunnleggende prinsipp i amerikansk opphavsrett (Copyright Act §102(b)) er at "idé, prosedyre, prosess, system, driftsmetode, konsept, prinsipp eller oppdagelse" ikke i seg selv kan opphavsrettsbeskyttes — kun den konkrete, kreative *uttrykksformen* er beskyttet [42]. I praksis betyr dette at generelle spillmekanikker og strukturelle ideer (f.eks. "top-down-utforskning", "veksle mellom to tidsperioder på samme sted", "tap-to-move-kontroll", "et rolig, ikke-kamp-fokusert historisk utforskningsspill") normalt ikke er opphavsrettslig beskyttet i seg selv — man kan ikke "eie" en sjanger eller en spillmekanikk [42][43].
- **Det som faktisk er beskyttet:** Konkret grafikk/kunststil-implementasjon (spesifikke sprites, figurdesign, logoer), konkret UI-layout og -grafikk, konkret tekst (dialog, questbeskrivelser, navn på spesifikke steder/figurer/gjenstander hvis de er distinkte oppfinnelser), og musikk/lyd er beskyttet uttrykk. Domstolers vurdering av hvor grensen går i praksis er ikke alltid entydig, og avhenger ofte av hvor mye den nye visuelle/tekstlige utformingen skiller seg fra originalen [42][44].
- **Praktisk konsekvens for prosjektet:** Å hente inspirasjon fra Old School RuneScape sin *lesbarhet, atmosfære og tempo* (som allerede er eksplisitt prosjektretning, se `PROJECT_VISION.md`) er i tråd med idé/uttrykk-skillet og ansett som lav risiko. Å gjenskape spesifikke OSRS-sprites, den spesifikke UI-rammen/ikonsettet, spesifikke figurnavn/monster­design eller spesifikke stedsnavn fra spillet ville derimot nærme seg beskyttet uttrykk og bør unngås — dette er allerede reflektert som en eksplisitt avgrensning i `PROJECT_VISION.md` ("uten å kopiere OSRS' grafikk, figurer, grensesnitt eller andre beskyttede uttrykk"), og denne researchen bekrefter at avgrensningen er i tråd med generelle, kjente opphavsrettslige prinsipper.
- **Tilleggshensyn utover opphavsrett (nevnt kort, ikke utdypet — egen vurdering anbefales):** varemerker (spillnavn/logoer kan være varemerkebeskyttet uavhengig av opphavsrett) og "trade dress"/generell kommersiell fremtoning er separate juridiske spor fra opphavsrett, og er ikke dekket i dybden her.

## 16. Funksjoner som bør utelates fra en første prototype

Gitt spillets uttalte omfang (rolig utforskning, dobbelt tidslag, tap-to-move, iOS/iPadOS først, ingen skylagring ennå) og research over, anbefales følgende **utelatt** fra første prototype:

- **Android-eksport** — allerede eksplisitt utsatt i `PROJECT_VISION.md`; ikke bygg Android-spesifikk infrastruktur (f.eks. custom build/Gradle-oppsett) før iOS-prototypen er stabil.
- **Skylagring/synkronisering på tvers av enheter** (iCloud/Play Games Services) — bekreftet utsatt i oppgaveteksten; kun lokal `user://`-lagring i prototypen.
- **In-app-kjøp og push-varsler** — ikke en del av konseptet uansett, og gitt Godots kjente friksjon med disse på iOS-eksport (se punkt 2), bør de eksplisitte kapabilitetene til og med fjernes/deaktiveres i Xcode-prosjektet for å unngå unødvendig App Review-friksjon.
- **Flerspiller/nettverksfunksjonalitet** — ikke nevnt i visjonen i det hele tatt; ingen grunn til å bygge nettverkslag nå.
- **Avansert kampsystem** — visjonen er eksplisitt at kamp ikke er hovedmekanikken; unngå å bygge generell fysikk-/treffsone-/skade-infrastruktur utover det som eventuelt trengs for enkle miljøinteraksjoner.
- **Full skjermleser-/tilgjengelighetsdekning** — Godots egen skjermleser-støtte er selv beskrevet som eksperimentell i 4.5; sikt heller mot enkle, konkrete tiltak (tekststørrelse-valg, kontrastvalg, ingen fargen-som-eneste-signal) enn full skjermleser-kompatibilitet i første versjon.
- **Automatisert terrengsammensetting/prosedural verdensgenerering** — verden er håndlaget og stedsspesifikk (ekte geografiske steder i to tidslag), så prosedural generering er sannsynligvis irrelevant for hele prosjektet, ikke bare prototypen.
- **Stort, generelt dialog-/questrammeverk (plugin eller egenbygd) før innholdsmengden er bedre forstått** — bygg et minimalt `Resource`-basert skjema for de første 1–2 stedene/oppdragene først, og utvid strukturen basert på faktiske behov, framfor å designe et altomfattende generisk system på forhånd.
- **Flere skjermstørrelse-/aspect-strategier samtidig** — velg én stretch mode/aspect-strategi (anbefalt: `expand`, se punkt 5), test den grundig på et par representative iPhone- og iPad-oppløsninger, og utsett finpuss for alle tenkelige skjermstørrelser til senere.

---

## Kilder i dette dokumentet

[1] Godot Engine. "Download Godot 4 for Windows" (nedlastingsside, viste versjon 4.7.1). Godot Engine, 2026. https://godotengine.org/download/windows/. Besøkt: 2026-07-23.

[2] Godot-dokumentasjon. "Exporting for iOS". Godot Engine 4.7 (stable), udatert sideoppdatering. https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_ios.html. Besøkt: 2026-07-23.

[3] Godot Engine. "Godot 4.5, making dreams accessible" (utgivelsesnotat). Godot Engine, 2025. https://godotengine.org/releases/4.5/. Besøkt: 2026-07-23.

[4] Godot Forum. "Godot 4.7 Release – Lights, Camera, Action!" (kunngjøring). Godot Engine-fellesskapet, 2026. https://forum.godotengine.org/t/godot-4-7-release-lights-camera-action/140267. Besøkt: 2026-07-23.

[5] Godot-dokumentasjon. "Your first 2D game". Godot Engine (stable). https://docs.godotengine.org/en/stable/getting_started/first_2d_game/index.html. Besøkt: 2026-07-23.

[6] GitHub (godotengine/godot, issue #19996). "iOS export capabilities for non paid Apple dev accounts". Godot Engine-prosjektet. https://github.com/godotengine/godot/issues/19996. Besøkt: 2026-07-23.

[7] Godot-dokumentasjon. "Exporting for Android". Godot Engine 4.6/stable. https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_android.html. Besøkt: 2026-07-23.

[8] Godot-dokumentasjon. "2D navigation overview" (navigation_introduction_2d). Godot Engine 4.7 (stable). https://docs.godotengine.org/en/stable/tutorials/navigation/navigation_introduction_2d.html. Besøkt: 2026-07-23.

[9] McGuire, Michael. "Pathfinding in Godot: Using NavigationServer2D Without Agents". Godot Dev Digest (Medium), udatert. https://medium.com/godot-dev-digest/pathfinding-in-godot-using-navigationserver2d-without-agents-b2018bb3ba41. Besøkt: 2026-07-23.

[10] Vav Labs. "AStarGrid2D vs NavigationServer: The Short Answer". Vav Labs-blogg, udatert. https://vav-labs.com/blog/godot-pathfinding-grid-vs-navmesh/. Besøkt: 2026-07-23.

[11] Vav Labs. "AStarGrid2D in Godot 4: Complete Reference". Vav Labs-blogg, udatert. https://vav-labs.com/blog/astargrid2d-complete-reference/. Besøkt: 2026-07-23.

[12] GDQuest. "Setting up pixel art graphics in Godot 4". GDQuest Library, udatert. https://www.gdquest.com/library/pixel_art_setup_godot4/. Besøkt: 2026-07-23.

[13] Shaggy Dev. "Configuring your Godot project for pixel art". The Shaggy Dev-blogg, 2021 (generelle innstillinger relevante også for nyere 4.x). https://shaggydev.com/2021/09/21/project-setup-for-pixel-art/. Besøkt: 2026-07-23.

[14] Notkey Studio. "Godot: Pixel-Perfect Low-Resolution Rendering and Smooth Camera". Notkey Studio-blogg, udatert. https://notkey.studio/en/tutorials/godot-low-res-pixel-perfect-rendering-and-smooth-camera/. Besøkt: 2026-07-23.

[15] Godot Forum. "Better Pixel Snap Camera?" (diskusjonstråd om kamera-jitter). Godot Engine-fellesskapet, udatert. https://forum.godotengine.org/t/better-pixel-snap-camera/42603. Besøkt: 2026-07-23.

[16] Godot-dokumentasjon. "Multiple resolutions" (stretch mode/stretch aspect). Godot Engine 4.7 (stable). https://docs.godotengine.org/en/stable/tutorials/rendering/multiple_resolutions.html. Besøkt: 2026-07-23.

[17] Godot Forum. "Simple way to manage the 'notch' on iOS and Android mobile devices". Godot Engine-fellesskapet, udatert. https://forum.godotengine.org/t/simple-way-to-manage-the-notch-on-ios-and-android-mobile-devices/86971. Besøkt: 2026-07-23.

[18] Splint, Steven. "Adapting Mobile Games for a Notch in Godot". stevensplint.com, udatert. https://stevensplint.com/adapting-mobile-games-for-a-notch-in-godot/. Besøkt: 2026-07-23.

[19] Godot Asset Library. "Notchz (Safe Area)" (community-plugin). Godot Engine Asset Library. https://godotengine.org/asset-library/asset/3926. Besøkt: 2026-07-23.

[20] Godot-dokumentasjon (klassereferanse). "InputEventScreenTouch". Godot Engine (stable). https://docs.godotengine.org/en/stable/classes/class_inputeventscreentouch.html. Besøkt: 2026-07-23.

[21] Godot-dokumentasjon (klassereferanse). "InputEventScreenDrag". Godot Engine (stable). https://docs.godotengine.org/en/stable/classes/class_inputeventscreendrag.html. Besøkt: 2026-07-23.

[22] Godot Engine. "Dev snapshot: Godot 4.7 dev 1" (introduserer innebygd VirtualJoystick-node). Godot Engine-blogg, 2026. https://godotengine.org/article/dev-snapshot-godot-4-7-dev-1/. Besøkt: 2026-07-23.

[23] Sharp Coder. "Enhancing Performance for Mobile Games in Godot". Sharp Coder-blogg, udatert. https://www.sharpcoderblog.com/blog/enhancing-performance-for-mobile-games-in-godot. Besøkt: 2026-07-23.

[24] Godot-dokumentasjon. "Saving games". Godot Engine 4.7 (stable). https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html. Besøkt: 2026-07-23.

[25] GDQuest. "Save and Load: Godot 4 Cheat Sheet". GDQuest Library, udatert. https://www.gdquest.com/library/cheatsheet_save_systems/. Besøkt: 2026-07-23.

[26] Bugnet Blog. "Game Save Best Practices for Godot". Bugnet-blogg, udatert. https://bugnet.io/blog/game-save-best-practices-godot. Besøkt: 2026-07-23.

[27] GameFromScratch. "Godot TileMap Replaced with TileMapLayers". GameFromScratch.com, udatert (dekker endringen introdusert i Godot 4.3). https://gamefromscratch.com/godot-tilemap-replaced-with-tilelayers/. Besøkt: 2026-07-23.

[28] Godot-dokumentasjon (klassereferanse). "TileMap" (deprecation-notis). Godot Engine 4.3. https://docs.godotengine.org/en/4.3/classes/class_tilemap.html. Besøkt: 2026-07-23.

[29] Godot-dokumentasjon. "Using TileMaps". Godot Engine 4.7 (stable). https://docs.godotengine.org/en/stable/tutorials/2d/using_tilemaps.html. Besøkt: 2026-07-23.

[30] Godot-dokumentasjon (klassereferanse). "Resource". Godot Engine 4.7 (stable). https://docs.godotengine.org/en/stable/classes/class_resource.html. Besøkt: 2026-07-23.

[31] Coding Quests. "Godot 4 Custom Resources Tutorial". codingquests.io, udatert. https://codingquests.io/blog/godot-4-custom-resources-tutorial. Besøkt: 2026-07-23.

[32] StraySpark Studio. "Dialogue and Quest Systems in Godot 4: Signals, Resources, and Branching Narratives". strayspark.studio-blogg, udatert. https://www.strayspark.studio/blog/godot-4-dialogue-quest-systems-signals-resources. Besøkt: 2026-07-23.

[33] itsfoss.com (News). "Godot 4.5 Release Brings Accessibility Features, Shader Baker, and Stencil Buffer Support". It's FOSS, 2025/2026. https://itsfoss.com/news/godot-4-5-release/. Besøkt: 2026-07-23.

[34] blog.febucci.com. "How to Dynamically Scale Font Size in Godot [Clean Approach]". Febucci-blogg, 2025. https://blog.febucci.com/2025/08/how-to-dynamically-scale-font-size-in-godot/. Besøkt: 2026-07-23.

[35] Chickensoft. "Display Scaling in Godot 4". Chickensoft-blogg, udatert. https://chickensoft.games/blog/display-scaling. Besøkt: 2026-07-23.

[36] Apple Developer. "TestFlight overview" / "Provide test information". App Store Connect Help, Apple Inc., 2026. https://developer.apple.com/help/app-store-connect/test-a-beta-version/provide-test-information/. Besøkt: 2026-07-23.

[37] Apple Developer. "TestFlight". Apple Inc., 2026. https://developer.apple.com/testflight/. Besøkt: 2026-07-23.

[38] InspiringApps. "How To Submit an Android App to the Google Play Store (2026 Guide)". InspiringApps-blogg, 2026. https://www.inspiringapps.com/blog/how-to-submit-app-to-google-play-store. Besøkt: 2026-07-23.

[39] appbuilder24.com. "Google Play Review Time 2026: How Long Approval Takes". appbuilder24.com-blogg, 2026. https://appbuilder24.com/blog/google-play-review-time. Besøkt: 2026-07-23.

[40] Google. "Publish your app". Play Console Help, Google LLC. https://support.google.com/googleplay/android-developer/answer/9859751?hl=en. Besøkt: 2026-07-23.

[41] Google. "Prepare your app for review". Play Console Help, Google LLC. https://support.google.com/googleplay/android-developer/answer/9859455. Besøkt: 2026-07-23.

[42] American Bar Association. "It's How You Play the Game: Why Videogame Rules Are Not Expression Protected by Copyright Law". Landslide (ABA IP Law Section), udatert. https://www.americanbar.org/groups/intellectual_property_law/resources/landslide/archive/why-videogame-rules-are-not-expression-protected-copyright-law/. Besøkt: 2026-07-23.

[43] LegalClarity. "Can You Copyright Game Mechanics? The Legal Answer". legalclarity.org, udatert. https://legalclarity.org/why-you-cant-copyright-game-mechanics/. Besøkt: 2026-07-23.

[44] Frankfurt Kurnit Klein & Selz. "How Courts View Copyright Protection For Video Games". fkks.com, udatert. https://fkks.com/news/how-courts-view-copyright-protection-for-video-games. Besøkt: 2026-07-23.
