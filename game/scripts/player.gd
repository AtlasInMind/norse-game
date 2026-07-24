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

	if not _nav_map_ready or DialogueUI.is_open():
		return

	var world_position := get_viewport().get_canvas_transform().affine_inverse() * screen_position

	# Klikk velger HVILKET objekt som menes (nærmest klikkpunktet), men
	# selve interaksjonen krever at SPILLEREN faktisk står nær nok - ellers
	# kunne man samtale med/undersøke hva som helst hvor som helst på det
	# statiske, fast-zoomede kartet uten å bevege seg i det hele tatt. Er
	# spilleren for langt unna, tolkes klikket i stedet som et vanlig
	# bevegelsesmål (som naturlig fører spilleren nærmere objektet).
	var interactable: Variant = _find_interactable(world_position)
	if interactable and global_position.distance_to(interactable.global_position) <= interactable.interact_radius:
		interactable.interact()
		return

	_nav_agent.target_position = world_position


## Finner nærmeste synlige NPC/miljøobjekt (gruppen "interactables", se
## npc.gd/interactable_object.gd) innenfor sin interact_radius fra et
## klikk/trykk. Utypet returverdi siden Npc og InteractableObject ikke deler
## en felles basetype for interact_radius/interact().
func _find_interactable(world_position: Vector2) -> Variant:
	var nearest: Variant = null
	var nearest_distance := INF
	for node: Variant in get_tree().get_nodes_in_group("interactables"):
		if not node.visible:
			continue
		var distance: float = node.global_position.distance_to(world_position)
		if distance <= node.interact_radius and distance < nearest_distance:
			nearest = node
			nearest_distance = distance
	return nearest


func _physics_process(_delta: float) -> void:
	if not _nav_map_ready or _nav_agent.is_navigation_finished():
		velocity = Vector2.ZERO
		move_and_slide()
		return

	var next_path_position := _nav_agent.get_next_path_position()
	velocity = global_position.direction_to(next_path_position) * SPEED
	move_and_slide()
