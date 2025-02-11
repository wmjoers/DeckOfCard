extends BaseState


class_name CheckFreeLocksState

func enter_state(from_state: State) -> void:
	_check_free_locks()
	
func _check_free_locks() -> void:
		
	var delay: float = 0.0

	if not _has_ace():
		for lock in game.locks:
			if lock.is_flipped_and_free(game.locks):
				CardAnimations.flip_card(_tree, lock.get_card(), 0.2, delay)
				delay += 0.1
				
	_exit_to(BaseState.State.DEAL_HAND, delay)


func _has_ace() -> bool:
	for lock in game.locks:
		if (lock.is_accessible() and 
			lock.get_card().get_card_info().rank == CardInfo.Rank.ACE):
				return true
	return false
	
