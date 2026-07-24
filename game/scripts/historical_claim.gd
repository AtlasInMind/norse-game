class_name HistoricalClaim
extends Resource

## Sikkerhetsgrad-kategoriene fra concepts/aha_moments.md og docs/research-standarden:
## fastslått/sannsynlig/omdiskutert/myte.
enum Certainty {
	ESTABLISHED,
	PROBABLE,
	DEBATED,
	MYTH,
}

## Delt visuelt språk for sikkerhetsgrad (farge+tekst, ikke bare farge, jf.
## tilgjengelighetsprinsippet i godot_mobile_technical_research.md punkt 13),
## brukt av både dialogue_ui.gd og codex_ui.gd slik at en påstand ser lik ut
## uansett hvor den vises.
const CERTAINTY_LABELS := {
	Certainty.ESTABLISHED: "Fastslått",
	Certainty.PROBABLE: "Sannsynlig",
	Certainty.DEBATED: "Omdiskutert",
	Certainty.MYTH: "Myte",
}

const CERTAINTY_COLORS := {
	Certainty.ESTABLISHED: Color(0.4, 0.75, 0.45),
	Certainty.PROBABLE: Color(0.8, 0.8, 0.35),
	Certainty.DEBATED: Color(0.85, 0.6, 0.25),
	Certainty.MYTH: Color(0.85, 0.35, 0.35),
}

## Selve påstandsteksten, slik den kan vises i dialog, oppdrag eller en "oppdagelses"-UI.
@export_multiline var claim_text: String = ""

## Tidslaget påstanden gjelder for.
@export var era: Era.Type = Era.Type.VIKING_AGE

## Stedsnavn/lokasjon påstanden er knyttet til (fri tekst, matcher lokasjonsscenens navn).
@export var place: String = ""

## Sikkerhetsgrad for påstanden.
@export var certainty: Certainty = Certainty.PROBABLE

## Kilde-ID-er som peker til rader i docs/research/source_register.md, f.eks. "SRC-CONT-014".
@export var source_ids: Array[String] = []
