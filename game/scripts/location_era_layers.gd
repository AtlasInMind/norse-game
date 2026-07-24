extends Node2D

## Kobler en lokasjonsscenes tidslags-spesifikke dressing-lag til det globale
## CurrentEra-tilstandssystemet: kun laget som matcher aktivt tidslag er synlig.
## Felles grunnlags-laget (terreng/ferdselslinjer) styres ikke herfra — det skal
## alltid være synlig i begge tidslag.

@export var modern_layer_path: NodePath = ^"ModernLayer"
@export var viking_layer_path: NodePath = ^"VikingLayer"

@onready var _modern_layer: TileMapLayer = get_node(modern_layer_path)
@onready var _viking_layer: TileMapLayer = get_node(viking_layer_path)


func _ready() -> void:
	CurrentEra.era_changed.connect(_apply_era)
	_apply_era(CurrentEra.current_era)


func _apply_era(era: Era.Type) -> void:
	_modern_layer.visible = era == Era.Type.MODERN
	_viking_layer.visible = era == Era.Type.VIKING_AGE
