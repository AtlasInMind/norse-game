# Web-eksport-funn (M0-spike)

## Formål

Dette er det web-spesifikke research-tillegget som `godot_mobile_technical_research.md` (tillegg 2026-07-24) flagget som gjenstående: bekrefte at Godot 4.7 web-eksport faktisk fungerer for dette prosjektet, og måle bunnlinjetall (filstørrelse, lastetid) for en minimal, tom scene — før noe innhold (tiles, sprites, lyd) legges til. Se GitHub-issue #3 (M0).

## Metode

- Godot 4.7.1 (stable), installert lokalt via `brew install --cask godot`.
- Eksportmaler (`Godot_v4.7.1-stable_export_templates.tpz`) lastet ned direkte fra `godotengine/godot`-repoets GitHub Releases og lagt i `~/Library/Application Support/Godot/export_templates/4.7.1.stable/` — **disse følger ikke med Homebrew-casken** og må hentes separat (se «Problemer/begrensninger» under).
- Minimal testscene: `game/scenes/spike_hello_world.tscn` — en `Control`-rot med en fullskjerm `ColorRect`-bakgrunn og en sentrert `Label` med tekst. Ingen sprites, lyd eller tilesets.
- Eksportert via `godot --headless --export-release "Web" ../builds/web/index.html` (kommandolinje, ikke editor-GUI — reproduserbart i CI senere).
- Kjørt i faktisk Chromium (via Playwright, headless) mot en lokal HTTP-server, ikke bare antatt til å fungere. Skjermbilde bekrefter visuelt korrekt rendering.

## Resultater

### Filstørrelser (ukomprimert, som eksportert)

| Fil | Størrelse |
|---|---|
| `index.wasm` | 39,513,091 bytes (~37,7 MiB / 39,5 MB) |
| `index.js` | 279,815 bytes (~273 KiB) |
| `index.pck` | 3,488 bytes |
| `index.html` | 5,438 bytes |
| Ikoner (png) | ~22 KB til sammen |
| **Totalt** | **~38 MB** |

`index.wasm` er selve Godot-motoren (Emscripten/WebAssembly-runtime) og dominerer totalt fullstendig — dette er **motor-overhead, ikke innhold**. En scene med faktisk spillinnhold (tiles, sprites) vil legge til på disse ~38 MB, ikke erstatte dem.

### Effekt av kompresjon (viktig — testet lokalt, ikke antatt)

| Kompresjon av `index.wasm` | Størrelse | Andel av original |
|---|---|---|
| Ingen (rå) | 39,5 MB | 100 % |
| gzip -9 | 10,05 MB | ~25 % |
| brotli -q 11 | 6,90 MB | ~17 % |

**Konklusjon:** Hosting-løsningen som velges MÅ serve `.wasm`-filen med gzip- eller (helst) brotli-kompresjon. De fleste moderne statiske hostingtjenester (GitHub Pages, Netlify, Vercel, Cloudflare Pages) gjør dette automatisk, men det bør verifiseres eksplisitt når hostingvalg tas (se åpent punkt under).

### Lastetid (målt lokalt med Chromium/Playwright, ikke ekte enhet)

| Scenario | Tid til motoren logger «Godot Engine …» (boot) |
|---|---|
| Lokalt, ubegrenset båndbredde | ~130 ms |
| Simulert ~10 Mbps / 40 ms RTT ("omtrent 4G"), **ukomprimert** overføring | **~30,7 sekunder** |

Tallet på 30,7 sekunder er reelt bekymringsverdig for en "tom" scene, MEN det gjelder ukomprimert overføring (vår lokale testserver komprimerer ikke). Med brotli-kompresjon (6,9 MB i stedet for 39,5 MB) ville teoretisk nedlastingstid på samme forbindelse vært i størrelsesorden 6-7 sekunder pluss WASM-kompileringstid — fortsatt merkbart, men ikke i nærheten av 30 sekunder. **Dette er ikke målt direkte** (testserveren vår komprimerer ikke) og bør verifiseres på ekte hosting før man konkluderer at lastetid er akseptabel.

## Problemer/begrensninger oppdaget underveis

1. **Eksportmaler følger ikke med `brew install --cask godot`.** Må lastes ned separat fra `github.com/godotengine/godot/releases/tag/<versjon>-stable` (filen `Godot_v<versjon>-stable_export_templates.tpz`, ~1,2 GB, inneholder maler for ALLE plattformer) og pakkes ut til `~/Library/Application Support/Godot/export_templates/<versjon>.stable/`. Dette er et engangsoppsett per utviklermaskin, men bør dokumenteres slik at nye bidragsytere ikke bruker tid på å finne ut av det.
2. **`html/canvas_resize_policy` må settes til `2` (Adaptive), ikke `1` (Project).** Med policy `1` beholder HTML5-canvaset prosjektets faste vindusstørrelse (Godots innebygde standardverdi 1152×648 når `window/size/viewport_width|height` ikke er satt eksplisitt) uansett faktisk nettleservindu-størrelse — det gir svarte kantstolper (letterboxing) i stedet for at `Stretch Mode/Aspect = expand` faktisk fyller vinduet. Policy `2` lar canvaset følge det faktiske vinduet dynamisk, som er det `expand` faktisk forutsetter. Satt til `2` i `export_presets.cfg`.
3. **`Control`-noder må ha en `Control`- (eller `CanvasLayer`-) forelder for at ankere skal virke riktig, ikke en `Node2D`.** Første forsøk på testscenen brukte en `Node2D`-rot med `ColorRect`/`Label` som barn — bakgrunnen (som ankret til `anchor_right/bottom = 1.0`) fylte skjermen riktig, men `Label`-en (ankret til senter, 0.5/0.5) endte opp forskjøvet til øverste venstre hjørne. Årsak: en `Control` hvis forelder ikke selv er en `Control`, regner sine anker mot en implisitt null-størrelse i stedet for viewport-størrelsen. Løsning: rotnoden i scenen er nå selv en fullskjerm `Control`, og alle UI-barn er ankret mot den.
4. **Eksportmål må ligge utenfor prosjektets `res://`-tre.** Første forsøk eksporterte til `game/builds/web/` (inni selve Godot-prosjektet). Ved neste re-eksport plukket filsystem-skanneren opp de tidligere eksporterte `.png`-filene som importerbare teksturer, og la til unødvendige `.import`-filer i prosjektet. Løsning: `builds/`-mappen ligger nå i repo-roten (`builds/web/`), ved siden av `game/`, ikke inni den — lagt til i `.gitignore` siden det er bygg-output, ikke kildekode.
5. **Standard web-eksport er enkelttrådet ("single-threaded"), ikke multi-tråd.** Konsollogg bekrefter `Build configuration: Emscripten 4.0.20, single-threaded, no GDExtension support.` Dette betyr at cross-origin-isolasjons-headere (`Cross-Origin-Opener-Policy`/`Cross-Origin-Embedder-Policy`, nødvendig for `SharedArrayBuffer` ved multi-tråd) **ikke er strengt nødvendig** for denne minimale eksporten, noe som forenkler hosting betydelig (mange enkle statiske hostingtjenester setter ikke disse headerne som standard). Dette bør revurderes hvis prosjektet senere aktiverer tråd-støtte for ytelsesgrunner — det finnes egne "web_dlink"/tråd-varianter av malene om det trengs.
6. **`godot --export-release` oppretter ikke målmappen selv.** Hvis `../builds/web/` ikke finnes fra før, feiler eksporten med «Target folder does not exist or is inaccessible» i stedet for å opprette den. Må `mkdir -p` først (se README.md).
7. **Lastetids-tallene over er fra simulert nettverksforsinkelse på utviklermaskinen, ikke en ekte mobiltelefon.** Reell mobilnettleser-ytelse (spesielt eldre/rimeligere Android-enheter, som kan ha tregere WASM-kompilering enn en utviklerlaptop) er ikke testet her og bør verifiseres før man legger inn mye spillinnhold.

## Åpne spørsmål til videre arbeid (ikke løst i denne spiken)

- Reell test på en fysisk mobilenhet (ikke bare simulert nettverk i en Chromium-desktop-instans) — dekket av GitHub-issue #29 under M4.

**Løst 2026-07-25 (GitHub-issue #32):** hostingtjeneste er valgt (GitHub Pages) og verifisert i faktisk produksjon — se `docs/deployment.md` for full målemetodikk og resultat. Kort oppsummert: GitHub Pages komprimerer `.wasm` med gzip (bekreftet, ~10,2 MB), men **ikke** brotli (bekreftet fravær av `Content-Encoding: br` selv når eksplisitt forespurt) — motsier denne spikens antakelse om at «de fleste moderne statiske hostingtjenester... gjør dette automatisk». Reell, målt boot-til-hovedmeny-tid mot den faktiske live-URL-en: 9,4 sekunder på simulert ~10 Mbps, 1,1 sekunder ubegrenset — nære nok det lokale gzip-serveranslaget fra issue #28 (10,1 s) til at det bekrefter den målingen var et realistisk stand-in for ekte hosting.

## Oppdatering 2026-07-24: loading-skjerm (GitHub-issue #27)

**Korreksjon av tidligere antakelse:** `docs/playtest_m2_forste_runde.md` (funn 5) rapporterte at skjermen var «helt tom/grå, uten fremdriftsindikator» under hele lastefasen. Direkte, empirisk verifisering i denne runden (skjermbilder tatt med Playwright/Chromium under simulert ~10 Mbps/40 ms-nettverk, samme metode som resten av dette dokumentet) viser at dette **ikke stemte**: Godots standard web-eksport-mal (`misc/dist/html/full-size.html` i Godot-kildekoden) inkluderer allerede en synlig statusoverlegg med en fremdriftslinje (`<progress>`, drevet av `onProgress`-callbacken i `engine.startGame()`), som blir synlig så snart `index.js` (den lille, ~273 KB glue-filen) er lastet og kjørt — i praksis nesten umiddelbart, ikke etter flere sekunder. M2-spilltestens funn stemte trolig ikke fordi skjermbildet den gang ble tatt for tidlig i lastefasen eller ikke fanget opp den native `<progress>`-linjen visuelt.

**Det som faktisk manglet:** ikke selve fremdriftsindikatoren, men **spillspesifikk merkevarebygging** — standardmalen viser Godot-motorens egen logo/tekst («GODOT / Game engine»), ikke noe som hører til dette spillet, noe som bryter atmosfæren for en spiller som (fortsatt uvitende om at det er Godot-drevet) møter en fremmed motor-logo før spillets eget hovedmeny vises.

**Løsning:** en egen HTML-shell-mal, `game/web_export_shell.html`, registrert via `html/custom_html_shell="res://web_export_shell.html"` i `export_presets.cfg`. Bygget direkte på Godots offisielle `full-size.html`-mal (samme token-plassholdere: `$GODOT_PROJECT_NAME`, `$GODOT_SPLASH_COLOR`, `$GODOT_CONFIG` osv., slik at eksportøren fortsatt fyller inn korrekte, oppdaterte filstørrelser/config ved hver ny eksport — ingen hardkodede verdier), men med den generiske Godot-splash-bildet skjult (ingen egen boot-splash-ressurs er satt opp for spillet ennå — placeholder-fase, jf. `CLAUDE.md`) og erstattet med enkel, atmosfærisk tittel-tekst («Norse Game», samme plassholdertittel som `main_menu.gd` allerede bruker, jf. `OPEN_QUESTIONS.md` punkt 2) og en omstilt, nøytral fremdriftslinje.

**Verifisert:** reeksportert og testet i faktisk (headless) Chromium via Playwright, både under simulert 10 Mbps-nettverk (bekrefter fremdriftslinjen viser voksende fremgang gjennom hele lasteforløpet, konsistent med de ~30 sekundene ukomprimert lastetid dokumentert over) og med ubegrenset lokal båndbredde (bekrefter statusoverlegget fjernes korrekt og hovedmenyen vises normalt, ingen konsoll-/sidefeil).

**Dette løser IKKE** selve lastetids-problemet (39,5 MB `.wasm` er fortsatt 39,5 MB) — kun mangelen på passende visuell tilbakemelding mens brukeren venter. Selve lastetiden avhenger fortsatt av kompresjon på valgt hostingtjeneste (se punktet over, M5) og eventuelt av innholdsvekst siden denne spiken (se GitHub-issue #28).

## Oppdatering 2026-07-24: ny måling med faktisk spillinnhold (GitHub-issue #28)

Den opprinnelige målingen over ble tatt mot en tom testscene (`spike_hello_world.tscn`) i M0. Siden da har M1-M3 bygget tre spillbare lokasjoner (Borg, Vágar, Saltstraumen) med TileMap-er, dialog-/oppdrags-/faktapåstand-ressurser og flere UI-systemer. Denne oppdateringen re-kjører samme eksport-/målemetode (`godot --headless --export-release "Web"`, Playwright/Chromium) mot dagens prosjekttilstand, for å bekrefte om innhold faktisk har lagt merkbart til nedlastingsstørrelsen.

### Filstørrelser: sammenligning mot M0-grunnlinjen

| Fil | M0 (tom scene) | Nå (3 lokasjoner + full UI) | Endring |
|---|---|---|---|
| `index.wasm` (motor) | 39 513 091 bytes | 39 513 091 bytes | **0 — helt uendret** (motor-binæren påvirkes ikke av prosjektinnhold i det hele tatt) |
| `index.js` (motor-glue) | 279 815 bytes | 279 815 bytes | 0 — uendret |
| `index.pck` (prosjektinnhold) | 3 488 bytes | 111 568 bytes | **+108 080 bytes (~106 KB)** |
| `index.html` | 5 438 bytes | 5 947 bytes | +509 bytes (egen loading-shell fra issue #27, se over) |

**Konklusjon: innholdsveksten er reell, men neglisjerbar.** Tre komplette, spillbare lokasjoner med tilhørende `.tres`-ressurser (dialog, oppdrag, faktapåstander) og fire UI-systemer (hovedmeny, oppdragslogg, kodex, innstillinger) la til ca. 106 KB — **~0,27 % av totalvekten**, fullstendig dominert av det faste ~37,7 MiB motor-overhead-gulvet identifisert allerede i M0. Dette bekrefter M0-dokumentets egen konklusjon direkte: `Resource`/`.tres`-baserte data og plassholder-pixel-art er billig sammenlignet med selve Godot-motoren, og trenger ikke overvåkes tett med mindre spillet begynner å inkludere tunge binærressurser (lyd, video, høyoppløselig kunst) — noe som fortsatt er placeholder-fase per `CLAUDE.md`. **Dette bør ikke re-diskuteres uten konkret grunn** (f.eks. ekte lydfiler eller høyoppløst kunst lagt til) — den forventede skaleringsfaktoren er nå empirisk kjent (jf. akseptansekriterium i issue #28).

### Kompresjon: bekrefter M0s tall for motoren, måler faktisk innholdstillegg

| Fil | Ukomprimert | gzip -9 | brotli -q 11 |
|---|---|---|---|
| `index.wasm` | 39 513 091 | 10 054 511 (~25,4 %) | 6 901 775 (~17,5 %) |
| `index.pck` | 111 568 | 58 933 (~52,8 %) | 54 498 (~48,9 %) |
| `index.js` | 279 815 | 68 479 (~24,5 %) | 59 857 (~21,4 %) |

`.wasm`-kompresjonstallene er identiske til M0-målingen (samme motorbygg, uendret av innhold, som forventet). `.pck`-innholdet (tekstbaserte `.tres`-ressurser) komprimerer dårligere prosentvis enn motor-binæren (rundt halvparten, ikke ned til en femtedel), men er i absolutte tall fortsatt trivielt — 54,5 KB brotli-komprimert `.pck` mot 6,9 MB brotli-komprimert `.wasm`.

**Total brotli-komprimert kjernenyttelast (wasm+pck+js): ~7,02 MB**, opp fra M0s split-ut ~6,90 MB for `.wasm` alene (samme konklusjon: praktisk talt uendret av innholdet som faktisk er lagt til).

### Lastetid: målt direkte denne gangen, ikke bare teoretisert

M0-dokumentet estimerte teoretisk brotli-lastetid til «6-7 sekunder pluss WASM-kompileringstid», men skrev eksplisitt «dette er ikke målt direkte». Denne runden målte boot-til-hovedmeny-tid direkte (Playwright/Chromium, samme simulerte ~10 Mbps/40 ms-forbindelse som M0), ved å servere build-mappen gjennom to små lokale Python-servere som selv komprimerer med gzip hhv. brotli og setter riktig `Content-Encoding`-header (siden `python3 -m http.server` ikke komprimerer):

| Scenario | Boot-til-hovedmeny-tid |
|---|---|
| Ukomprimert, simulert ~10 Mbps/40 ms | 32,7 s (mot M0s 30,7 s til motor-logglinje — konsistent; det lille avviket er ventet siden dette måler helt til hovedmenyen er spillbar, ikke bare til motoren har logget oppstart) |
| gzip, simulert ~10 Mbps/40 ms | **10,1 s** |
| brotli, simulert ~10 Mbps/40 ms | **6,4 s** — bekrefter M0s teoretiske 6-7 sekunders anslag direkte, empirisk |
| gzip, lokalt/ubegrenset båndbredde | 1,8 s |

**Konklusjon:** M0s anbefaling — hostingtjenesten MÅ serve `.wasm` (og med fordel `.pck`/`.js`) med brotli- eller gzip-kompresjon — bekreftes nå med faktiske målte tall, ikke bare beregning. Selve valget av hostingtjeneste og bekreftelse av at den faktisk komprimerer som standard, gjenstår fortsatt som en oppgave under M5 (se punktet over).

### Metode/kilder

- Samme eksportkommando og Playwright/Chromium-oppsett som selve dette dokumentet (`godot --headless --export-release "Web"`, CDP `Network.emulateNetworkConditions`).
- Egne lokale Python `http.server`-utvidelser med on-the-fly (gzip) og forhåndsbufret (brotli, siden `-q 11` er for tregt til å kjøre per forespørsel) komprimering, kun brukt til denne målingen — ikke del av prosjektets faktiske eksport-pipeline.
- Målt 2026-07-24, samme utviklermaskin som M0-spiken.

## Kilder/researchgrunnlag

- `docs/research/godot_mobile_technical_research.md`, tillegg 2026-07-24 (web-pivot, hva som gjenstår).
- `docs/DECISIONS.md`, 2026-07-24 «Pivot til web som primærplattform».
- Egne målinger gjort i denne spiken (Godot 4.7.1, Chromium via Playwright 1.61.1, macOS-utviklermaskin), 2026-07-24.

## Sist oppdatert

2026-07-24 (tillegg: loading-skjerm løst, se eget avsnitt over, GitHub-issue #27; tillegg: ny måling med faktisk spillinnhold, GitHub-issue #28); 2026-07-25 (tillegg: hosting valgt og verifisert i produksjon, se `docs/deployment.md`, GitHub-issue #32)
