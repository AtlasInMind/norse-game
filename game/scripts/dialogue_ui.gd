extends CanvasLayer

## Globalt dialog-UI (autoload "DialogueUI"), bygget i kode etter samme
## mønster som EraTransitionController siden UI-et er bevisst
## plassholderaktig fram til ekte UI-design kommer (jf. CLAUDE.md om
## placeholder-grafikk fram til M3). Viser sikkerhetsgrad ved siden av enhver
## historisk faktapåstand, jf. designprinsipp 6 i
## docs/concepts/quest_opportunities.md del 1.

const CERTAINTY_LABELS := {
	HistoricalClaim.Certainty.ESTABLISHED: "Fastslått",
	HistoricalClaim.Certainty.PROBABLE: "Sannsynlig",
	HistoricalClaim.Certainty.DEBATED: "Omdiskutert",
	HistoricalClaim.Certainty.MYTH: "Myte",
}

const CERTAINTY_COLORS := {
	HistoricalClaim.Certainty.ESTABLISHED: Color(0.4, 0.75, 0.45),
	HistoricalClaim.Certainty.PROBABLE: Color(0.8, 0.8, 0.35),
	HistoricalClaim.Certainty.DEBATED: Color(0.85, 0.6, 0.25),
	HistoricalClaim.Certainty.MYTH: Color(0.85, 0.35, 0.35),
}

var _barrier: Control
var _speaker_label: Label
var _text_label: Label
var _claims_box: VBoxContainer
var _choices_box: VBoxContainer


func _ready() -> void:
	layer = 90

	_barrier = Control.new()
	_barrier.set_anchors_preset(Control.PRESET_FULL_RECT)
	_barrier.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(_barrier)

	var panel := PanelContainer.new()
	panel.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	panel.offset_left = 16
	panel.offset_right = -16
	panel.offset_top = -220
	panel.offset_bottom = -16
	_barrier.add_child(panel)

	var outer_layout := VBoxContainer.new()
	panel.add_child(outer_layout)

	_speaker_label = Label.new()
	outer_layout.add_child(_speaker_label)

	# En del noder (f.eks. valgnoder med kildekritikk-spørsmål, se
	# dn_torolv_sagaene.tres) har mer innhold - lengre tekst, flere
	# HistoricalClaim-merkelapper og/eller flere valgknapper - enn det som
	# alltid får plass i panelets faste høyde. Uten scroll ville et
	# overskytende valg rett og slett bli usynlig og umulig å klikke, noe som
	# kan låse spilleren fast midt i en samtale. ScrollContainer garanterer at
	# alt innhold (og dermed alle knapper) forblir nåbart.
	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	outer_layout.add_child(scroll)

	var scrolled_layout := VBoxContainer.new()
	scrolled_layout.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(scrolled_layout)

	_text_label = Label.new()
	_text_label.autowrap_mode = TextServer.AUTOWRAP_WORD
	scrolled_layout.add_child(_text_label)

	_claims_box = VBoxContainer.new()
	scrolled_layout.add_child(_claims_box)

	_choices_box = VBoxContainer.new()
	scrolled_layout.add_child(_choices_box)

	_barrier.visible = false


func start_dialogue(node: DialogueNode) -> void:
	_barrier.visible = true
	_speaker_label.text = node.speaker
	_text_label.text = node.text

	for child in _claims_box.get_children():
		child.queue_free()
	for claim in node.related_claims:
		_claims_box.add_child(_build_claim_label(claim))

	if not node.completion_condition.is_empty():
		QuestManager.mark_condition(node.completion_condition)

	for child in _choices_box.get_children():
		child.queue_free()
	if node.choices.is_empty():
		var close_button := Button.new()
		close_button.text = "Lukk"
		close_button.pressed.connect(close_dialogue)
		_choices_box.add_child(close_button)
	else:
		for choice in node.choices:
			var button := Button.new()
			button.text = choice.choice_text
			button.pressed.connect(_on_choice_pressed.bind(choice))
			_choices_box.add_child(button)


func close_dialogue() -> void:
	_barrier.visible = false


func is_open() -> bool:
	return _barrier.visible


func _on_choice_pressed(choice: DialogueChoice) -> void:
	if choice.next_node:
		start_dialogue(choice.next_node)
	else:
		close_dialogue()


func _build_claim_label(claim: HistoricalClaim) -> Label:
	var label := Label.new()
	var certainty_text: String = CERTAINTY_LABELS.get(claim.certainty, "?")
	var sources_text: String = ", ".join(claim.source_ids)
	label.text = "[%s] %s (%s)" % [certainty_text, claim.claim_text, sources_text]
	label.autowrap_mode = TextServer.AUTOWRAP_WORD
	label.modulate = CERTAINTY_COLORS.get(claim.certainty, Color.WHITE)
	return label
