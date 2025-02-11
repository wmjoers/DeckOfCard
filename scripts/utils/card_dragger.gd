# V2
class_name CardDragger


var _card: Card = null
var _anchor: Vector2 = Vector2.ZERO


func grab(card: Card, pos: Vector2) -> void:
	if _card and _card != card:
		drop()
	_card = card
	_anchor = card.global_position - pos
	_card.grab()


func drag_to(pos: Vector2) -> void:
	if _card:
		_card.global_position = pos + _anchor


func drop() -> Card:
	var c = _card
	if _card:
		_card.drop()
		_card = null
	return c

func is_dragging() -> bool:
	return _card != null


func get_card() -> Card:
	return _card
	
