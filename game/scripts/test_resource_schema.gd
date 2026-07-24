extends SceneTree

## Enkelt, kjørbart testscript for issue #4: bekrefter at HistoricalClaim, DialogueNode,
## DialogueChoice og Quest/QuestStep kan lastes fra disk og at feltene deres er intakte.
## Kjør med: godot --headless --path game --script res://scripts/test_resource_schema.gd


func _init() -> void:
	var failures: Array[String] = []

	_test_historical_claim(failures)
	_test_dialogue(failures)
	_test_quest(failures)

	if failures.is_empty():
		print("Alle resource-skjema-tester bestod.")
		quit(0)
	else:
		for message in failures:
			printerr("FEIL: %s" % message)
		quit(1)


func _check(condition: bool, message: String, failures: Array[String]) -> void:
	if not condition:
		failures.append(message)


func _test_historical_claim(failures: Array[String]) -> void:
	var claim: HistoricalClaim = load("res://resources/historical_claims/hc_tirsdag_ty.tres")
	_check(claim != null, "Kunne ikke laste hc_tirsdag_ty.tres", failures)
	if claim == null:
		return
	_check(claim.era == Era.Type.VIKING_AGE, "HistoricalClaim.era feil verdi", failures)
	_check(claim.certainty == HistoricalClaim.Certainty.ESTABLISHED,
			"HistoricalClaim.certainty feil verdi", failures)
	_check(claim.source_ids == ["SRC-CONT-014"],
			"HistoricalClaim.source_ids skal inneholde SRC-CONT-014", failures)
	_check(not claim.claim_text.is_empty(), "HistoricalClaim.claim_text er tom", failures)


func _test_dialogue(failures: Array[String]) -> void:
	var greeting: DialogueNode = load("res://resources/dialogue/dn_test_greeting.tres")
	_check(greeting != null, "Kunne ikke laste dn_test_greeting.tres", failures)
	if greeting == null:
		return
	_check(greeting.choices.size() == 1, "DialogueNode.choices skal ha 1 valg", failures)
	_check(greeting.related_claims.size() == 1,
			"DialogueNode.related_claims skal ha 1 kobling", failures)

	var choice: DialogueChoice = greeting.choices[0]
	_check(choice is DialogueChoice, "Valg er ikke en DialogueChoice", failures)
	_check(choice.next_node != null, "DialogueChoice.next_node mangler", failures)
	_check(choice.next_node.speaker == "Ravnkjell",
			"DialogueChoice.next_node peker på feil node", failures)


func _test_quest(failures: Array[String]) -> void:
	var quest: Quest = load("res://resources/quests/quest_test_weekday_names.tres")
	_check(quest != null, "Kunne ikke laste quest_test_weekday_names.tres", failures)
	if quest == null:
		return
	_check(quest.steps.size() == 2, "Quest.steps skal ha 2 steg", failures)
	_check(quest.required_eras == [Era.Type.MODERN, Era.Type.VIKING_AGE],
			"Quest.required_eras skal inneholde begge tidslag", failures)

	var first_step: QuestStep = quest.steps[0]
	_check(first_step is QuestStep, "Steg er ikke en QuestStep", failures)
	_check(first_step.era == Era.Type.MODERN, "Første steg skal være i moderne tidslag", failures)
