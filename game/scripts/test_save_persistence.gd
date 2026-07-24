extends SceneTree

## Enkelt, kjørbart testscript for issue #19: bekrefter at
## QuestManager.get_save_state()/apply_save_state() og
## DiscoveryLog.get_save_state()/apply_save_state() ruller korrekt gjennom en
## faktisk JSON-rundtur (samme JSON.stringify/JSON.parse_string-mønster som
## save_system.gd bruker), OG at gjenoppretting fungerer i samme rekkefølge
## som location_era_layers.gd faktisk kaller dem i: SaveSystem.load_and_apply()
## FØR scenens quests registreres på nytt hos QuestManager. Dette er nettopp
## rekkefølgen som tidligere ville nullstilt gjenopprettet fremgang (se
## kommentaren i quest_manager.gd sin register_quest()).
## Instansierer QuestManager-/DiscoveryLog-scriptene direkte (ikke via
## autoload), samme mønster som test_quest_playthrough.gd.
## Kjør med: godot --headless --path game --script res://scripts/test_save_persistence.gd

const TEST_QUEST_PATH := "res://resources/quests/quest_vagar_fiskevaeret.tres"
const TEST_CLAIM_PATH := "res://resources/historical_claims/hc_vagar_moderne_kontinuitet.tres"


func _init() -> void:
	var failures: Array[String] = []

	_test_quest_progress_survives_json_roundtrip_and_late_registration(failures)
	_test_partial_progress_also_survives(failures)
	_test_discovery_log_roundtrip(failures)
	_test_malformed_step_counts_degrade_gracefully(failures)

	if failures.is_empty():
		print("Alle lagrings-/gjenopprettingstester bestod.")
		quit(0)
	else:
		for message in failures:
			printerr("FEIL: %s" % message)
		quit(1)


func _check(condition: bool, message: String, failures: Array[String]) -> void:
	if not condition:
		failures.append(message)


## Simulerer save_system.gd sitt faktiske lagringsformat: JSON.stringify() av
## en Dictionary som inneholder resultatet av get_save_state(), deretter
## JSON.parse_string() tilbake - ikke bare en in-memory Dictionary-kopi. Dette
## fanger opp typefeil (f.eks. int -> float) som en ren GDScript-kopi ikke ville.
func _roundtrip_through_json(value: Variant) -> Variant:
	return JSON.parse_string(JSON.stringify(value))


func _test_quest_progress_survives_json_roundtrip_and_late_registration(failures: Array[String]) -> void:
	var quest: Quest = load(TEST_QUEST_PATH)
	_check(quest != null, "Kunne ikke laste %s" % TEST_QUEST_PATH, failures)
	if quest == null:
		return

	var saving_manager: Node = preload("res://scripts/quest_manager.gd").new()
	saving_manager.register_quest(quest)
	for step in quest.steps:
		saving_manager.mark_condition(step.completion_condition)
	_check(saving_manager.is_quest_completed(quest.quest_id),
			"Forutsetning feilet: klarte ikke å fullføre %s før lagringstesten" % quest.quest_id, failures)

	var saved_state: Variant = _roundtrip_through_json(saving_manager.get_save_state())
	saving_manager.free()

	# Rekkefølgen under er bevisst identisk med location_era_layers.gd._ready():
	# SaveSystem.load_and_apply() (her: apply_save_state()) kalles FØR
	# QuestManager.register_quest() for scenens quests.
	var loading_manager: Node = preload("res://scripts/quest_manager.gd").new()
	loading_manager.apply_save_state(saved_state)
	loading_manager.register_quest(quest)

	_check(loading_manager.is_quest_completed(quest.quest_id),
			"%s: fullført-status overlevde ikke lagring -> JSON-rundtur -> sen registrering" % quest.quest_id,
			failures)
	_check(loading_manager.completed_step_count(quest.quest_id) == quest.steps.size(),
			"%s: stegtelling overlevde ikke lagring -> JSON-rundtur -> sen registrering (fikk %d, ventet %d)"
					% [quest.quest_id, loading_manager.completed_step_count(quest.quest_id), quest.steps.size()],
			failures)
	loading_manager.free()


func _test_partial_progress_also_survives(failures: Array[String]) -> void:
	var quest: Quest = load(TEST_QUEST_PATH)
	if quest == null or quest.steps.size() < 2:
		failures.append("%s: trenger minst 2 steg for delvis-fremgang-testen" % TEST_QUEST_PATH)
		return

	var saving_manager: Node = preload("res://scripts/quest_manager.gd").new()
	saving_manager.register_quest(quest)
	saving_manager.mark_condition(quest.steps[0].completion_condition)
	var saved_state: Variant = _roundtrip_through_json(saving_manager.get_save_state())
	saving_manager.free()

	var loading_manager: Node = preload("res://scripts/quest_manager.gd").new()
	loading_manager.apply_save_state(saved_state)
	loading_manager.register_quest(quest)

	_check(loading_manager.completed_step_count(quest.quest_id) == 1,
			"%s: delvis fremgang (1 steg) ble ikke korrekt gjenopprettet (fikk %d)"
					% [quest.quest_id, loading_manager.completed_step_count(quest.quest_id)], failures)
	_check(not loading_manager.is_quest_completed(quest.quest_id),
			"%s: skal IKKE regnes som fullført etter kun 1 av %d steg" % [quest.quest_id, quest.steps.size()],
			failures)
	loading_manager.free()


## Regresjonstest for et reelt funn fra kodegjennomgangen av denne PR-en:
## int() feiler hardt (uhåndterbar GDScript-runtime-feil, ikke en vanlig
## exception) på en ikke-numerisk verdi. En håndredigert/korrupt lagringsfil
## kunne dermed gitt en uventet nøkkel av feil type i completed_step_counts
## og krasjet midt i apply_save_state() sin løkke - i stedet skal én slik
## oppføring bare hoppes over, jf. samme "start friskt ved korrupt data"-
## prinsipp som resten av save_system.gd allerede følger for era/posisjon.
func _test_malformed_step_counts_degrade_gracefully(failures: Array[String]) -> void:
	var manager: Node = preload("res://scripts/quest_manager.gd").new()
	manager.apply_save_state({
		"completed_conditions": {},
		"completed_quest_ids": {},
		"completed_step_counts": {
			"ugyldig_oppdrag": null,
			"gyldig_oppdrag": 2,
		},
	})

	_check(manager.completed_step_count("gyldig_oppdrag") == 2,
			"Gyldig oppføring etter en korrupt nøkkel ble ikke gjenopprettet (fikk %d)"
					% manager.completed_step_count("gyldig_oppdrag"), failures)
	_check(manager.completed_step_count("ugyldig_oppdrag") == 0,
			"Korrupt (null) oppføring skulle vært hoppet over, ikke satt til en verdi", failures)
	manager.free()


func _test_discovery_log_roundtrip(failures: Array[String]) -> void:
	var claim: HistoricalClaim = load(TEST_CLAIM_PATH)
	_check(claim != null, "Kunne ikke laste %s" % TEST_CLAIM_PATH, failures)
	if claim == null:
		return

	var saving_log: Node = preload("res://scripts/discovery_log.gd").new()
	saving_log.register_claim(claim)
	var saved_state: Variant = _roundtrip_through_json(saving_log.get_save_state())
	saving_log.free()

	_check(typeof(saved_state) == TYPE_ARRAY, "DiscoveryLog.get_save_state(): forventet Array etter JSON-rundtur", failures)
	if typeof(saved_state) != TYPE_ARRAY:
		return

	var loading_log: Node = preload("res://scripts/discovery_log.gd").new()
	loading_log.apply_save_state(saved_state)
	var restored_claims: Array = loading_log.get_discovered_claims()

	_check(restored_claims.size() == 1,
			"DiscoveryLog: forventet 1 gjenopprettet claim, fikk %d" % restored_claims.size(), failures)
	if restored_claims.size() == 1:
		_check(restored_claims[0].resource_path == claim.resource_path,
				"DiscoveryLog: gjenopprettet claim peker på feil ressurs (%s != %s)"
						% [restored_claims[0].resource_path, claim.resource_path], failures)
	loading_log.free()
