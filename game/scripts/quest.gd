class_name Quest
extends Resource

## Stabil id for oppdraget, brukt i lagringsdata og for å referere til oppdraget fra dialog.
@export var quest_id: String = ""

@export var title: String = ""

@export_multiline var description: String = ""

## Stedsnavn/lokasjon oppdraget hører til.
@export var place: String = ""

## Hvilke(t) tidslag oppdraget krever besøk i (mange oppdrag krever begge, jf.
## docs/research/dual_timeline_design.md punkt 5).
@export var required_eras: Array[Era.Type] = []

## Mål/steg spilleren må fullføre, i rekkefølge.
@export var steps: Array[QuestStep] = []
