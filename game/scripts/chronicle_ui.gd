extends CanvasLayer

## Global "krønike"-UI (autoload "ChronicleUI") for oppdagede historiske
## faktapåstander, jf. quest_opportunities.md del 1 punkt 5 (valgfri,
## spillerstyrt fordypning i eget tempo). Bygget i kode etter samme
## plassholderaktige mønster som dialogue_ui.gd og quest_log_ui.gd, jf.
## CLAUDE.md om placeholder-grafikk fram til M3.
##
## Omdøpt fra "Kodex"/"CodexUI" i issue #23: navnet leste encyklopedisk/
## kilde-aktig, som ikke passer den nye, mer atmosfæriske retningen (jf.
## CLAUDE.md "Historical grounding is a core value - held internally, not
## displayed to the player" og docs/DECISIONS.md sin 2026-07-24
## "Creative reboot"-oppføring). Selve mekanikken (en logg over ting
## spilleren har møtt, gruppert per sted) er uendret - kun presentasjonen
## og navnet er nytt.
##
## Panelet er satt til nesten full skjermhøyde (samme løsning som
## quest_log_ui.gd) siden Control.clip_contents ikke klipper synlig
## overskytende innhold i denne gl_compatibility-web-eksporten.

var _toggle_button: Button
var _barrier: Control
var _entries_box: VBoxContainer


func _ready() -> void:
	layer = 80

	_toggle_button = Button.new()
	_toggle_button.text = "Chronicle"
	_toggle_button.custom_minimum_size = Vector2(0, 44)
	_toggle_button.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	_toggle_button.grow_horizontal = Control.GROW_DIRECTION_BEGIN
	_toggle_button.offset_left = -240
	_toggle_button.offset_right = -136
	_toggle_button.offset_top = 16
	_toggle_button.offset_bottom = 60
	_toggle_button.pressed.connect(toggle_chronicle)
	add_child(_toggle_button)

	_barrier = Control.new()
	_barrier.set_anchors_preset(Control.PRESET_FULL_RECT)
	_barrier.mouse_filter = Control.MOUSE_FILTER_STOP
	_barrier.visible = false
	add_child(_barrier)

	var panel := PanelContainer.new()
	panel.set_anchors_preset(Control.PRESET_FULL_RECT)
	panel.offset_left = 16
	panel.offset_right = -16
	panel.offset_top = 16
	panel.offset_bottom = -16
	_barrier.add_child(panel)

	var outer_layout := VBoxContainer.new()
	panel.add_child(outer_layout)

	var header := Label.new()
	header.text = "Chronicle"
	outer_layout.add_child(header)

	var close_button := Button.new()
	close_button.text = "Close"
	close_button.custom_minimum_size = Vector2(0, 44)
	close_button.pressed.connect(close_chronicle)
	outer_layout.add_child(close_button)

	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	outer_layout.add_child(scroll)

	_entries_box = VBoxContainer.new()
	_entries_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(_entries_box)

	DiscoveryLog.claim_discovered.connect(_on_claim_discovered)


func _unhandled_input(event: InputEvent) -> void:
	if not _toggle_button.visible or DialogueUI.is_open():
		return
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_K:
		toggle_chronicle()


func toggle_chronicle() -> void:
	if _barrier.visible:
		close_chronicle()
	else:
		open_chronicle()


func open_chronicle() -> void:
	# Unngår flere fullskjerms-paneler oppå hverandre samtidig.
	QuestLogUI.close_log()
	PauseMenuUI.close_menu()
	_refresh()
	_barrier.visible = true


func close_chronicle() -> void:
	_barrier.visible = false


func is_open() -> bool:
	return _barrier.visible


## Brukes av main_menu.gd: "Chronicle"-knappen gir ingen mening før et spill
## faktisk er i gang (jf. issue #21 - samme prinsipp som
## PauseMenuUI.set_toggle_visible() ble innført for i issue #20).
func set_toggle_visible(visible_now: bool) -> void:
	_toggle_button.visible = visible_now
	if not visible_now:
		close_chronicle()


func _on_claim_discovered(_claim: HistoricalClaim) -> void:
	if _barrier.visible:
		_refresh()


func _refresh() -> void:
	for child in _entries_box.get_children():
		child.queue_free()

	var claims := DiscoveryLog.get_discovered_claims()
	if claims.is_empty():
		var empty_label := Label.new()
		empty_label.text = "Nothing recorded yet."
		_entries_box.add_child(empty_label)
		return

	# Grupperer per sted, i den rekkefølgen stedene først ble oppdaget - dette
	# følger spillerens faktiske utforskingsrekkefølge, i stedet for en
	# alfabetisk sortering som ikke ville gjort det.
	var places_seen: Array[String] = []
	var claims_by_place: Dictionary = {}
	for claim in claims:
		if not claims_by_place.has(claim.place):
			places_seen.append(claim.place)
			claims_by_place[claim.place] = []
		claims_by_place[claim.place].append(claim)

	for place in places_seen:
		var place_label := Label.new()
		place_label.text = place
		_entries_box.add_child(place_label)
		for claim in claims_by_place[place]:
			_entries_box.add_child(_build_claim_entry(claim))


func _build_claim_entry(claim: HistoricalClaim) -> Label:
	var label := Label.new()
	label.text = claim.claim_text
	label.autowrap_mode = TextServer.AUTOWRAP_WORD
	return label
