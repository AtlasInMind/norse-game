# Spilltest — første runde (M2)

## Formål

Dokumentere funn fra første spilltestrunde av den spillbare vertikale skiven (Borg/Vágar-området fra M1) pluss kjernesystemene bygget i M2 (hovedmeny, innstillinger, oppdragslogg, kodex), jf. issue #18. Testen dekker hele løpet fra hovedmeny til gjennomført oppdrag og lagring/gjenåpning, kjørt i en faktisk nettleser-eksport (ikke Godot-editorens innebygde spillvindu).

## Metode

- Eksportert med `godot --headless --export-release "Web" ../builds/web/index.html` (samme kommando som `docs/research/web_export_findings.md`), servert lokalt med `python3 -m http.server`.
- Kjørt i faktisk (headless) Chromium via Playwright, drevet av et lite skript som klikker/trykker på skjermkoordinater — Godots web-eksport tegner alt til ett `<canvas>`-element, så det finnes ingen DOM-tekst å søke i; alle interaksjoner er museklikk/tastetrykk på pikselposisjoner, verifisert med skjermbilder etter hvert steg.
- Konsoll-/sidefeil (`console`/`pageerror`) logget gjennom hele økten.
- Dekket løp: hovedmeny → innstillinger → nytt spill → utforsking → tidslagsbytte (E-tast) → NPC-dialog med kildebelagte historiske påstander → fullført oppdrag ("Fiskeværet som aldri sluttet", alle tre steg) → kodex-visning av oppdagelser → full nettleser-omlasting (`page.reload()`, ikke bare scene-bytte i samme økt) → "Fortsett" fra hovedmenyen.

## Resultater — det som fungerte

- **Hele kjerneløpet fungerer uten krasj eller konsollfeil**, fra hovedmeny til fullført oppdrag til reload. Ingen `pageerror`- eller `[error]`-konsollmeldinger i noen del av testen.
- **Tap-to-move** (`NavigationServer2D`/`NavigationAgent2D`) fungerer som forventet — klikk i verden flytter spilleren til punktet.
- **Tidslagsbytte** (E-tast) fungerer, med kort fade-overgang, og de riktige NPC-ene/objektene for hvert tidslag vises/skjules korrekt.
- **Dialogsystemet** viser forgrenet dialog med kildebelagte historiske påstander inline (sikkerhetsgrad, kildeID, f.eks. `SRC-HIST-095`), i tråd med kildekravene i CLAUDE.md/`source_register.md`.
- **Oppdragslogg-UI-et** viser riktig stegvis fremgang, og et helt oppdrag ("Fiskeværet som aldri sluttet") ble fullført og forsvant korrekt fra aktiv-listen etter at alle tre steg var oppfylt. Dette bekrefter også at `quest_manager.gd`s ikke-lineære oppdagelsesprinsipp fungerer som designet: jeg snakket først med Torolv (steg 3, vikingtidslaget) uten at oppdragsloggen viste noen fremgang ennå (steg 1/2 var ikke gjort), og da jeg senere fullførte skiltet og Sigrun (steg 1/2, moderne laget) i rekkefølge, fanget fremgangsloggen automatisk opp alle tre stegene i ett steg — helt i tråd med kommentaren i `_advance_quest()` om at spilleren kan utløse fullføringsbetingelser i vilkårlig kronologisk rekkefølge.
- **Kodex-UI-et** logget alle tre historiske påstander oppdaget hos Torolv, gruppert per sted, med sikkerhetsgrad-farger og kildeID-er.
- **Lagring av tidslag + spillerposisjon overlever en faktisk nettleser-omlasting** (`page.reload()`, ikke bare scenebytte) — "Fortsett" var korrekt deaktivert før noe spill var startet, og korrekt aktivert/fungerende etter at en lagring fantes.
- **Touch-knappestørrelse**: alle knapper i dialog-, oppdragslogg- og kodex-UI-et er bygget med `custom_minimum_size = Vector2(0, 44)`, i tråd med anbefalingen i `godot_mobile_technical_research.md` punkt 7 (allerede verifisert for dialog-UI-et spesifikt i issue #17).

## Funn — rettet i denne runden

### 1. Hovedmeny og innstillingspanel var ikke faktisk sentrert (rettet)

`main_menu.gd` satte `Control.PRESET_CENTER` direkte på menyboksen/innstillingspanelet. I Godot betyr dette at kontrollens **øvre venstre hjørne** plasseres i skjermsenteret, ikke at selve boksen sentreres — for en dynamisk størrelses-`VBoxContainer`/`PanelContainer` betyr det at hele menyen/panelet visuelt henger nede til høyre for faktisk skjermsenter (bekreftet i skjermbilde: boks-senter ca. (435, 373) mot faktisk skjermsenter (400, 300) i en 800×600 canvas).

**Retting:** Pakket begge inn i en `CenterContainer` med `PRESET_FULL_RECT`, som sentrerer barnet etter dets faktiske minimumsstørrelse. Verifisert visuelt etter fiks: boks-senter nå ca. (400, 296), i praksis sentrert.

**Følgefeil oppdaget og rettet i samme runde:** Den nye full-rect `CenterContainer`-innpakningen fanget opp museklikk over **hele** skjermen (standard `mouse_filter`), noe som blokkerte klikk på menyknappene under. Rettet ved å sette `mouse_filter = Control.MOUSE_FILTER_IGNORE` på begge innpaknings-containerne, slik at kun de faktiske knappene/kontrollene fanger klikk. Verifisert med regresjonstest av "Nytt spill", "Innstillinger" og "Tilbake" etter fiksen — alle fungerer.

Denne kombinasjonen (sentrerings-container + `MOUSE_FILTER_IGNORE`) er verdt å huske som mønster for annen fremtidig plassholder-UI bygget i kode, siden feilen er lett å gjenta.

## Funn — ikke rettet, foreslått som oppfølgingsissues

### 2. Oppdrags- og kodex-fremgang overlever ikke en reell nettleser-omlasting

`SaveSystem` lagrer kun `current_era` og spillerposisjon (se `save_system.gd`). `QuestManager` og `DiscoveryLog` er rene økt-interne autoloads uten lagringsstøtte — dette er allerede eksplisitt kommentert i koden ("Ikke lagringspersistert ennå — oppdragsfremgang varer kun for gjeldende økt").

**Bekreftet empirisk i denne testen:** Et fullført oppdrag ("Fiskeværet som aldri sluttet", alle tre steg utført) og tre kodex-oppføringer forsvant fullstendig etter en faktisk `page.reload()` — oppdraget vises igjen som ikke-startet, og kodexen viser "Ingen oppdagelser ennå", selv om `current_era`/spillerposisjon ble korrekt gjenopprettet.

**Vurdering:** Ikke en blokkerende feil for dette issuet (ingen krasj, og gapet er allerede dokumentert som en bevisst avgrenset, utsatt del av lagringssystemet) — men det er reell spillopplevelse-friksjon en spiller ville møte i produksjon: fremgang som virker lagret (tidslag/posisjon er der) mens annen fremgang (oppdrag/kodex) ikke er det, uten noen indikasjon til spilleren om dette skillet. Bør løses som eget issue før M3 (utvid `SaveSystem._collect_state()`/`_load_state()` til å inkludere `QuestManager`s og `DiscoveryLog`s tilstand — begge har allerede en klar `Dictionary`-vennlig form via `completion_condition`-strenger/klage-ID-er).

### 3. Ingen vei tilbake til hovedmenyen fra spillet

Det finnes ingen pause-meny, ingen Escape-håndtering og ingen annen mekanisme for å komme fra selve spillscenen tilbake til hovedmenyen (for å endre lydvolum, eller bytte/avslutte spill) uten en full nettleser-omlasting. `grep` etter `change_scene`/`main_menu` i `scripts/` bekrefter at kun `main_menu.gd` selv trigger scenebytte til spillet — ingenting trigger den andre veien.

**Vurdering:** Ikke blokkerende (påvirker ikke løpet testet i dette issuet), men en åpenbar mangel som bør dekkes av et eget issue (pause-/menyknapp i spillscenen, ev. Escape-tast på desktop) før prosjektet regnes som spillbart ende-til-ende for en vanlig spiller.

### 4. Kodex/Oppdrag-knappene er synlige og klikkbare fra hovedmenyen før et spill er startet

`CodexUI`/`QuestLogUI` er globale autoloads (egne `CanvasLayer`-noder), og deres toggleknapper øverst til høyre er derfor alltid til stede — også oppå selve hovedmenyen, før "Nytt spill"/"Fortsett" er trykket. Å trykke dem der åpner tomme paneler ("Ingen oppdagelser ennå", ingen aktive oppdrag) uten feil, men det er forvirrende UX å vise spillfremgang-knapper før et spill i det hele tatt er i gang.

**Vurdering:** Ikke blokkerende, mindre UX-uryddighet. Foreslått løsning for oppfølgingsissue: skjul disse to knappene mens hovedmenyscenen er aktiv (f.eks. ved at `main_menu.gd` skjuler dem ved `_ready()` og hovedmenyens `_on_new_game_pressed`/`_on_continue_pressed` viser dem igjen før scenebytte).

## Funn — bekrefter eksisterende, allerede dokumentert åpent spørsmål (ingen ny handling nødvendig nå)

### 5. Ingen synlig lastefeedback under WASM-oppstart

Under hele lastefasen (før hovedmenyen vises) er skjermen helt tom/grå, uten fremdriftsindikator. Dette bekrefter — men utvider ikke — det åpne spørsmålet allerede notert i `docs/research/web_export_findings.md` ("Bør det legges inn en «loading»-skjerm/progressbar..."). Eksportert `index.wasm` var 39 513 091 bytes i denne runden, i tråd med samme dokuments tidligere måling (~39,5 MB ukomprimert). Ingen ny handling nødvendig her utover det som allerede står i det dokumentet — nevnes for å bekrefte at funnet fortsatt er gyldig med faktisk spillinnhold (ikke bare den tomme spike-scenen fra M0).

## Akseptansekriterier — status

- [x] Hele løpet fra hovedmeny → nytt spill → utforsking av Borg/Vágar → minst ett fullført oppdrag → lagring/gjenåpning er testet i faktisk nettleser-eksport.
- [x] Funn (feil, UX-friksjon, ev. ytelsesproblemer) er dokumentert i dette dokumentet.
- [x] Kritiske/blokkerende funn er rettet (hovedmeny-/innstillingssentrering + påfølgende klikk-blokkering) — ingen andre funn vurderes som blokkerende, se begrunnelse per punkt over. Mindre funn (punkt 2–4) foreslås som oppfølgingsissues.
- [x] `docs/RESEARCH_INDEX.md` oppdatert med referanse til dette dokumentet.

## Sist oppdatert

2026-07-24
