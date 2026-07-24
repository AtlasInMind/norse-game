# Glossary

## Purpose

Collect key terms — Old Norse, archaeological, linguistic, and game design/technical — with short explanations and source references (SRC-ID) where relevant. Built up as research progresses.

## Summary

Translated to English as part of the 2026-07-24 creative reboot (see `DECISIONS.md`); the underlying research citations are unchanged. The glossary holds 33 key terms drawn from the 12 research files: Old Norse social/religious concepts (e.g. thrall, thing, blót, seiðr, haugodel), archaeological/linguistic technical terms (tephrochronology, futhark, skaldic poetry), and game design/Godot-technical terms introduced during research (tap-to-move, NavigationServer2D, dual-timeline design). Each term is briefly explained with a note on which research file it's drawn from, and a SRC-ID from `source_register.md` where natural. Note: the original citation-display use of "certainty grading" described in some entries below is no longer part of the player-facing game (see the 2026-07-24 reboot entry in `DECISIONS.md`) — the underlying research distinctions still matter internally.

## Last updated

2026-07-24 (translated; original Norwegian version dated 2026-07-23)

## Status

provisional

---

## Terms

**AStarGrid2D** — Godot's built-in data structure for grid-based pathfinding (the A* algorithm on a grid), considered as a simpler alternative to NavigationServer2D for a top-down game with grid-based movement. (Source: godot_mobile_technical_research.md, SRC-TECH-010, SRC-TECH-011)

**Berserker** — In Old Norse sources, a warrior associated with ritual ferocity in battle; in modern pop culture often portrayed as a fixed, supernatural "warrior class," which the research considers an exaggeration of a thin and contested source base. (Source: authenticity_and_sensitive_topics.md, SRC-HIST-084)

**Blood eagle (the blood-eagle ritual)** — A gruesome execution ritual described in a few saga sources; its historicity is strongly disputed among scholars, and the topic is used in the research as an example of how uncertain the source basis is for specific violence details. (Source: authenticity_and_sensitive_topics.md, SRC-HIST-078)

**Blót** — Pre-Christian sacrificial ritual to the gods, performed at farms and at cult sites such as hof and hörgr; a central concept in describing Old Norse religious practice. (Source: religion_and_worldview.md, SRC-REL-008)

**Bunad** — Norwegian national costume, largely developed in the 20th century, partly inspired by national-romantic interest in the Viking Age/folk dress; used in the research as an example of how modern tradition builds on (and partly reinterprets) older history. (Source: continuity_into_modern_life.md, SRC-CONT-022)

**Danelaw** — Areas of England placed under Scandinavian/Danish law and settlement during the Viking Age; the extent and duration of actual settlement there is actively debated in the research. (Source: historical_scope.md, SRC-HIST-031, SRC-HIST-032)

**Discovery Tour mode** — A dedicated, non-violent exploration mode added to Assassin's Creed games (including the Viking-Age entry), where the player explores historically reconstructed environments with fact boxes; used as a design reference for how historical content can be integrated into a game. Note: this was the reference point for the *original*, citation-forward direction — no longer the primary design touchstone after the 2026-07-24 reboot. (Source: game_design_references.md, SRC-GAME-001)

**Dragon style ("dragestil")** — National-romantic architecture and ornamentation style from roughly 1870-1925 that deliberately drew on Viking-Age animal ornamentation and stave-church carving motifs; an example of later reuse/reinterpretation of Viking-Age motifs. (Source: continuity_into_modern_life.md, SRC-CONT-020, SRC-CONT-021)

**Drakkar (longship)** — Popular term for the Viking Age's longship, used for raiding voyages and longer journeys; distinct from the broader, deeper knarr, which was the merchant ship type. (Source: settlements_and_landscape.md, SRC-HIST-060)

**Dual-timeline design** — The game design concept at the core of Norse Game, where the player moves between a Viking-Age timeline and a modern Norwegian timeline at the same geographic place, to surface continuity and change over time. (Source: dual_timeline_design.md, continuity_into_modern_life.md)

**Eddic poetry** — Collective term for Old Norse poetry about gods and heroic legends, preserved partly in the Codex Regius (dated to roughly 1270-1280); a central oral/written source for Old Norse mythology. (Source: language_and_place_names.md, SRC-LANG-010)

**Futhark** — The Old Norse runic alphabet; the younger futhark (16 characters) was in use during the Viking Age and is used in the research as the basis for the game's rune/writing references. (Source: language_and_place_names.md, SRC-LANG-005)

**Gulating and Frostating** — Two of the Viking Age's regional "things" (law and assembly sites) in Norway; considered early forerunners of today's Norwegian court system and used as an example of legal continuity. (Source: continuity_into_modern_life.md, SRC-CONT-001, SRC-CONT-003)

**Haugodel** — A legal/social concept tied to property rights and inheritance anchored to burial mounds and farm structure in the Viking Age; used in the research on landed estates and property structure. (Source: archaeology_and_burial_sites.md, SRC-ARCH-016)

**Hof** — A built cult site/god-house for pre-Christian religious practice, documented for example at Mære in Trøndelag, where archaeological traces were found beneath a later church. (Source: continuity_into_modern_life.md, SRC-CONT-009)

**Kaupang** — Norway's first town, a Viking-Age trading site in Vestfold (active roughly 800-950), a central, archaeologically well-investigated basis for knowledge of urban activity and trade in the period. (Source: settlements_and_landscape.md, SRC-HIST-004)

**Knarr** — Broad, deep-draughted Viking-Age sailing ship built for cargo and trade across open sea, as opposed to the slimmer, faster longship. (Source: settlements_and_landscape.md, SRC-HIST-061)

**Landnám** — Old Norse term for land-taking/settlement, particularly used of the colonization of Iceland from roughly the 870s onward; dated partly through tephrochronology (volcanic ash layers). (Source: historical_scope.md, SRC-HIST-019)

**Longhouse ("langhus")** — The Viking Age's central farm building, often combining living quarters, byre, and storage under one roof; the basis for the game's farmstead environments. (Source: settlements_and_landscape.md; daily_life.md, SRC-HIST-009)

**NavigationServer2D** — Godot's built-in system for navigation-mesh-based pathfinding in 2D; weighed against AStarGrid2D as a solution for enemy movement and tap-to-move in the prototype. (Source: godot_mobile_technical_research.md, SRC-TECH-008, SRC-TECH-009)

**Ring fortress ("trelleborg")** — Circular, symmetrical fortress complexes built in Denmark in a very short time (including under Harald Bluetooth), interpreted as an expression of royal planning power. (Source: settlements_and_landscape.md, SRC-HIST-065, SRC-HIST-066)

**Safe area** — Mobile-technical screen regions not covered by camera notches, rounded corners, or the system's navigation bars (particularly on iPhone/iPad); must be accounted for in UI design so game elements aren't hidden or hard to tap. (Source: godot_mobile_technical_research.md)

**Saga (literature)** — Old Norse narratives written down from the 1100s-1300s (including by Snorri Sturluson), a central but indirect source for the Viking Age that must be read with source criticism, since they're often written long after the events they describe. (Source: language_and_place_names.md, SRC-LANG-007, SRC-LANG-008)

**Seiðr** — A form of Old Norse magic/divination, often tied to gendered roles and possible Sámi contact/influence; thoroughly treated in Neil Price's research. (Source: religion_and_worldview.md, SRC-REL-005)

**Skaldic poetry** — Formalized, often panegyric poetry performed at courts and farms to honor chieftains and kings; an important oral cultural form and indirect historical source. (Source: language_and_place_names.md, SRC-LANG-009)

**Tap-to-move** — A mobile-game interaction pattern where the player taps a point on screen and the character automatically pathfinds there; the central movement paradigm for Norse Game's mobile-friendly control scheme. (Source: godot_mobile_technical_research.md, SRC-TECH-009, SRC-TECH-010)

**Tephrochronology** — A dating method based on identifiable layers of volcanic ash (tephra) in soil/sediment, used to date early settlement in Iceland and the Faroe Islands with high precision. (Source: historical_scope.md, SRC-HIST-019, SRC-HIST-020)

**TileMap/TileSet** — Godot's system for building 2D maps/worlds out of reusable "tiles"; central to producing the game's environments in pixel-art style. (Source: godot_mobile_technical_research.md)

**Thing ("ting")** — The Viking Age's legal assembly, where free men met to settle disputes, pass laws, and discuss matters of common interest; a forerunner to later Norwegian courts and to Iceland's Althing (Þingvellir). (Source: daily_life.md, SRC-HIST-054, SRC-HIST-055; continuity_into_modern_life.md)

**Thrall ("trell")** — The unfree class in the Viking Age's three-tier social structure (thrall - farmer/free man - jarl/elite); the real extent of thralldom is uncertain, and the numbers in the sources vary widely. (Source: daily_life.md, SRC-HIST-041; authenticity_and_sensitive_topics.md, SRC-HIST-069)

**Three-tier social structure** — The traditional, but debated, model for Viking-Age social stratification into thrall, free farmer, and chieftain/jarl elite; the research emphasizes that the model is simplified and should be used with caveats. (Source: daily_life.md)

**Vaðmál** — Coarsely woven, fulled wool cloth that was the Viking Age's most common textile and also functioned as a kind of currency/value measure; central to the game's clothing design and economy references. (Source: daily_life.md, SRC-HIST-044)

**Vegvísir** — A so-called "Viking compass" symbol often sold/used today as an "authentic Old Norse" symbol, but which likely originates in Icelandic folk belief from the 1800s, not the Viking Age itself; an important example of modern myth-reinterpretation the game must handle carefully. Good material for the new belief-vs-history direction specifically, since it's already a real story about a "Viking" symbol that isn't from the Viking Age. (Source: continuity_into_modern_life.md, SRC-CONT-018)

**Þingvellir (the Althing)** — Iceland's national assembly site, established in 930, considered one of the world's oldest continuous parliamentary assembly sites; a central example of Old Norse political/legal organization. (Source: historical_scope.md, section 5.2)
