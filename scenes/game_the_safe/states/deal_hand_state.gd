extends BaseState

class_name DealHandState

func enter_state(from_state: State) -> void:
	_anim_next_card(0)

func _anim_next_card(card_number: int) -> void:
	
	while card_number < 5 and game.hand[card_number] != null:
		card_number+=1
	
	if card_number >= 5 or game.deck.size() == 0:
		var timer: SceneTreeTimer = _tree.create_timer(0.4)
		timer.timeout.connect(_reveal_cards)
		return
	
	var card: Card = game.get_card_from_deck()
	if card:
		game.hand[card_number] = card
		game.to_front(card)
		var pos: Vector2 = game.hand_pos[card_number]
		var rot: float = CardUtils.get_random_tilt(0, game.CARD_DEFAULT_MAX_TILT)
		var tw: Tween = CardAnimations.move_and_rotate_card(_tree, card, pos, rot, 0.2, true)
		tw.tween_callback(func():
			card_number += 1
			_anim_next_card(card_number)
		)
		
func _reveal_cards() -> void:
	var delay: float = 0.0
	for i in range(5):
		if game.hand[i] == null or not game.hand[i].is_flipped():
			continue
		CardAnimations.flip_card(_tree, game.hand[i], 0.2, delay)
		delay += 0.05
	_exit_to(State.CHECK_ACES, delay)
	
