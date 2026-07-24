extends Node2D

## Klikkbar NPC i lokasjonsscenen. Synlig kun i sitt eget tidslag, etter
## samme mønster som location_era_layers.gd bruker for dressing-lag. Treff-
## testen mot "interactables"-gruppen skjer i player.gd, som kaller interact()
## når spilleren klikker/trykker nær nok.

@export var npc_id: String = ""
@export var display_name: String = ""
@export var era: Era.Type = Era.Type.VIKING_AGE
@export var root_dialogue: DialogueNode
@export var interact_radius: float = 20.0

@onready var _name_label: Label = $NameLabel


func _ready() -> void:
	add_to_group("interactables")
	_name_label.text = display_name
	CurrentEra.era_changed.connect(_update_visibility)
	_update_visibility(CurrentEra.current_era)


func _update_visibility(new_era: Era.Type) -> void:
	visible = new_era == era


func interact() -> void:
	if root_dialogue:
		DialogueUI.start_dialogue(root_dialogue)
