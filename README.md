# Norse Game

Et spill inspirert av norrøn mytologi, bygget i Godot.

## Status

Tidlig prosjektoppstart — ingen spillbar versjon ennå.

## Utvikling

Godot-prosjektet ligger i `game/`, ikke i repo-roten. Dette holder spillkoden atskilt fra kunnskapsgrunnlaget/backloggen i `docs/`, som er repoets primære innhold i tidlig fase.

### Åpne/kjøre prosjektet

1. Installer [Godot 4.x](https://godotengine.org/download) (stabil versjon, testet med 4.7).
2. Klon repoet.
3. Åpne Godot, velg "Import", og pek på `game/project.godot`.
4. Trykk F5 (eller "Run Project") for å kjøre.

### Mappestruktur (`game/`)

- `scenes/` — `.tscn`-scener (steder, UI, spillerfigurer).
- `tilesets/` — `TileSet`-ressurser og tilhørende tile-grafikk.
- `resources/` — egendefinerte `Resource`-klasser og `.tres`-data (faktapåstander, dialog, oppdrag).
- `scripts/` — GDScript-filer som ikke er direkte knyttet til én scene (autoloads, hjelpeklasser).

### Prosjektinnstillinger

- Default Texture Filter: Nearest (for skarp pixel art).
- Stretch Mode: `canvas_items`, Stretch Aspect: `expand` (jf. `docs/research/godot_mobile_technical_research.md` punkt 4-5).
- Renderer: GL Compatibility (kreves for web-eksport, jf. `docs/DECISIONS.md` 2026-07-24 web-pivot).

### Web-eksport

1. Last ned Godot-eksportmaler som matcher editor-versjonen fra `github.com/godotengine/godot/releases` (`Godot_v<versjon>-stable_export_templates.tpz`) og pakk ut til `~/Library/Application Support/Godot/export_templates/<versjon>.stable/` (macOS). Disse følger **ikke** med Homebrew-casken og må hentes manuelt — engangsoppsett per maskin.
2. Eksporter fra kommandolinjen: `mkdir -p ../builds/web && godot --headless --export-release "Web" ../builds/web/index.html` (kjørt fra `game/`). Målmappen må finnes på forhånd — Godot oppretter den ikke selv. Output havner i `builds/` i repo-roten (utenfor `game/`s ressurstre, git-ignorert).
3. For å teste lokalt: server `builds/web/` med en enkel HTTP-server (f.eks. `python3 -m http.server`) og åpne i nettleser — kan ikke åpnes direkte som `file://`.
4. Se `docs/research/web_export_findings.md` for målte filstørrelser/lastetider og kjente konfigurasjonsfeller (canvas-resize-policy, Control-ankere, m.m.).
