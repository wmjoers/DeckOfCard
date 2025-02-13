@tool
extends EditorScript

func can_sum_target_iterative(numbers: Array[int], target: int) -> bool:
	var queue = {0: true}  # Använder dictionary för att simulera en set
	
	for num in numbers:
		var next_queue = queue.duplicate()  # Behåll tidigare möjliga summor
		
		for val in queue.keys():
			next_queue[val + num] = true
			next_queue[val - num] = true
		
		queue = next_queue  # Uppdatera queue
	
	return target in queue


func _run() -> void:
	print(CardUtils.can_get_any_target([13, 13, 7, 12, 13], [4, 10, 3]))

func _run_() -> void:
	# Varje testfall har nu 5 tal mellan 1 och 13
	assert(can_sum_target_iterative([3, 7, 2, 5, 11], 8) == true)  # 3 + 7 - 2
	assert(can_sum_target_iterative([3, 7, 2, 5, 11], 5) == true)  # 3 + 2 eller 7 - 2
	assert(can_sum_target_iterative([3, 7, 2, 5, 11], 2) == true)  # Bara 2
	assert(can_sum_target_iterative([3, 7, 2, 5, 11], 12) == true)  # 7 + 5
	assert(can_sum_target_iterative([3, 7, 2, 5, 11], 11) == true)  # Finns direkt
	assert(can_sum_target_iterative([3, 7, 2, 5, 11], 19) == true)  # 7 + 5 + 3 + 2 + 2
	assert(can_sum_target_iterative([3, 7, 2, 5, 11], 0) == true)  # Alltid möjligt att göra 0
	assert(can_sum_target_iterative([3, 7, 2, 5, 11], 30) == false)  # Inte möjligt

	# Testfall med en annan uppsättning tal
	assert(can_sum_target_iterative([9, 8, 1, 6, 4], 2) == true)  # 9 - 8 + 1
	assert(can_sum_target_iterative([9, 8, 1, 6, 4], 5) == true)  # 9 - 4
	assert(can_sum_target_iterative([9, 8, 1, 6, 4], 10) == true)  # 9 + 1
	assert(can_sum_target_iterative([9, 8, 1, 6, 4], 29) == false)  # För stort

	# Testfall med udda siffror
	assert(can_sum_target_iterative([1, 3, 5, 7, 9], 14) == true)  # 1 + 3 + 5 + 5
	assert(can_sum_target_iterative([1, 3, 5, 7, 9], 16) == true)  # 9 + 7
	assert(can_sum_target_iterative([1, 3, 5, 7, 9], 2) == true)  
	assert(can_sum_target_iterative([3, 3, 5, 7, 9], 23) == false)  

	# Testfall med jämna siffror
	assert(can_sum_target_iterative([2, 4, 6, 8, 10], 10) == true)  # Finns direkt
	assert(can_sum_target_iterative([2, 4, 6, 8, 10], 18) == true)  # 10 + 8
	assert(can_sum_target_iterative([2, 4, 6, 8, 10], 1) == false)  # Ej möjligt med bara jämna tal

	print("Alla testfall passerade!")  # Endast om inga asserts failar
	
