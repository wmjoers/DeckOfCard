extends Node2D


const DECK: DeckInfo = preload("res://resources/deck_info/standard_deck_info.tres")
const CARD = preload("res://scenes/card/card.tscn")


@onready var discard_pile_area: CardArea = $DiscardPile
@onready var card_hand_area: CardArea = $CardHand
@onready var deck: Deck = $Deck


const DRAGABLE_LAYER: int = 1
const THROWABLE_LAYER: int = 2
const PICKABLE_LAYER: int = 3


var _card_z_sorter: CardZSorter
var _card_dragger: CardDragger
var _card_picker: CardPicker
var _hand: Array[Card] = []

var _rank_values = {
	CardInfo.Rank.ACE: 14,
	CardInfo.Rank.TWO: 2,
	CardInfo.Rank.THREE: 3,
	CardInfo.Rank.FOUR: 4,
	CardInfo.Rank.FIVE: 5,
	CardInfo.Rank.SIX: 6,
	CardInfo.Rank.SEVEN: 7,
	CardInfo.Rank.EIGHT: 8,
	CardInfo.Rank.NINE: 9,
	CardInfo.Rank.TEN: 10,
	CardInfo.Rank.JACK: 11,
	CardInfo.Rank.QUEEN: 12,
	CardInfo.Rank.KING: 13,
}

var _suit_values = {
	CardInfo.Suit.HEARTS: 4,
	CardInfo.Suit.DIAMONDS: 3,
	CardInfo.Suit.CLUBS: 2,
	CardInfo.Suit.SPADES: 1,
}

func _ready() -> void:
	_card_dragger = CardDragger.new()
	_card_picker = CardPicker.new(get_world_2d().direct_space_state)
	_card_z_sorter = CardZSorter.new(self)
	
	deck.card_interaction_layer = 0
	deck.top_card_interaction_layer =  BitUtils.bit_to_mask(PICKABLE_LAYER)
	deck.card_z_sorter = _card_z_sorter
	
	discard_pile_area.set_interaction_mask(THROWABLE_LAYER, true)
	discard_pile_area.card_dropped_inside.connect(_throw_card_on_pile)
	
	card_hand_area.card_dropped_inside.connect(_put_in_hand)
	
	DECK.card_info_list.shuffle()
	for i in range(0, DECK.card_info_list.size()):
		var card = CARD.instantiate()
		add_child(card)
		card.flipp()
		card.rotation = CardTweens.randomize_rotation(0, deg_to_rad(4))
		card.set_card_info(DECK.card_info_list.pop_back())
		deck.cards.append(card)
	deck.update_cards()
	
	child_entered_tree.connect(_on_child_entered_tree)
	child_exiting_tree.connect(_on_child_exiting_tree)


func _process(_delta: float) -> void:
	if _card_dragger.is_dragging():
		_card_dragger.drag_to(get_global_mouse_position())


func _input(event: InputEvent) -> void:
	
	var mouse_pos = get_global_mouse_position()
	
	if event is InputEventKey:
		if event.keycode == KEY_SPACE:
			if event.pressed:
				pass
				#_add_new_card(mouse_pos)
		
	elif event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				var card: Card = _card_picker._pick_top_card(mouse_pos, BitUtils.bit_array_to_mask([PICKABLE_LAYER, DRAGABLE_LAYER]))
				if card:
					if card in deck.cards:
						deck.pop_card()
						card.rotation = CardTweens.randomize_rotation(0, deg_to_rad(1))
						card.flipp()
						card.clear_interaction_layers()
						card.set_interaction_layer_bit(DRAGABLE_LAYER, true)
					_card_z_sorter.to_front(card)
					_card_dragger.grab(card, mouse_pos)
			else:
				_card_dragger.drop()
		elif event.button_index == MOUSE_BUTTON_MIDDLE:
			if event.pressed:				
				var card: Card = _card_picker._pick_top_card(mouse_pos, BitUtils.bit_to_mask(DRAGABLE_LAYER))
				if card:
					_card_z_sorter.to_front(card)
					card.flipp_animated()
		elif event.button_index == MOUSE_BUTTON_MASK_RIGHT:
			if event.pressed:				
				var card: Card = _card_picker._pick_top_card(mouse_pos, BitUtils.bit_to_mask(DRAGABLE_LAYER))
				if card:
					_card_z_sorter.to_front(card)
					_throw_card_on_pile(card)


func _throw_card_on_pile(card: Card) -> void:

	if not card.is_flipped():
		card.flipp_animated()

	card.set_interaction_layer_bit(DRAGABLE_LAYER, false)

	if discard_pile_area.has_card(card):
		var pos: Vector2 = CardTweens.randomize_posistion(discard_pile_area.global_position, 10.0)
		var rot: float = CardTweens.randomize_rotation(card.rotation, deg_to_rad(10))
		CardTweens.move_card_to_pos(get_tree(), card, pos, rot, 0.1, false)
	else:
		var pos: Vector2 = CardTweens.randomize_posistion(discard_pile_area.global_position, 10.0)
		var rot: float = CardTweens.randomize_rotation(card.rotation, deg_to_rad(10))
		CardTweens.move_card_to_pos(get_tree(), card, pos, rot, 0.4, false)


func _put_in_hand(card: Card) -> void:
	card.set_interaction_layer_bit(DRAGABLE_LAYER, false)
	_hand.append(card)
	_arrange_hand()
		


func _arrange_hand() -> void:
	
	if _hand.size() > 0:
		_hand.sort_custom(func(a: Card , b: Card): return _get_sort_value(a) > _get_sort_value(b))
	
	_card_z_sorter.to_front_array(_hand)	
	
	var spacing = min(30.0, 400.0/float(_hand.size()))

	var pos = card_hand_area.global_position
	pos.x -= (float(_hand.size() - 1) * spacing) / 2.0
	
	for c in _hand:
		var rot =  CardTweens.randomize_rotation(0, deg_to_rad(1))
		CardTweens.move_card_to_pos(get_tree(),c,pos,rot,0.2,false)		
		#c.global_position = pos
		pos.x = pos.x + spacing


func _get_sort_value(card: Card):
	var ci = card.get_card_info()
	if ci == null or ci.rank not in _rank_values or ci.suit not in _suit_values:
		return -1 
	return _rank_values[ci.rank] * 4 - _suit_values[ci.suit]


func _on_child_entered_tree(node: Node) -> void:
	if node is Card:
		_card_z_sorter.add(node)
		


func _on_child_exiting_tree(node: Node) -> void:
	if node is Card:
		_card_z_sorter.remove(node)
