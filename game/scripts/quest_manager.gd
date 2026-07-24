extends Node

## Globalt oppdragssystem (autoload "QuestManager").
## Sporer aktive oppdrag og hvilke fullføringsbetingelser (completion_condition
## fra QuestStep/DialogueNode) som er oppfylt denne økten. Steg fullføres i
## rekkefølge, jf. kommentaren i quest.gd om at steps er ordnet. Ikke
## lagringspersistert ennå — oppdragsfremgang varer kun for gjeldende økt.

signal quest_step_completed(quest: Quest, step_index: int)
signal quest_completed(quest: Quest)

var _active_quests: Array[Quest] = []
var _completed_conditions: Dictionary = {}
var _completed_step_counts: Dictionary = {}
var _completed_quest_ids: Dictionary = {}


func register_quest(quest: Quest) -> void:
	if quest == null or _active_quests.has(quest):
		return
	_active_quests.append(quest)
	_completed_step_counts[quest.quest_id] = 0


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


func completed_step_count(quest_id: String) -> int:
	return _completed_step_counts.get(quest_id, 0)


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
