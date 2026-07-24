extends CanvasLayer

## Globalt dialog-UI (autoload "DialogueUI"), bygget i kode etter samme
## mønster som EraTransitionController siden UI-et er bevisst
## plassholderaktig fram til ekte UI-design kommer (jf. CLAUDE.md om
## placeholder-grafikk fram til M3). Historiske faktapåstander vises som
## vanlig prosa uten sikkerhetsgrad/kilde-ID-er (fjernet i issue #23, jf.
## CLAUDE.md "Historical grounding is a core value - held internally, not
## displayed to the player").

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
	# Høyden er satt romslig nok til å romme det lengste reelle
	# innholdstilfellet (tekst + 1 HistoricalClaim + 2 valgknapper à 44pt)
	# uten at det overskytende innholdet ScrollContainer skulle håndtert,
	# klippes usynlig utover panelet og ned i spillverdenen bak - bekreftet
	# under testing av dette issuet at Control.clip_contents ikke klipper
	# synlig i denne gl_compatibility-web-eksporten (samme funn som i
	# quest_log_ui.gd/chronicle_ui.gd).
	panel.offset_top = -280
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
		DiscoveryLog.register_claim(claim)

	if not node.completion_condition.is_empty():
		QuestManager.mark_condition(node.completion_condition)

	for child in _choices_box.get_children():
		child.queue_free()
	if node.choices.is_empty():
		var close_button := Button.new()
		close_button.text = "Close"
		# Minst ca. 44x44 punkter, jf. anbefalingen for berøringsvennlige
		# knapper i godot_mobile_technical_research.md punkt 7.
		close_button.custom_minimum_size = Vector2(0, 44)
		close_button.pressed.connect(close_dialogue)
		_choices_box.add_child(close_button)
	else:
		for choice in node.choices:
			var button := Button.new()
			button.text = choice.choice_text
			button.custom_minimum_size = Vector2(0, 44)
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
	label.text = claim.claim_text
	label.autowrap_mode = TextServer.AUTOWRAP_WORD
	return label
