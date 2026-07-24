class_name Era
extends RefCounted

## Delt tidslags-taksonomi brukt av HistoricalClaim, DialogueNode og Quest
## (og senere av scene-/navigasjonslaget, jf. docs/research/dual_timeline_design.md punkt 2-5).
enum Type {
	MODERN,
	VIKING_AGE,
}
