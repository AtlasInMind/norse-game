extends SceneTree

## Enkelt, kjørbart testscript for issue #9: bekrefter at de tre nye
## Borg/Vagar/Saltstraumen-oppdragene laster korrekt, at dialogtrærne deres
## henger sammen (choices -> next_node), at hvert oppdrag har minst én
## HistoricalClaim med en reell kilde-ID fra docs/research/source_register.md,
## og at QuestManager fullfører oppdrag uansett hvilken kronologisk
## rekkefølge spilleren utløser fullføringsbetingelsene i (se
## docs/concepts/quest_opportunities.md del 1 punkt 4 om non-lineær
## oppdagelse). Instansierer QuestManager-scriptet direkte (ikke via
## autoload) for å være uavhengig av om --script-kjøring initialiserer
## autoloads.
## Kjør med: godot --headless --path game --script res://scripts/test_quest_playthrough.gd

## Hvert oppdrag mappes til dialogtrærne som faktisk brukes til å formidle
## det (noen NPC-er, som Sigrun, stiller bare spørsmålet - selve kilde-
## belagte svaret kommer fra en annen NPC eller et miljøobjekt i samme
## oppdrag, jf. designprinsipp 1 i quest_opportunities.md).
const QUEST_DIALOGUE_ROOTS := {
	"res://resources/quests/quest_borg_hovdingsete.tres": [
		"res://resources/dialogue/dn_gunnhild_greeting.tres",
	],
	"res://resources/quests/quest_vagar_fiskevaeret.tres": [
		"res://resources/dialogue/dn_sigrun_greeting.tres",
		"res://resources/dialogue/dn_torolv_greeting.tres",
	],
	"res://resources/quests/quest_saltstraumen_graven.tres": [
		"res://resources/dialogue/dn_bjorn_greeting.tres",
	],
}


func _init() -> void:
	var failures: Array[String] = []
	var source_register_text := _load_source_register_text()

	var quests: Array[Quest] = []
	for quest_path in QUEST_DIALOGUE_ROOTS:
		var quest: Quest = load(quest_path)
		_check(quest != null, "Kunne ikke laste %s" % quest_path, failures)
		if quest == null:
			continue
		quests.append(quest)

		var claims_in_quest := 0
		for root_path in QUEST_DIALOGUE_ROOTS[quest_path]:
			claims_in_quest += _check_dialogue_chain(root_path, failures, source_register_text)
		_check(claims_in_quest >= 1,
				"%s: ingen av dialogtrærne inneholder en HistoricalClaim" % quest_path, failures)

	_test_quest_step_order(failures, quests)

	if failures.is_empty():
		print("Alle oppdrags-playthrough-tester bestod.")
		quit(0)
	else:
		for message in failures:
			printerr("FEIL: %s" % message)
		quit(1)


func _check(condition: bool, message: String, failures: Array[String]) -> void:
	if not condition:
		failures.append(message)


## Går gjennom ett dialogtre (langs choices[0] - trærne her er lineære, ikke
## forgrenede utover ett valg per node) og returnerer antall HistoricalClaim-
## referanser funnet.
func _check_dialogue_chain(root_path: String, failures: Array[String], source_register_text: String) -> int:
	var node: DialogueNode = load(root_path)
	_check(node != null, "Kunne ikke laste %s" % root_path, failures)
	if node == null:
		return 0

	var claims_found := 0
	var found_completion_condition := false
	var visited := 0
	while node != null and visited < 10:
		_check(not node.speaker.is_empty(), "%s: node mangler speaker" % root_path, failures)
		_check(not node.text.is_empty(), "%s: node mangler tekst" % root_path, failures)
		for claim in node.related_claims:
			claims_found += 1
			_check(not claim.claim_text.is_empty(),
					"%s: HistoricalClaim mangler claim_text" % root_path, failures)
			_check(not claim.source_ids.is_empty(),
					"%s: HistoricalClaim mangler source_ids" % root_path, failures)
			for source_id in claim.source_ids:
				_check(source_id.begins_with("SRC-"),
						"%s: kilde-ID '%s' ser ikke ekte ut" % [root_path, source_id], failures)
				if not source_register_text.is_empty():
					_check(source_register_text.contains(source_id),
							"%s: kilde-ID '%s' finnes ikke i source_register.md" % [root_path, source_id],
							failures)
		if not node.completion_condition.is_empty():
			found_completion_condition = true
		if node.choices.is_empty():
			break
		node = node.choices[0].next_node
		visited += 1

	_check(found_completion_condition,
			"%s: dialogtreet utløser ingen fullføringsbetingelse" % root_path, failures)
	return claims_found


func _test_quest_step_order(failures: Array[String], quests: Array[Quest]) -> void:
	for quest in quests:
		_check(quest.steps.size() >= 2, "%s: skal ha minst 2 steg" % quest.quest_id, failures)

		var quest_manager: Node = preload("res://scripts/quest_manager.gd").new()
		quest_manager.register_quest(quest)

		# Markerer betingelsene i OMVENDT rekkefølge først (unntatt steg 0):
		# siden steg vises i rekkefølge, skal ingenting fullføres før det
		# første steget faktisk er markert.
		for i in range(quest.steps.size() - 1, 0, -1):
			quest_manager.mark_condition(quest.steps[i].completion_condition)
		_check(quest_manager.completed_step_count(quest.quest_id) == 0,
				"%s: fullførte steg for tidlig ved feil rekkefølge" % quest.quest_id, failures)
		_check(not quest_manager.is_quest_completed(quest.quest_id),
				"%s: markert fullført før det blokkerende første steget var gjort" % quest.quest_id,
				failures)

		# Marker til slutt steg 0 sin betingelse. Siden alle andre betingelser
		# allerede er markert (i "feil" rekkefølge over), skal oppdraget
		# fullføres i sin helhet i ett kall - ikke stå fast på steg 1, jf.
		# non-lineær oppdagelse-prinsippet i quest_opportunities.md.
		quest_manager.mark_condition(quest.steps[0].completion_condition)
		_check(quest_manager.is_quest_completed(quest.quest_id),
				"%s: ble ikke fullført etter at det blokkerende steget endelig ble markert" % quest.quest_id,
				failures)
		quest_manager.free()


func _load_source_register_text() -> String:
	var candidate_paths := [
		"res://../docs/research/source_register.md",
		ProjectSettings.globalize_path("res://").path_join("../docs/research/source_register.md"),
	]
	for path in candidate_paths:
		if FileAccess.file_exists(path):
			var file := FileAccess.open(path, FileAccess.READ)
			if file:
				return file.get_as_text()
	print("ADVARSEL: fant ikke docs/research/source_register.md - hopper over kryssjekk av kilde-ID-er.")
	return ""
