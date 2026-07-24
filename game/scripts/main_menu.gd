extends Control

## Hovedmeny (scene, ikke autoload — dette er ikke en global overlegg-UI, men
## selve run/main_scene). Bygget i kode etter samme plassholderaktige mønster
## som dialogue_ui.gd, jf. CLAUDE.md om placeholder-grafikk fram til M3.

const LOCATION_SCENE_PATH := "res://scenes/vertical_slice_location.tscn"

var _menu_box: VBoxContainer
var _continue_button: Button
var _settings_panel: Control
var _volume_slider: HSlider
var _quit_label: Label


func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)

	# "Menu"-, "Chronicle"- og "Quests"-knappene gir ingen mening før et spill
	# er i gang - se _on_new_game_pressed()/_on_continue_pressed() for der de
	# vises igjen (jf. issue #20/#21).
	PauseMenuUI.set_toggle_visible(false)
	ChronicleUI.set_toggle_visible(false)
	QuestLogUI.set_toggle_visible(false)

	var menu_center := CenterContainer.new()
	menu_center.set_anchors_preset(Control.PRESET_FULL_RECT)
	menu_center.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(menu_center)

	_menu_box = VBoxContainer.new()
	_menu_box.alignment = BoxContainer.ALIGNMENT_CENTER
	menu_center.add_child(_menu_box)
	var menu_box := _menu_box

	var title := Label.new()
	title.text = "Norse Game"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	menu_box.add_child(title)

	var new_game_button := Button.new()
	new_game_button.text = "New Game"
	new_game_button.custom_minimum_size = Vector2(0, 44)
	new_game_button.pressed.connect(_on_new_game_pressed)
	menu_box.add_child(new_game_button)

	_continue_button = Button.new()
	_continue_button.text = "Continue"
	_continue_button.custom_minimum_size = Vector2(0, 44)
	_continue_button.disabled = not SaveSystem.has_save()
	_continue_button.pressed.connect(_on_continue_pressed)
	menu_box.add_child(_continue_button)

	var settings_button := Button.new()
	settings_button.text = "Settings"
	settings_button.custom_minimum_size = Vector2(0, 44)
	settings_button.pressed.connect(_on_settings_pressed)
	menu_box.add_child(settings_button)

	var quit_button := Button.new()
	quit_button.text = "Quit"
	quit_button.custom_minimum_size = Vector2(0, 44)
	quit_button.pressed.connect(_on_quit_pressed)
	menu_box.add_child(quit_button)

	_quit_label = Label.new()
	_quit_label.visible = false
	_quit_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	menu_box.add_child(_quit_label)

	_build_settings_panel()


func _build_settings_panel() -> void:
	var settings_center := CenterContainer.new()
	settings_center.set_anchors_preset(Control.PRESET_FULL_RECT)
	settings_center.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(settings_center)

	_settings_panel = PanelContainer.new()
	_settings_panel.visible = false
	settings_center.add_child(_settings_panel)

	var settings_box := VBoxContainer.new()
	_settings_panel.add_child(settings_box)

	var volume_label := Label.new()
	volume_label.text = "Volume"
	settings_box.add_child(volume_label)

	_volume_slider = HSlider.new()
	_volume_slider.min_value = 0.0
	_volume_slider.max_value = 1.0
	_volume_slider.step = 0.01
	_volume_slider.value = SettingsSystem.master_volume
	_volume_slider.custom_minimum_size = Vector2(200, 44)
	_volume_slider.value_changed.connect(SettingsSystem.set_master_volume)
	settings_box.add_child(_volume_slider)

	var accessibility_label := Label.new()
	accessibility_label.text = "Accessibility"
	settings_box.add_child(accessibility_label)

	var text_size_label := Label.new()
	text_size_label.text = "Text size"
	settings_box.add_child(text_size_label)

	var text_size_option := OptionButton.new()
	text_size_option.custom_minimum_size = Vector2(0, 44)
	for label in SettingsSystem.TEXT_SIZE_LABELS:
		text_size_option.add_item(label)
	text_size_option.selected = SettingsSystem.text_size_index
	text_size_option.item_selected.connect(SettingsSystem.set_text_size_index)
	settings_box.add_child(text_size_option)

	var high_contrast_toggle := CheckButton.new()
	high_contrast_toggle.text = "High contrast"
	high_contrast_toggle.custom_minimum_size = Vector2(0, 44)
	high_contrast_toggle.button_pressed = SettingsSystem.high_contrast
	high_contrast_toggle.toggled.connect(SettingsSystem.set_high_contrast)
	settings_box.add_child(high_contrast_toggle)

	var back_button := Button.new()
	back_button.text = "Back"
	back_button.custom_minimum_size = Vector2(0, 44)
	back_button.pressed.connect(_on_settings_back_pressed)
	settings_box.add_child(back_button)


func _on_new_game_pressed() -> void:
	SaveSystem.delete_save()
	QuestManager.reset()
	CurrentEra.reset()
	DiscoveryLog.reset()
	_show_ingame_ui()
	get_tree().change_scene_to_file(LOCATION_SCENE_PATH)


func _on_continue_pressed() -> void:
	_show_ingame_ui()
	get_tree().change_scene_to_file(LOCATION_SCENE_PATH)


func _show_ingame_ui() -> void:
	PauseMenuUI.set_toggle_visible(true)
	ChronicleUI.set_toggle_visible(true)
	QuestLogUI.set_toggle_visible(true)


func _on_settings_pressed() -> void:
	_menu_box.visible = false
	_settings_panel.visible = true


func _on_settings_back_pressed() -> void:
	_settings_panel.visible = false
	_menu_box.visible = true


func _on_quit_pressed() -> void:
	if OS.get_name() == "Web":
		# Nettlesere tillater ikke sider å lukke faner de ikke selv åpnet
		# med window.open() — det finnes ingen pålitelig "avslutt"-handling
		# her, så vi informerer spilleren i stedet for å late som et
		# programmatisk quit() ville gjort noe.
		_quit_label.text = "You can safely close this tab now."
		_quit_label.visible = true
	else:
		get_tree().quit()
