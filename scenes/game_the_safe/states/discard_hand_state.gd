extends BaseState


class_name DiscardHandState

func enter_state(from_state: State) -> void:
	_discard_hand()
	
func _discard_hand() -> void:
	for i in range(game.hand.size()):
		var card: Card = game.hand[i]
		if card == null:
			continue
		game.hand[i] = null
		game.discard_card(card)
	_exit_to(BaseState.State.DEAL_HAND, 1)
