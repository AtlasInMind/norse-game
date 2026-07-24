extends CanvasLayer

## Global (autoload) gest + overgangseffekt for tidslagsbytte, jf.
## docs/research/dual_timeline_design.md punkt 2: bytte skjer via
## CurrentEra-tilstanden (ingen sceneomlasting/lasteskjerm), ledsaget av en
## kort fargetone-/blend-overgang framfor et hakkete, umiddelbart hopp.
## Ligger som egen autoload (ikke i era_state.gd) siden dette er
## presentasjon+input, ikke selve tidslags-tilstanden.

## Halve overgangen (skjerm mørkner, så lysner igjen) — til sammen ca. 0,25s,
## innenfor de anbefalte 0,2-0,3 sekundene.
const FADE_DURATION := 0.125

var _overlay: ColorRect
var _toggle_button: Button
var _is_transitioning := false


func _ready() -> void:
	layer = 100
	_overlay = ColorRect.new()
	_overlay.color = Color(0, 0, 0, 0)
	_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(_overlay)

	# Touch/click affordance for the era switch, alongside the existing
	# E-key shortcut - previously keyboard-only, which meant the game's
	# central mechanic had no way to be triggered on a touch-only device
	# at all (found while writing store_copy.md, jf. issue #36). Placed
	# top-left next to PauseMenuUI's "Menu" button (offset_left 16-120).
	_toggle_button = Button.new()
	_toggle_button.text = "Era"
	_toggle_button.custom_minimum_size = Vector2(0, 44)
	_toggle_button.set_anchors_preset(Control.PRESET_TOP_LEFT)
	_toggle_button.offset_left = 136
	_toggle_button.offset_right = 220
	_toggle_button.offset_top = 16
	_toggle_button.offset_bottom = 60
	_toggle_button.visible = false
	_toggle_button.pressed.connect(_request_toggle_era)
	add_child(_toggle_button)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_E:
		_request_toggle_era()


## Brukes av main_menu.gd, samme mønster som PauseMenuUI/QuestLogUI/
## ChronicleUI: knappen gir ingen mening før et spill faktisk er i gang.
func set_toggle_visible(visible_now: bool) -> void:
	_toggle_button.visible = visible_now


func _request_toggle_era() -> void:
	if _is_transitioning or DialogueUI.is_open() or QuestLogUI.is_open() or ChronicleUI.is_open() or PauseMenuUI.is_open():
		return
	_toggle_era()


func _toggle_era() -> void:
	_is_transitioning = true
	var tween := create_tween()
	tween.tween_property(_overlay, "color:a", 1.0, FADE_DURATION)
	tween.tween_callback(_flip_era)
	tween.tween_property(_overlay, "color:a", 0.0, FADE_DURATION)
	tween.tween_callback(func() -> void: _is_transitioning = false)


func _flip_era() -> void:
	var next_era := Era.Type.MODERN if CurrentEra.current_era == Era.Type.VIKING_AGE else Era.Type.VIKING_AGE
	CurrentEra.set_era(next_era)
