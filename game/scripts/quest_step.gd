class_name QuestStep
extends Resource

@export_multiline var description: String = ""

## Tidslaget spilleren må være i for å utføre/fullføre dette steget.
@export var era: Era.Type = Era.Type.VIKING_AGE

## Fritekst-betingelse for når steget regnes som fullført (f.eks. "snakket_med_ravnkell",
## "besøkt_gravhaug"). Kobles til faktisk speil-/signallogikk i senere issues.
@export var completion_condition: String = ""
