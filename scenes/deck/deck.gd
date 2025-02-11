extends Node2D

class_name Deck


var cards: Array[Card] = []
var top_card_interaction_layer: int = 0
var card_interaction_layer: int = 0
var card_z_sorter: CardZSorter = null


func update_cards() -> void:
	if card_z_sorter:
		card_z_sorter.to_front_array(cards)
	
	var i: float = 0.0
	for card in cards:
		cards[-1].set_interaction_layer(card_interaction_layer)
		card.global_position = global_position - (Vector2.ONE * i / 8.0)
		i += 1.0
		card.rotation = CardTweens.randomize_rotation(0, deg_to_rad(4))
	
	if cards.size() > 0:
		cards[-1].set_interaction_layer(top_card_interaction_layer)


func pop_card() -> Card:
	var c = cards.pop_back() 
	
	if cards.size() > 0:
		cards[-1].set_interaction_layer(top_card_interaction_layer)

	return c
