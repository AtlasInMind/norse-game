class_name DialogueChoice
extends Resource

## Teksten spilleren ser for dette valget.
@export_multiline var choice_text: String = ""

## Neste DialogueNode dette valget fører til (tom = avslutter samtalen).
@export var next_node: DialogueNode
