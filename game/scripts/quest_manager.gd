extends Node

## Globalt oppdragssystem (autoload "QuestManager").
## Sporer aktive oppdrag og hvilke fullføringsbetingelser (completion_condition
## fra QuestStep/DialogueNode) som er oppfylt denne økten. Steg fullføres i
## rekkefølge, jf. kommentaren i quest.gd om at steps er ordnet.
## Lagringspersistert via get_save_state()/apply_save_state(), se
## save_system.gd.

signal quest_step_completed(quest: Quest, step_index: int)
signal quest_completed(quest: Quest)

var _active_quests: Array[Quest] = []
var _completed_conditions: Dictionary = {}
var _completed_step_counts: Dictionary = {}
var _completed_quest_ids: Dictionary = {}


## Brukes av "Nytt spill" i hovedmenyen: uten dette ville en Quest-Resource
## som allerede er fullført tidligere i samme nettleserøkt (Godot cacher/
## gjenbruker samme instans ved gjentatt lasting av samme .tres-fil) fortsatt
## telle som registrert/fullført i register_quest() sin duplikatsjekk under.
func reset() -> void:
	_active_quests.clear()
	_completed_conditions.clear()
	_completed_step_counts.clear()
	_completed_quest_ids.clear()


func register_quest(quest: Quest) -> void:
	if quest == null or _active_quests.has(quest):
		return
	_active_quests.append(quest)
	# Ingen eksplisitt _completed_step_counts-initialisering her: alle
	# lesesteder (completed_step_count(), _advance_quest()) bruker allerede
	# .get(id, 0), og en eksplisitt "= 0" her ville nullstilt fremgang
	# gjenopprettet av SaveSystem.load_and_apply() - som kalles FØR
	# location_era_layers.gd registrerer scenens quests på nytt.


func mark_condition(condition_id: String) -> void:
	if condition_id.is_empty() or _completed_conditions.has(condition_id):
		return
	_completed_conditions[condition_id] = true
	for quest in _active_quests:
		_advance_quest(quest)


func is_condition_met(condition_id: String) -> bool:
	return _completed_conditions.has(condition_id)


func is_quest_completed(quest_id: String) -> bool:
	return _completed_quest_ids.has(quest_id)


## Brukes av oppdragslogg-UI-et for å liste aktive oppdrag. Returnerer en
## kopi slik at kallere ikke kan mutere QuestManagers interne tilstand.
func get_active_quests() -> Array[Quest]:
	return _active_quests.duplicate()


func completed_step_count(quest_id: String) -> int:
	return _completed_step_counts.get(quest_id, 0)


## Brukes av SaveSystem. De interne dictionaryene er allerede rene
## streng-/heltallsstrukturer (ingen Resource-referanser), så de kan
## lagres/gjenopprettes direkte uten omforming.
func get_save_state() -> Dictionary:
	return {
		"completed_conditions": _completed_conditions.duplicate(),
		"completed_step_counts": _completed_step_counts.duplicate(),
		"completed_quest_ids": _completed_quest_ids.duplicate(),
	}


## Gjenoppretter tilstand fra get_save_state(). Trygt å kalle før scenens
## quests er (re-)registrert via register_quest() - se kommentaren der.
func apply_save_state(state: Dictionary) -> void:
	_completed_conditions = _as_flag_dict(state.get("completed_conditions"))
	_completed_quest_ids = _as_flag_dict(state.get("completed_quest_ids"))

	_completed_step_counts.clear()
	var raw_step_counts: Variant = state.get("completed_step_counts")
	if typeof(raw_step_counts) == TYPE_DICTIONARY:
		for quest_id: String in raw_step_counts:
			# int() feiler hardt (ukjent GDScript-runtime-feil, ikke en
			# håndterbar exception) på ikke-numeriske verdier - i motsetning
			# til resten av denne funksjonen skal ikke én korrupt/uventet
			# nøkkel i en ellers gyldig lagringsfil stanse hele
			# gjenopprettingen, kun hoppe over den ene oppføringen.
			var raw_value: Variant = raw_step_counts[quest_id]
			if typeof(raw_value) == TYPE_FLOAT or typeof(raw_value) == TYPE_INT:
				_completed_step_counts[quest_id] = int(raw_value)


## JSON-rundturen bevarer bool-verdier, men vi bryr oss uansett kun om
## nøklene (samme "has()"-sjekk-mønster som resten av klassen bruker) - så
## denne normaliserer bort avhengigheten av at verdien faktisk er `true`.
func _as_flag_dict(raw: Variant) -> Dictionary:
	var result: Dictionary = {}
	if typeof(raw) != TYPE_DICTIONARY:
		return result
	for key in raw:
		result[key] = true
	return result


## Fremgangen vises alltid i steg-rekkefølge, men spilleren kan i praksis
## utløse fullføringsbetingelser i en annen kronologisk rekkefølge enn
## steg-listen (jf. non-lineær oppdagelse-prinsippet i
## docs/concepts/quest_opportunities.md del 1 punkt 4 - ingenting i
## interact()-flyten gater rekkefølgen NPC-er/objekter kan oppsøkes i).
## Løkken under fanger opp alle steg som allerede har fått sin betingelse
## markert (uansett når), i stedet for å stoppe etter kun ett steg per kall
## - ellers kan et oppdrag låse seg fast hvis spilleren når det blokkerende
## steget sist.
func _advance_quest(quest: Quest) -> void:
	if _completed_quest_ids.has(quest.quest_id):
		return
	var done_count: int = _completed_step_counts.get(quest.quest_id, 0)
	while done_count < quest.steps.size():
		var next_step: QuestStep = quest.steps[done_count]
		if not _completed_conditions.has(next_step.completion_condition):
			break
		done_count += 1
		_completed_step_counts[quest.quest_id] = done_count
		quest_step_completed.emit(quest, done_count - 1)
		print("Oppdragssteg fullført (%s): %s" % [quest.title, next_step.description])

	if done_count >= quest.steps.size():
		_completed_quest_ids[quest.quest_id] = true
		quest_completed.emit(quest)
		print("Oppdrag fullført: %s" % quest.title)
