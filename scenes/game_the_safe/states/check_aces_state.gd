extends BaseState


class_name CheckAcesState

const NO_ACES: int = 1
const ONLY_ACES: int = 2
const ACES_AND_OTHERS: int = 3

func enter_state(from_state: State) -> void:
	var result: int = _check_aces()

	if result == NO_ACES:
		_exit_to(BaseState.State.PLAY_CARDS)
		return

	var timer = _tree.create_timer(0.4)
	timer.timeout.connect(_handle_aces)
	
func _handle_aces() -> void:
				
	_shake_all_aces()
		
	if ACES_AND_OTHERS:
		_hide_all_not_aces()

	_exit_to(BaseState.State.PLAY_CARDS, 1.0)

func _shake_all_aces() -> void:
	for lock in game.locks:
		if lock.is_accessible():
			if lock.get_card().get_card_info().rank == CardInfo.Rank.ACE:
				CardAnimations.shake_card(_tree, lock.get_card(), 3)

func _hide_all_not_aces() -> void:
	var delay: float = 0.4

	for lock in game.locks:
		if lock.is_accessible():
			if lock.get_card().get_card_info().rank != CardInfo.Rank.ACE:
				CardAnimations.flip_card(_tree, lock.get_card(), 0.2, delay)
				delay += 0.1
				
func _check_aces() -> int:
	
	var aces: int = 0
	var others: int = 0

	for lock in game.locks:
		if lock.is_accessible():
			if lock.get_card().get_card_info().rank == CardInfo.Rank.ACE:
				aces+=1
			else:
				others+=1
				
	if aces > 0:
		if others == 0:
			return ONLY_ACES
		else:
			return ACES_AND_OTHERS
	return NO_ACES
	
