extends BaseState


class_name PlayCardsState


const HAND_INTERACTION_TYPE: int = 1
const DECK_INTERACTION_TYPE: int = 2
const LOCK_INTERACTION_TYPE: int = 3
const AREA_INTERACTION_TYPE: int = 4


var _dragger: CardDragger
var _picker: InteractionPicker

var _add_cards: Array[Card] = []
var _sub_cards: Array[Card] = []

var _key_value: int = -1
var _dirty_key_value: bool = false

func ready_state() -> void:
	_dragger = CardDragger.new()
	_picker = InteractionPicker.new(game.get_world_2d().direct_space_state)


func enter_state(_from_state: State) -> void:
	game.clear_all_area_states()
	game.clear_all_card_states()
	for card: Card in game.hand:
		if card:
			card.set_interaction_type(HAND_INTERACTION_TYPE, true)
	if game.deck.size() > 0:
		game.deck[-1].set_interaction_type(DECK_INTERACTION_TYPE, true)
	for lock in game.locks:
		if lock.is_accessible():
			lock.get_card().set_interaction_type(LOCK_INTERACTION_TYPE, true)
	game.addition_area.set_interaction_type(AREA_INTERACTION_TYPE, true)
	game.subtraction_area.set_interaction_type(AREA_INTERACTION_TYPE, true)

func exiting_state() -> void:
	game.clear_all_card_states()
	game.clear_all_area_states()


func physics_process(_delta: float) -> void:
	if _dragger.is_dragging():
		_dragger.drag_to(game.get_global_mouse_position())
		
	if Input.is_action_just_pressed("mouse_left"):
		var mouse_pos = game.get_global_mouse_position()
		_picker.pick_with_position(mouse_pos, BitUtils.bit_array_to_mask(
					[ HAND_INTERACTION_TYPE, DECK_INTERACTION_TYPE, LOCK_INTERACTION_TYPE ]
				))
		var card: Card = _picker.get_top_card()
		if card:		
			if card.get_interaction_type(HAND_INTERACTION_TYPE):					
				_start_dragging_card(card, mouse_pos)
			elif card.get_interaction_type(DECK_INTERACTION_TYPE):					
				_exit_to(State.DISCARD_HAND)
			elif card.get_interaction_type(LOCK_INTERACTION_TYPE):	
				if(_check_lock(card)):
					_exit_to(BaseState.State.CHECK_FREE_LOCKS, 1)
	elif Input.is_action_just_released("mouse_left"):
		_stop_dragging_card_if_any()


func _start_dragging_card(card: Card, mouse_pos: Vector2) -> void:
	if card in _add_cards or card in _sub_cards:
		_dirty_key_value = true
		_add_cards.erase(card)
		_sub_cards.erase(card)
		_place_cards_around_point(_add_cards, game.addition_area.global_position)
		_place_cards_around_point(_sub_cards, game.subtraction_area.global_position)
	game.to_front(card)
	_dragger.grab(card, mouse_pos)	


func _stop_dragging_card_if_any() -> void:
	if not _dragger.is_dragging():
		return
		
	var card: Card = _dragger.drop()
	
	var mouse_pos = game.get_global_mouse_position()
	
	_picker.pick_with_position(mouse_pos, BitUtils.bit_to_mask(AREA_INTERACTION_TYPE))
	
	# Check if dropped in an area
	var area: InteractionArea = _picker.get_top_area()
	if area:		
		if area == game.addition_area:
			_add_cards.append(card)
			_update_calculations()
			_place_cards_around_point(_add_cards, game.addition_area.global_position)
		elif area == game.subtraction_area:
			_sub_cards.append(card)
			_update_calculations()
			_place_cards_around_point(_sub_cards, game.subtraction_area.global_position)
		else:
			_return_to_hand(card)
		return			
		
	# Check if dropped close to a card in hand	
	if _put_in_closest_hand_pos(card):
		return
		
	# Default is move tha card back to the hand position
	_return_to_hand(card)


func _place_cards_around_point(cards: Array[Card], center_point: Vector2) -> void:
	game.to_front_array(cards)
	var points: Array[Vector2] = CardUtils.spread_points_horizontal(cards.size(), center_point, 80.0, 20.0)

	for i in range(cards.size()):
		CardAnimations.move_card(_tree, cards[i], points[i], 0.2, false)

func _update_calculations() -> void:
	_key_value = 0
	for card in _add_cards:
		_key_value += CardUtils.get_key_value(card)
	for card in _sub_cards:
		_key_value -= CardUtils.get_key_value(card)
		
	if _add_cards.size() == 0 and _sub_cards.size() == 0:
		_key_value = -1
	
	for lock in game.locks:
		if lock.is_accessible():
			var lock_value: int = CardUtils.get_lock_value(lock.get_card())
			if lock_value == _key_value:
				CardAnimations.wiggle_card(_tree, lock.get_card(), 3)
	
	_dirty_key_value = false;	
	

func _check_lock(card: Card) -> bool:
	var lock: Lock = null
	for l: Lock in game.locks:
		if l.get_card() == card:
			lock = l
			break
	if lock and CardUtils.get_lock_value(card) == _key_value:
		var disc: Array[Card] = []
		lock.set_card(null)
		disc.append(card)
		for c in _add_cards:
			_remove_from_hand(c)
			disc.append(c)
		for c in _sub_cards:
			_remove_from_hand(c)
			disc.append(c)
		_add_cards.clear()	
		_sub_cards.clear()
		game.to_front_array(disc)
		for c in disc:
			game.discard_card(c)
		return true
	else:
		if not card.has_tweens():
			CardAnimations.shake_card(_tree, card, 3)
		else:
			print("Skipping shake...")
		return false

func _remove_from_hand(card: Card) -> void:
	var index = game.hand.find(card)
	if index != -1:
		game.hand[index] = null


func _put_in_closest_hand_pos(card: Card) -> bool:
	
	var nearest_index: int = -1
	var nearest_dist: float = 999.0
	
	for i in range(game.hand_pos.size()):
		var dist: float = game.hand_pos[i].distance_to(card.global_position)
		if dist < 20.0 and dist < nearest_dist:
			nearest_dist = dist
			nearest_index = i
	
	if nearest_index == -1:
		return false

	var hand_index: int = game.hand.find(card)

	var replace_card = game.hand[nearest_index]
		
	game.hand[hand_index] = null
	game.hand[nearest_index] = card
	_return_to_hand(card)
	
	if replace_card != null:
		game.to_front(replace_card)
		game.to_front(card)
		game.hand[hand_index] = replace_card	
		_return_to_hand(replace_card)
	
	return true;
	
func _return_to_hand(card: Card) -> void:
	var hand_index: int = game.hand.find(card)
	if hand_index >= 0:
		var pos = game.hand_pos[hand_index]
		var rot = CardUtils.get_random_tilt(0, game.CARD_DEFAULT_MAX_TILT)
		CardAnimations.move_and_rotate_card(_tree, card, pos, rot, 0.2, true)
