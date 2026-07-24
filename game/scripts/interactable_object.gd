extends Node2D

## Klikkbart miljøobjekt (f.eks. en forhøyning i jordet, en grav) som lar
## miljøet "snakke først", jf. designprinsipp 1 i
## docs/concepts/quest_opportunities.md del 1: en fysisk detalj skal kunne
## undersøkes før noen NPC forklarer den. Synlig kun i sitt eget tidslag,
## samme mønster som npc.gd.

@export var era: Era.Type = Era.Type.VIKING_AGE
@export_multiline var examine_text: String = ""
@export var completion_condition: String = ""
@export var related_claim: HistoricalClaim
@export var interact_radius: float = 20.0


func _ready() -> void:
	add_to_group("interactables")
	CurrentEra.era_changed.connect(_update_visibility)
	_update_visibility(CurrentEra.current_era)


func _update_visibility(new_era: Era.Type) -> void:
	visible = new_era == era


func interact() -> void:
	var node := DialogueNode.new()
	node.text = examine_text
	node.era = era
	node.completion_condition = completion_condition
	if related_claim:
		node.related_claims = [related_claim]
	DialogueUI.start_dialogue(node)
