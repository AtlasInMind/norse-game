extends Node

## Globalt system for spillerinnstillinger (autoload "SettingsSystem").
## Lagrer/laster brukerpreferanser (lydvolum, tekststørrelse, høykontrast)
## lokalt, etter samme Dictionary -> JSON -> FileAccess-mønster som
## save_system.gd bruker for spillfremgang — men i en egen fil, siden
## innstillinger og spillfremgang er to ulike ting (innstillinger skal f.eks.
## overleve en "New Game").
##
## Tekststørrelse/høykontrast påføres ved å tildele en generert Theme til
## get_tree().root (selve Window-noden). All UI i prosjektet er CanvasLayer-
## autoloads bygget direkte i kode uten egne lokale Theme-overstyringer
## (jf. main_menu.gd, dialogue_ui.gd, quest_log_ui.gd, chronicle_ui.gd,
## pause_menu_ui.gd), så Godots vanlige tema-nedarving fanger dermed opp all
## UI i spillet fra dette ene stedet - se godot_mobile_technical_research.md
## punkt 13.

const SETTINGS_PATH := "user://settings.save"
const MASTER_BUS_NAME := "Master"

const TEXT_SIZE_LABELS := ["Normal", "Large", "Largest"]
const TEXT_SIZE_SCALES := [1.0, 1.25, 1.5]
const BASE_FONT_SIZE := 16

const HIGH_CONTRAST_BG := Color(0.02, 0.02, 0.02)
const HIGH_CONTRAST_BG_HOVER := Color(0.16, 0.16, 0.16)
const HIGH_CONTRAST_ACCENT := Color(1.0, 0.8, 0.2)
const HIGH_CONTRAST_TEXT := Color(1.0, 1.0, 1.0)

## Lineær 0.0-1.0, som er det UI-slidere naturlig jobber i. Konverteres til dB
## kun når den brukes mot AudioServer.
var master_volume: float = 1.0

## Indeks inn i TEXT_SIZE_LABELS/TEXT_SIZE_SCALES.
var text_size_index: int = 0
var high_contrast: bool = false


func _ready() -> void:
	_load_settings()
	_apply_master_volume()
	_apply_theme()


func set_master_volume(value: float) -> void:
	master_volume = clampf(value, 0.0, 1.0)
	_apply_master_volume()
	_save_settings()


func set_text_size_index(index: int) -> void:
	text_size_index = clampi(index, 0, TEXT_SIZE_LABELS.size() - 1)
	_apply_theme()
	_save_settings()


func set_high_contrast(enabled: bool) -> void:
	high_contrast = enabled
	_apply_theme()
	_save_settings()


func _apply_master_volume() -> void:
	var bus_index := AudioServer.get_bus_index(MASTER_BUS_NAME)
	if bus_index == -1:
		return
	AudioServer.set_bus_mute(bus_index, master_volume <= 0.0)
	if master_volume > 0.0:
		AudioServer.set_bus_volume_db(bus_index, linear_to_db(master_volume))


## Bygger en ny Theme fra gjeldende innstillinger og tildeler den til
## rot-vinduet. Egenskaper som ikke settes eksplisitt her (f.eks. alle
## fargene når high_contrast er av) faller naturlig tilbake til Godots
## standardtema, siden Theme-oppslag går videre til ThemeDB sitt
## standardtema for alt som ikke er satt på det tildelte temaet.
func _apply_theme() -> void:
	var theme := Theme.new()
	theme.default_font_size = roundi(BASE_FONT_SIZE * TEXT_SIZE_SCALES[text_size_index])
	if high_contrast:
		_apply_high_contrast(theme)
	get_tree().root.theme = theme


func _apply_high_contrast(theme: Theme) -> void:
	for theme_type in ["Label", "Button", "CheckButton", "OptionButton"]:
		theme.set_color("font_color", theme_type, HIGH_CONTRAST_TEXT)
	# RichTextLabel doesn't have a "font_color" theme property - its text
	# color property is named "default_color".
	theme.set_color("default_color", "RichTextLabel", HIGH_CONTRAST_TEXT)

	var panel_style := StyleBoxFlat.new()
	panel_style.bg_color = HIGH_CONTRAST_BG
	panel_style.border_color = HIGH_CONTRAST_ACCENT
	panel_style.set_border_width_all(2)
	panel_style.set_content_margin_all(8)
	theme.set_stylebox("panel", "PanelContainer", panel_style)
	theme.set_stylebox("panel", "Panel", panel_style)

	var button_normal := panel_style.duplicate()
	theme.set_stylebox("normal", "Button", button_normal)
	theme.set_stylebox("normal", "CheckButton", button_normal)
	theme.set_stylebox("normal", "OptionButton", button_normal)

	var button_hover: StyleBoxFlat = button_normal.duplicate()
	button_hover.bg_color = HIGH_CONTRAST_BG_HOVER
	theme.set_stylebox("hover", "Button", button_hover)
	theme.set_stylebox("hover", "CheckButton", button_hover)
	theme.set_stylebox("hover", "OptionButton", button_hover)

	var button_pressed: StyleBoxFlat = button_normal.duplicate()
	button_pressed.bg_color = HIGH_CONTRAST_ACCENT
	theme.set_stylebox("pressed", "Button", button_pressed)
	theme.set_color("font_pressed_color", "Button", HIGH_CONTRAST_BG)

	var button_disabled: StyleBoxFlat = button_normal.duplicate()
	button_disabled.border_color = HIGH_CONTRAST_BG_HOVER
	theme.set_stylebox("disabled", "Button", button_disabled)
	theme.set_color("font_disabled_color", "Button", HIGH_CONTRAST_BG_HOVER)


func _save_settings() -> void:
	var file := FileAccess.open(SETTINGS_PATH, FileAccess.WRITE)
	if file == null:
		push_error("SettingsSystem: kunne ikke lagre innstillinger (feil %s)" % FileAccess.get_open_error())
		return
	file.store_string(JSON.stringify({
		"master_volume": master_volume,
		"text_size_index": text_size_index,
		"high_contrast": high_contrast,
	}))
	file.close()


func _load_settings() -> void:
	if not FileAccess.file_exists(SETTINGS_PATH):
		return
	var file := FileAccess.open(SETTINGS_PATH, FileAccess.READ)
	if file == null:
		return
	var text := file.get_as_text()
	file.close()

	var parsed: Variant = JSON.parse_string(text)
	if typeof(parsed) != TYPE_DICTIONARY:
		return
	var volume_value: Variant = parsed.get("master_volume")
	if typeof(volume_value) == TYPE_FLOAT or typeof(volume_value) == TYPE_INT:
		master_volume = clampf(float(volume_value), 0.0, 1.0)
	var text_size_value: Variant = parsed.get("text_size_index")
	if typeof(text_size_value) == TYPE_FLOAT or typeof(text_size_value) == TYPE_INT:
		text_size_index = clampi(int(text_size_value), 0, TEXT_SIZE_LABELS.size() - 1)
	var high_contrast_value: Variant = parsed.get("high_contrast")
	if typeof(high_contrast_value) == TYPE_BOOL:
		high_contrast = high_contrast_value
