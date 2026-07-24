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

- Hvilken hostingtjeneste skal brukes for endelig utgivelse, og komprimerer den `.wasm` med brotli som standard? (Påvirker punkt «Effekt av kompresjon» over.)
- Bør det legges inn en «loading»-skjerm/progressbar i `index.html`s shell for å dekke de første sekundene med nedlasting/kompilering, gitt at selv med kompresjon tar dette flere sekunder på en typisk mobilforbindelse?
- Reell test på en fysisk mobilenhet (ikke bare simulert nettverk i en Chromium-desktop-instans).

## Kilder/researchgrunnlag

- `docs/research/godot_mobile_technical_research.md`, tillegg 2026-07-24 (web-pivot, hva som gjenstår).
- `docs/DECISIONS.md`, 2026-07-24 «Pivot til web som primærplattform».
- Egne målinger gjort i denne spiken (Godot 4.7.1, Chromium via Playwright 1.61.1, macOS-utviklermaskin), 2026-07-24.

## Sist oppdatert

2026-07-24
