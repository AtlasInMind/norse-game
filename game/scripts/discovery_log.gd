extends Node

## Globalt register over hvilke HistoricalClaim-er spilleren har møtt i dialog
## denne økten (autoload "DiscoveryLog"), jf. "oppdagelses"-logg-prinsippet i
## docs/concepts/quest_opportunities.md del 1 punkt 5: dypere historisk
## kontekst skal være tilgjengelig i eget tempo, ikke bare inline i dialogen
## der den først vises. Rent tilstandshold, uten UI - se chronicle_ui.gd for
## presentasjonen, etter samme adskillelse som QuestManager/QuestLogUI.

signal claim_discovered(claim: HistoricalClaim)

var _discovered_claims: Array[HistoricalClaim] = []


## Brukes av "Nytt spill" i hovedmenyen, jf. QuestManager.reset() - uten dette
## ville chronicle-oppføringer fra en tidligere gjennomspilling i samme
## nettleserøkt feilaktig fortsatt vises etter at spilleren startet på nytt.
func reset() -> void:
	_discovered_claims.clear()


func register_claim(claim: HistoricalClaim) -> void:
	if claim == null or _discovered_claims.has(claim):
		return
	_discovered_claims.append(claim)
	claim_discovered.emit(claim)


## Returnerer en kopi slik at kallere ikke kan mutere DiscoveryLogs interne tilstand.
func get_discovered_claims() -> Array[HistoricalClaim]:
	return _discovered_claims.duplicate()


## Brukes av SaveSystem. Claims identifiseres ved sin resource_path (stabil så
## lenge .tres-filene ikke flyttes/omdøpes) - Godot cacher/gjenbruker samme
## instans ved gjentatt load() av samme sti innad i økten, så dette holder
## register_claim() sin .has()-duplikatsjekk konsistent også for gjenopprettede
## oppføringer.
func get_save_state() -> Array[String]:
	var paths: Array[String] = []
	for claim in _discovered_claims:
		if not claim.resource_path.is_empty():
			paths.append(claim.resource_path)
	return paths


## Gjenoppretter tilstand fra get_save_state(). Laster ikke på nytt via
## register_claim() (som ville emittert claim_discovered for hver oppføring)
## siden dette er en stille gjenoppretting, ikke en ny oppdagelse.
func apply_save_state(paths: Array) -> void:
	_discovered_claims.clear()
	for path: Variant in paths:
		if typeof(path) != TYPE_STRING or (path as String).is_empty():
			continue
		var claim := load(path) as HistoricalClaim
		if claim != null:
			_discovered_claims.append(claim)
