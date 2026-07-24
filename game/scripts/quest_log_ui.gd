extends CanvasLayer

## Globalt oppdragslogg-UI (autoload "QuestLogUI"), bygget i kode etter
## samme plassholderaktige mønster som dialogue_ui.gd, jf. CLAUDE.md om
## placeholder-grafikk fram til M3. Viser aktive oppdrag med tittel,
## beskrivelse og steg-status, koblet til QuestManager sine signaler.

const STEP_DONE_COLOR := Color(0.4, 0.75, 0.45)
const STEP_PENDING_COLOR := Color(0.8, 0.8, 0.8)

var _toggle_button: Button
var _barrier: Control
var _quests_box: VBoxContainer


func _ready() -> void:
	layer = 80

	_toggle_button = Button.new()
	_toggle_button.text = "Oppdrag"
	_toggle_button.custom_minimum_size = Vector2(0, 44)
	_toggle_button.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	_toggle_button.grow_horizontal = Control.GROW_DIRECTION_BEGIN
	_toggle_button.offset_left = -120
	_toggle_button.offset_right = -16
	_toggle_button.offset_top = 16
	_toggle_button.offset_bottom = 60
	_toggle_button.pressed.connect(toggle_log)
	add_child(_toggle_button)

	_barrier = Control.new()
	_barrier.set_anchors_preset(Control.PRESET_FULL_RECT)
	_barrier.mouse_filter = Control.MOUSE_FILTER_STOP
	_barrier.visible = false
	add_child(_barrier)

	var panel := PanelContainer.new()
	panel.set_anchors_preset(Control.PRESET_FULL_RECT)
	panel.offset_left = 16
	panel.offset_right = -16
	panel.offset_top = 16
	# Nesten full skjermhøyde: Control.clip_contents klipper ikke overskytende
	# innhold i denne gl_compatibility-web-eksporten (bekreftet - verken på
	# scroll, panel eller barrier har noen synlig effekt), så med kun 2-3
	# oppdrag totalt i den vertikale skiven er det tryggere å gi loggen nok
	# plass til å vise alt enn å stole på en scrollbar som ikke faktisk klipper.
	panel.offset_bottom = -16
	_barrier.add_child(panel)

	var outer_layout := VBoxContainer.new()
	panel.add_child(outer_layout)

	var header := Label.new()
	header.text = "Oppdragslogg"
	outer_layout.add_child(header)

	var close_button := Button.new()
	close_button.text = "Lukk"
	close_button.custom_minimum_size = Vector2(0, 44)
	close_button.pressed.connect(close_log)
	outer_layout.add_child(close_button)

	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	outer_layout.add_child(scroll)

	_quests_box = VBoxContainer.new()
	_quests_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(_quests_box)

	QuestManager.quest_step_completed.connect(_on_quest_progress_changed)
	QuestManager.quest_completed.connect(_on_quest_progress_changed)


func _unhandled_input(event: InputEvent) -> void:
	if not _toggle_button.visible or DialogueUI.is_open():
		return
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_L:
		toggle_log()


func toggle_log() -> void:
	if _barrier.visible:
		close_log()
	else:
		open_log()


func open_log() -> void:
	# Unngår flere fullskjerms-paneler oppå hverandre samtidig.
	ChronicleUI.close_chronicle()
	PauseMenuUI.close_menu()
	_refresh()
	_barrier.visible = true


func close_log() -> void:
	_barrier.visible = false


func is_open() -> bool:
	return _barrier.visible


## Brukes av main_menu.gd: "Oppdrag"-knappen gir ingen mening før et spill
## faktisk er i gang (jf. issue #21 - samme prinsipp som
## PauseMenuUI.set_toggle_visible() ble innført for i issue #20).
func set_toggle_visible(visible_now: bool) -> void:
	_toggle_button.visible = visible_now
	if not visible_now:
		close_log()


func _on_quest_progress_changed(_quest: Quest, _step_index: int = -1) -> void:
	if _barrier.visible:
		_refresh()


func _refresh() -> void:
	for child in _quests_box.get_children():
		child.queue_free()

	# Fullførte oppdrag fjernes fra loggen (i stedet for å markeres) - med kun
	# 2-3 oppdrag totalt i den vertikale skiven er dette enklere for
	# spilleren å lese enn en stadig voksende liste med fullførte oppføringer.
	var quests := QuestManager.get_active_quests().filter(
		func(quest: Quest) -> bool: return not QuestManager.is_quest_completed(quest.quest_id)
	)

	if quests.is_empty():
		var empty_label := Label.new()
		empty_label.text = "Ingen aktive oppdrag."
		_quests_box.add_child(empty_label)
		return

	for quest in quests:
		_quests_box.add_child(_build_quest_entry(quest))


func _build_quest_entry(quest: Quest) -> Control:
	var entry := VBoxContainer.new()

	var title_label := Label.new()
	title_label.text = quest.title
	entry.add_child(title_label)

	var description_label := Label.new()
	description_label.text = quest.description
	description_label.autowrap_mode = TextServer.AUTOWRAP_WORD
	entry.add_child(description_label)

	var done_count := QuestManager.completed_step_count(quest.quest_id)
	for i in quest.steps.size():
		var step: QuestStep = quest.steps[i]
		var step_label := Label.new()
		var is_done := i < done_count
		step_label.text = "[%s] %s" % ["Fullført" if is_done else "Gjenstår", step.description]
		step_label.modulate = STEP_DONE_COLOR if is_done else STEP_PENDING_COLOR
		step_label.autowrap_mode = TextServer.AUTOWRAP_WORD
		entry.add_child(step_label)

	return entry
