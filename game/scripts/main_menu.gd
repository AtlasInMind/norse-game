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

	_menu_box = VBoxContainer.new()
	_menu_box.set_anchors_preset(Control.PRESET_CENTER)
	_menu_box.alignment = BoxContainer.ALIGNMENT_CENTER
	add_child(_menu_box)
	var menu_box := _menu_box

	var title := Label.new()
	title.text = "Norse Game"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	menu_box.add_child(title)

	var new_game_button := Button.new()
	new_game_button.text = "Nytt spill"
	new_game_button.custom_minimum_size = Vector2(0, 44)
	new_game_button.pressed.connect(_on_new_game_pressed)
	menu_box.add_child(new_game_button)

	_continue_button = Button.new()
	_continue_button.text = "Fortsett"
	_continue_button.custom_minimum_size = Vector2(0, 44)
	_continue_button.disabled = not SaveSystem.has_save()
	_continue_button.pressed.connect(_on_continue_pressed)
	menu_box.add_child(_continue_button)

	var settings_button := Button.new()
	settings_button.text = "Innstillinger"
	settings_button.custom_minimum_size = Vector2(0, 44)
	settings_button.pressed.connect(_on_settings_pressed)
	menu_box.add_child(settings_button)

	var quit_button := Button.new()
	quit_button.text = "Avslutt"
	quit_button.custom_minimum_size = Vector2(0, 44)
	quit_button.pressed.connect(_on_quit_pressed)
	menu_box.add_child(quit_button)

	_quit_label = Label.new()
	_quit_label.visible = false
	_quit_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	menu_box.add_child(_quit_label)

	_build_settings_panel()


func _build_settings_panel() -> void:
	_settings_panel = PanelContainer.new()
	_settings_panel.set_anchors_preset(Control.PRESET_CENTER)
	_settings_panel.visible = false
	add_child(_settings_panel)

	var settings_box := VBoxContainer.new()
	_settings_panel.add_child(settings_box)

	var volume_label := Label.new()
	volume_label.text = "Lydvolum"
	settings_box.add_child(volume_label)

	_volume_slider = HSlider.new()
	_volume_slider.min_value = 0.0
	_volume_slider.max_value = 1.0
	_volume_slider.step = 0.01
	_volume_slider.value = SettingsSystem.master_volume
	_volume_slider.custom_minimum_size = Vector2(200, 44)
	_volume_slider.value_changed.connect(SettingsSystem.set_master_volume)
	settings_box.add_child(_volume_slider)

	var back_button := Button.new()
	back_button.text = "Tilbake"
	back_button.custom_minimum_size = Vector2(0, 44)
	back_button.pressed.connect(_on_settings_back_pressed)
	settings_box.add_child(back_button)


func _on_new_game_pressed() -> void:
	SaveSystem.delete_save()
	QuestManager.reset()
	CurrentEra.reset()
	get_tree().change_scene_to_file(LOCATION_SCENE_PATH)


func _on_continue_pressed() -> void:
	get_tree().change_scene_to_file(LOCATION_SCENE_PATH)


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
		_quit_label.text = "Du kan trygt lukke denne fanen nå."
		_quit_label.visible = true
	else:
		get_tree().quit()
