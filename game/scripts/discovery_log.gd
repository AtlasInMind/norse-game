extends Node

## Globalt register over hvilke HistoricalClaim-er spilleren har møtt i dialog
## denne økten (autoload "DiscoveryLog"), jf. "oppdagelses"-logg-prinsippet i
## docs/concepts/quest_opportunities.md del 1 punkt 5: dypere historisk
## kontekst skal være tilgjengelig i eget tempo, ikke bare inline i dialogen
## der den først vises. Rent tilstandshold, uten UI - se codex_ui.gd for
## presentasjonen, etter samme adskillelse som QuestManager/QuestLogUI.

signal claim_discovered(claim: HistoricalClaim)

var _discovered_claims: Array[HistoricalClaim] = []


## Brukes av "Nytt spill" i hovedmenyen, jf. QuestManager.reset() - uten dette
## ville kodex-oppføringer fra en tidligere gjennomspilling i samme
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
