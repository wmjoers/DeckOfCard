extends Area2D


class_name CardArea


signal card_entered(card: Card)
signal card_exited(card: Card)
signal card_dropped_inside(card: Card)


var _pile: Array[Card] = []


func _ready() -> void:
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)


func _on_area_entered(area: Area2D) -> void:
	var card: Card = _area_to_card(area)	
	if card != null:
		_pile.append(card)
		card.dropped.connect(_on_card_dropped)
		card_entered.emit(card)


func _on_area_exited(area: Area2D) -> void:
	var card: Card = _area_to_card(area)	
	if card != null:
		_pile.erase(card)
		card.dropped.disconnect(_on_card_dropped)
		card_exited.emit(card)


func _on_card_dropped(card: Card) -> void:
	if _pile.has(card):
		card_dropped_inside.emit(card)


func _area_to_card(area: Area2D) -> Card:
	var parent = area.get_parent()
	if parent and parent is Card:
		return (parent as Card)
	return null
	

func set_interaction_mask(layer: int, active: bool) -> void:
	set_collision_mask_value(layer, active) 
	
	
func has_interaction_mask(layer: int) -> bool:
	return get_collision_mask_value(layer)


func has_card(card: Card) -> bool:
	return _pile.has(card)
