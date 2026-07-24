class_name DialogueNode
extends Resource

## Navn på NPC-en som snakker (tom for f.eks. fortellerstemme/innsikt-tekst uten taler).
@export var speaker: String = ""

@export_multiline var text: String = ""

## Tidslaget denne dialognoden/NPC-en tilhører.
@export var era: Era.Type = Era.Type.VIKING_AGE

## Faktapåstander denne noden refererer til eller låser opp, jf.
## docs/research/dual_timeline_design.md punkt 5.
@export var related_claims: Array[HistoricalClaim] = []

## Grener/valg fram til neste node. Tom liste = bladnode (slutt på samtalen).
@export var choices: Array[DialogueChoice] = []

## Valgfri fullføringsbetingelse (samme navnerom som QuestStep.completion_condition)
## som utløses i QuestManager når denne noden vises i dialogen.
@export var completion_condition: String = ""
