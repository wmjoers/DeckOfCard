extends BaseState


class_name CheckGameOverState


func enter_state(_from_state: State) -> void:
	
	var locks_count: int = _count_locks()
	var keys_count: int = _count_keys()
	
	if locks_count == 0:
		print("You opened the safe")
		print("Game over! You got away with ", keys_count, " million dollars!")
	elif not _can_play():
		print("You cannot play")
		if not _can_discard():
			print("You cannot discard")
			print("Game over! You go to jail for ",locks_count," year(s).")
	else:
		print("You can do this")

	_exit_to(BaseState.State.PLAY_CARDS)

func _count_keys() -> int:
	var cnt: int = 0
	for card in game.hand:
		if card != null:
			cnt+=1
	cnt += game.deck.size()
	return cnt

func _count_locks() -> int:
	var cnt: int = 0
	for lock in game.locks:
		var card: Card = lock.get_card()
		if card != null:
			cnt+=1
	return cnt
	
func _can_discard() -> bool:
	return game.deck.size() > 0

func _can_play() -> bool:
	var key_values: Array[int] = []
	var lock_values: Array[int] = []
	
	for card in game.hand:
		if card == null:
			continue
		key_values.append(CardUtils.get_key_value(card))
	
	for lock in game.locks:
		var card: Card = lock.get_card()
		if card == null or card.is_flipped():
			continue
		lock_values.append(CardUtils.get_lock_value(card))
		
	print(key_values)
	print(lock_values)
		
	return CardUtils.can_get_any_target(key_values, lock_values)
	
