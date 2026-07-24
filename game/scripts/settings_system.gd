extends Node

## Globalt system for spillerinnstillinger (autoload "SettingsSystem").
## Lagrer/laster brukerpreferanser (i dag: lydvolum) lokalt, etter samme
## Dictionary -> JSON -> FileAccess-mønster som save_system.gd bruker for
## spillfremgang — men i en egen fil, siden innstillinger og spillfremgang er
## to ulike ting (innstillinger skal f.eks. overleve en "New Game").

const SETTINGS_PATH := "user://settings.save"
const MASTER_BUS_NAME := "Master"

## Lineær 0.0-1.0, som er det UI-slidere naturlig jobber i. Konverteres til dB
## kun når den brukes mot AudioServer.
var master_volume: float = 1.0


func _ready() -> void:
	_load_settings()
	_apply_master_volume()


func set_master_volume(value: float) -> void:
	master_volume = clampf(value, 0.0, 1.0)
	_apply_master_volume()
	_save_settings()


func _apply_master_volume() -> void:
	var bus_index := AudioServer.get_bus_index(MASTER_BUS_NAME)
	if bus_index == -1:
		return
	AudioServer.set_bus_mute(bus_index, master_volume <= 0.0)
	if master_volume > 0.0:
		AudioServer.set_bus_volume_db(bus_index, linear_to_db(master_volume))


func _save_settings() -> void:
	var file := FileAccess.open(SETTINGS_PATH, FileAccess.WRITE)
	if file == null:
		push_error("SettingsSystem: kunne ikke lagre innstillinger (feil %s)" % FileAccess.get_open_error())
		return
	file.store_string(JSON.stringify({"master_volume": master_volume}))
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
