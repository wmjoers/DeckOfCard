# V2
class_name CardCollection


const DEPTH_PER_CARD: int = 2


var _cards: Array[Card]
var _root_node: Node


func _init(node: Node) -> void:
	_root_node = node
	_load_cards()
	_root_node.child_entered_tree.connect(_on_child_entered_tree)	
	_root_node.child_exiting_tree.connect(_on_child_exiting_tree)	
	

func _load_cards() -> void:
	_cards.clear()
	for child in _root_node.get_children():
		if child is Card:
			_cards.append(child)	
	reset_cards_z_index()


func _on_child_entered_tree(node: Node) -> void:
	if node is Card:
		var card: Card = node as Card
		_cards.append(card)
		reset_cards_z_index()


func _on_child_exiting_tree(node: Node) -> void:
	if node is Card:
		var card: Card = node as Card
		_cards.erase(card)
		reset_cards_z_index()


func to_front(card: Card) -> void:
	_cards.erase(card)
	_cards.append(card)
	reset_cards_z_index()


func to_front_array(card_list: Array[Card]) -> void:
	for card in card_list:
		_cards.erase(card)
	_cards.append_array(card_list)
	reset_cards_z_index()



func reset_cards_z_index() -> void:
	var z: int = 0
	for card in _cards:
		z += DEPTH_PER_CARD
		card.z_index = z


func clear_all_card_states() -> void:
	for card in _cards:
		card.set_interaction_type_flags(0)
		card.set_reacts_to_interaction_type_flags(0)
	
