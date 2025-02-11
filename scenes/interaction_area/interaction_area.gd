extends Area2D


class_name InteractionArea


signal card_entered(card: Card)
signal card_exited(card: Card)
signal card_dropped_inside(card: Card)


var _cards: Array[Card] = []


func _ready() -> void:
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)


func _on_area_entered(area: Area2D) -> void:
	var card: Card = _area_to_card(area)	
	if card:
		_cards.append(card)
		card.dropped.connect(_on_card_dropped)
		card_entered.emit(card)
		print("Area enterd: ", _cards.size())


func _on_area_exited(area: Area2D) -> void:
	var card: Card = _area_to_card(area)	
	if card:
		_cards.erase(card)
		card.dropped.disconnect(_on_card_dropped)
		card_exited.emit(card)
		print("Area exited: ", _cards.size())


func _on_card_dropped(card: Card) -> void:
	if _cards.has(card):
		print("Dropepd inside")
		card_dropped_inside.emit(card)


func has_card(card: Card) -> bool:
	return _cards.has(card)


func get_cards() -> Array[Card]:
	return Array(_cards)


func set_interaction_type(interaction_type: int, active: bool) -> void:
	set_collision_layer_value(interaction_type, active) 
	

func get_interaction_type(interaction_type: int) -> bool:
	return get_collision_layer_value(interaction_type)


func set_reacts_to_interaction_type(interaction_type: int, active: bool) -> void:
	set_collision_mask_value(interaction_type, active) 
	
	
func get_reacts_to_interaction_type(interaction_type: int) -> bool:
	return get_collision_mask_value(interaction_type)


func set_interaction_type_flags(interaction_type_flags: int) -> void:
	collision_layer = interaction_type_flags
	

func get_interaction_type_flags() -> int:
	return collision_layer


func set_reacts_to_interaction_type_flags(interaction_type_flags: int) -> void:
	collision_mask = interaction_type_flags
	

func get_reacts_to_interaction_type_flags() -> int:
	return collision_mask
	

func _area_to_card(area: Area2D) -> Card:
	var parent = area.get_parent()
	if parent and parent is Card:
		return (parent as Card)
	return null
