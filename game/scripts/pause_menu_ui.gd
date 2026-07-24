extends CanvasLayer

## Globalt pause-/menyoverlegg (autoload "PauseMenuUI"), bygget i kode etter
## samme plassholderaktige mønster som quest_log_ui.gd/chronicle_ui.gd, jf.
## CLAUDE.md om placeholder-grafikk fram til M3. Eneste vei fra selve
## spillscenen tilbake til hovedmenyen (jf. issue #20/funn 3 i
## docs/playtest_m2_forste_runde.md - det fantes tidligere ingen slik vei
## utenom en full nettleser-omlasting).

var _toggle_button: Button
var _barrier: Control
var _volume_slider: HSlider


func _ready() -> void:
	layer = 80

	_toggle_button = Button.new()
	_toggle_button.text = "Menu"
	_toggle_button.custom_minimum_size = Vector2(0, 44)
	_toggle_button.set_anchors_preset(Control.PRESET_TOP_LEFT)
	_toggle_button.offset_left = 16
	_toggle_button.offset_right = 120
	_toggle_button.offset_top = 16
	_toggle_button.offset_bottom = 60
	_toggle_button.pressed.connect(toggle_menu)
	add_child(_toggle_button)

	_barrier = Control.new()
	_barrier.set_anchors_preset(Control.PRESET_FULL_RECT)
	_barrier.mouse_filter = Control.MOUSE_FILTER_STOP
	_barrier.visible = false
	add_child(_barrier)

	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	_barrier.add_child(center)

	var panel := PanelContainer.new()
	center.add_child(panel)

	var layout := VBoxContainer.new()
	panel.add_child(layout)

	var header := Label.new()
	header.text = "Menu"
	header.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	layout.add_child(header)

	var resume_button := Button.new()
	resume_button.text = "Resume"
	resume_button.custom_minimum_size = Vector2(0, 44)
	resume_button.pressed.connect(close_menu)
	layout.add_child(resume_button)

	var volume_label := Label.new()
	volume_label.text = "Volume"
	layout.add_child(volume_label)

	_volume_slider = HSlider.new()
	_volume_slider.min_value = 0.0
	_volume_slider.max_value = 1.0
	_volume_slider.step = 0.01
	_volume_slider.custom_minimum_size = Vector2(200, 44)
	_volume_slider.value_changed.connect(SettingsSystem.set_master_volume)
	layout.add_child(_volume_slider)

	var main_menu_button := Button.new()
	main_menu_button.text = "Back to Main Menu"
	main_menu_button.custom_minimum_size = Vector2(0, 44)
	main_menu_button.pressed.connect(_on_main_menu_pressed)
	layout.add_child(main_menu_button)


func _unhandled_input(event: InputEvent) -> void:
	# Speiler _toggle_button sin synlighet: gir ingen mening å åpne dette
	# overlegget (eller reagere på Escape) før et spill er i gang, se
	# set_toggle_visible().
	if not _toggle_button.visible or DialogueUI.is_open():
		return
	if not (event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_ESCAPE):
		return

	# Escape skal oppleves som "gå ett steg tilbake", ikke "åpne pause-meny
	# oppå det som allerede er åpent": hvis oppdragslogg/chronicle er åpne, lukker
	# Escape kun det panelet (samme mønster som open_menu() sin gjensidige
	# utelukkelse - se der), i stedet for å både lukke det OG åpne
	# pause-menyen på toppen i samme trykk.
	if QuestLogUI.is_open():
		QuestLogUI.close_log()
	elif ChronicleUI.is_open():
		ChronicleUI.close_chronicle()
	else:
		toggle_menu()


func toggle_menu() -> void:
	if _barrier.visible:
		close_menu()
	else:
		open_menu()


func open_menu() -> void:
	# Unngår flere fullskjerms-paneler oppå hverandre samtidig, samme mønster
	# som quest_log_ui.gd/chronicle_ui.gd bruker seg imellom.
	QuestLogUI.close_log()
	ChronicleUI.close_chronicle()
	_volume_slider.value = SettingsSystem.master_volume
	_barrier.visible = true


func close_menu() -> void:
	_barrier.visible = false


func is_open() -> bool:
	return _barrier.visible


## Brukes av main_menu.gd: "Menu"-knappen (og Escape-snarveien) gir ingen
## mening før et spill faktisk er i gang, jf. samme prinsipp som issue #21
## (Chronicle/Quests-knappene) ble filet for å dekke.
func set_toggle_visible(visible_now: bool) -> void:
	_toggle_button.visible = visible_now


func _on_main_menu_pressed() -> void:
	# Lagrer eksplisitt før scenebytte, slik at "Continue" fra hovedmenyen
	# gjenopptar nøyaktig der spilleren valgte å gå tilbake - ikke bare ved
	# forrige tidslagsbytte/oppdragsfremgang (se save_system.gd sine
	# autosave-utløsere).
	SaveSystem.save_game()
	close_menu()
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
