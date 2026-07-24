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
var _is_transitioning := false


func _ready() -> void:
	layer = 100
	_overlay = ColorRect.new()
	_overlay.color = Color(0, 0, 0, 0)
	_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(_overlay)


func _unhandled_input(event: InputEvent) -> void:
	if _is_transitioning:
		return
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_E:
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
