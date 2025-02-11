extends Marker2D

class_name Lock

@export var dependencies: Array[int] = []

var _card: Card

func set_card(card: Card) -> void:
	_card = card
	
func get_card() -> Card:
	return _card

func is_removed() -> bool:
	return _card == null

func is_accessible() -> bool:
	return (_card and not _card.is_flipped())

func is_flipped_and_free(locks: Array[Lock]) -> bool:
	if _card and _card.is_flipped():
		return is_free(locks)
	return false

func is_free(locks: Array[Lock]) -> bool:
	for i in dependencies:
		if not locks[i].is_removed():
			return false
	return true
