extends CharacterBody2D

## Tap/klikk-til-bevegelse via NavigationServer2D (jf.
## docs/research/godot_mobile_technical_research.md punkt 3 og 7).
## Bruker _unhandled_input, ikke _input, slik at trykk på Control-baserte
## UI-elementer (som konsumerer input før det når _unhandled_input) aldri
## flytter spillerfiguren ved et uhell.

const SPEED := 120.0

@onready var _nav_agent: NavigationAgent2D = $NavigationAgent2D

## Navigasjonskartet synkroniseres først etter første fysikk-frame, så vi må
## vente med å sette navigasjonsmål til da (se punkt 3 i research-dokumentet).
var _nav_map_ready := false


func _ready() -> void:
	add_to_group(SaveSystem.PERSIST_GROUP)
	await get_tree().physics_frame
	_nav_map_ready = true


func _unhandled_input(event: InputEvent) -> void:
	var screen_position: Vector2
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		screen_position = event.position
	elif event is InputEventScreenTouch and event.pressed:
		screen_position = event.position
	else:
		return

	if not _nav_map_ready:
		return

	var world_position := get_viewport().get_canvas_transform().affine_inverse() * screen_position
	_nav_agent.target_position = world_position


func _physics_process(_delta: float) -> void:
	if not _nav_map_ready or _nav_agent.is_navigation_finished():
		velocity = Vector2.ZERO
		move_and_slide()
		return

	var next_path_position := _nav_agent.get_next_path_position()
	velocity = global_position.direction_to(next_path_position) * SPEED
	move_and_slide()
