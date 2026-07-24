extends Node

## Lagrer/laster grunnleggende spillfremgang lokalt, etter
## Dictionary -> JSON -> FileAccess-mønsteret i
## docs/research/godot_mobile_technical_research.md punkt 9.
##
## Persistérbare noder (for nå: spilleren, se player.gd) legger seg selv i
## PERSIST_GROUP slik at dette systemet finner dem uten en hardkodet
## scene-sti. Lagrer automatisk ved tidslagsbytte og ved
## avslutning/lukking av vinduet/fanen.

const SAVE_PATH := "user://savegame.save"
const SAVE_PATH_TMP := "user://savegame.save.tmp"
const PERSIST_GROUP := "Persist"

## Sperrer autosave-på-era-bytte mens load_and_apply() selv setter
## CurrentEra — ellers ville lastingen trigge en autosave FØR
## spillerposisjonen er gjenopprettet, og skrive den stale
## standardposisjonen tilbake til lagringsfilen.
var _loading := false


func _ready() -> void:
	CurrentEra.era_changed.connect(_on_era_changed)


func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_game()


func _on_era_changed(_new_era: Era.Type) -> void:
	if _loading:
		return
	save_game()


func save_game() -> void:
	var state := _collect_state()
	var json_text := JSON.stringify(state)

	# Skriver til en midlertidig fil og "rename"-r til endelig navn ved
	# vellykket skriving, for å unngå korrupte lagringsfiler ved avbrudd
	# midt i en skriveoperasjon.
	var file := FileAccess.open(SAVE_PATH_TMP, FileAccess.WRITE)
	if file == null:
		push_error("SaveSystem: kunne ikke åpne midlertidig lagringsfil (feil %s)" % FileAccess.get_open_error())
		return
	file.store_string(json_text)
	file.close()

	var dir := DirAccess.open("user://")
	if dir == null or dir.rename(SAVE_PATH_TMP, SAVE_PATH) != OK:
		push_error("SaveSystem: kunne ikke gjøre lagringen endelig (rename feilet)")
		return

	_sync_web_filesystem()


## Leser lagringsfilen (hvis den finnes og er gyldig) og bruker den til å
## sette CurrentEra og spillerposisjon. Gjør ingenting (starter friskt) hvis
## filen mangler eller er korrupt.
func load_and_apply() -> void:
	var state := _load_state()
	if state.is_empty():
		return

	# All feltvalidering skjer FØR _loading settes og noe faktisk brukes, slik
	# at ingen uventet felttype midt i funksjonen kan la _loading stå fast på
	# true (som ville stanset all fremtidig autosave resten av økten).
	var era_value: Variant = state.get("current_era")
	var has_valid_era := typeof(era_value) == TYPE_FLOAT or typeof(era_value) == TYPE_INT

	var pos_value: Variant = state.get("player_position")
	var has_valid_position := typeof(pos_value) == TYPE_DICTIONARY

	_loading = true

	if has_valid_era:
		CurrentEra.set_era(int(era_value))

	var player := _find_persisted_player()
	if player and has_valid_position:
		var pos: Dictionary = pos_value
		player.global_position = Vector2(
			float(pos.get("x", player.global_position.x)),
			float(pos.get("y", player.global_position.y))
		)

	_loading = false


func _collect_state() -> Dictionary:
	var state := {
		"current_era": CurrentEra.current_era,
	}
	var player := _find_persisted_player()
	if player:
		state["player_position"] = {"x": player.global_position.x, "y": player.global_position.y}
	return state


func _load_state() -> Dictionary:
	if not FileAccess.file_exists(SAVE_PATH):
		return {}

	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		return {}
	var text := file.get_as_text()
	file.close()

	var parsed: Variant = JSON.parse_string(text)
	if typeof(parsed) != TYPE_DICTIONARY:
		push_warning("SaveSystem: lagringsfilen mangler/er korrupt — starter uten lagret tilstand.")
		return {}

	return parsed


func _find_persisted_player() -> Node2D:
	return get_tree().get_first_node_in_group(PERSIST_GROUP) as Node2D


func _sync_web_filesystem() -> void:
	if OS.get_name() != "Web":
		return
	# I nettleser-eksport ligger user:// på et virtuelt filsystem støttet av
	# IndexedDB; skrivinger må eksplisitt synkroniseres for å pålitelig
	# overleve en sideoppdatering (jf. akseptansekriteriet om at user://
	# oppfører seg annerledes i nettleser enn native).
	JavaScriptBridge.eval(
		"if (typeof FS !== 'undefined' && FS.syncfs) { FS.syncfs(false, function(err) {}); }",
		true
	)
