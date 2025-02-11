extends BaseState

class_name BuildLevelState

func enter_state(from_state: State) -> void:
	_anim_next_card(0)	
	
func _anim_next_card(lock_number: int) -> void:
	var card: Card = game.get_card_from_deck()
	if card:
		game.locks[lock_number].set_card(card)
		game.to_front(card)
		var pos: Vector2 = game.locks[lock_number].global_position
		var rot: float = CardUtils.get_random_tilt(0, game.CARD_DEFAULT_MAX_TILT)
		var tw: Tween = CardAnimations.move_and_rotate_card(_tree, card, pos, rot, 0.4, true)
		tw.tween_callback(func():
			if lock_number >= 10:
				CardAnimations.flip_card(_tree, card, 0.2)
			lock_number += 1
			if lock_number < game.locks.size():
				_anim_next_card(lock_number)
			else:
				_exit_to(State.DEAL_HAND)
		)
