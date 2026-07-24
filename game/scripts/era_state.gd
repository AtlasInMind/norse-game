extends Node

## Globalt tidslags-tilstandsystem (autoload "CurrentEra").
## Styrer hvilket tidslag som er aktivt; lokasjonsscener lytter på era_changed
## for å slå av/på sine tidslags-spesifikke dressing-lag (jf.
## docs/research/dual_timeline_design.md punkt 2). Selve bytte-mekanikken
## (input, overgangseffekt, ingen lasteskjerm) hører til et senere issue.

signal era_changed(new_era: Era.Type)

var current_era: Era.Type = Era.Type.VIKING_AGE


func set_era(new_era: Era.Type) -> void:
	if new_era == current_era:
		return
	current_era = new_era
	era_changed.emit(current_era)
