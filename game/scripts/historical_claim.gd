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
