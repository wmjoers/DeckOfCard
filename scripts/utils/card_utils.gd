# V2
class_name CardUtils


static func get_random_position(from_position: Vector2, max_distance: float) -> Vector2:
	var distance = randf_range(0, max_distance)
	var angle = randf_range(0, TAU)
	var offset = Vector2.from_angle(angle) * distance
	return  from_position + offset
	

static func get_random_tilt(from_rotation: float, max_tilt: float) -> float:
	return from_rotation + randf_range(-max_tilt, max_tilt)


static func set_last_card_interaction_type(cards: Array[Card], interaction_type_flags: int, default_interaction_type_flags: int = 0) -> void:
	for card in cards:
		card.set_interaction_type_flags(default_interaction_type_flags)
	if cards.size() > 0:
		cards[-1].set_interaction_type_flags(interaction_type_flags)

static func sort_card_array_on_x(cards: Array[Card]) -> void:
	if cards.size() == 0:
		return
	cards.sort_custom(func(a: Card , b: Card): return a.global_position.x < b.global_position.x)

static func spread_points_horizontal(number_of_points: int, center_point: Vector2, max_total_width: float, max_point_spacing: float) -> Array:
	var points: Array[Vector2] = []
	number_of_points = max(1, number_of_points)
	var ideal_spacing: float = min(max_total_width / max(1, number_of_points - 1), max_point_spacing)	
	var total_width: float = ideal_spacing * (number_of_points - 1)
	
	var start_x: float = center_point.x - total_width / 2.0	
	
	for i in range(number_of_points):
		points.append(Vector2(start_x + i * ideal_spacing, center_point.y))
	
	return points


static func get_key_value(card: Card) -> int:
	var ci: CardInfo = card.get_card_info()
	return int(ci.rank) + 1

static func get_lock_value(card: Card) -> int:
	var ci: CardInfo = card.get_card_info()
	if ci.rank == CardInfo.Rank.ACE:
		return 0
	else:
		return int(ci.rank) + 1


static func can_get_target(numbers: Array[int], target: int) -> bool:
	var expressions: Array[String] = [""]
	var results: Array[int] = [0]
	
	for num in numbers:
		var new_expressions: Array[String] = []
		var new_results: Array[int] = []
		for i in range(results.size()):
			var r = results[i]
			var e = expressions[i]
			new_results.append(r+num)
			new_results.append(r-num)
			new_expressions.append(e + "+" + str(num))
			new_expressions.append(e + "-" + str(num))	
		results += new_results
		expressions += new_expressions

	var filtered_expressions: Array[String] = []
	var filtered_results: Array[int] = []

	for i in range(results.size()):
		if results[i] == target:
			filtered_expressions.append(expressions[i])
			filtered_results.append(results[i])

	expressions = filtered_expressions
	results = filtered_results

	for i in range(results.size()):
		var r = results[i]
		var e = expressions[i]
		print(e,"=",r)

	return results.size() > 0


static func can_get_any_target(numbers: Array[int], targets: Array[int]) -> bool:
	for target in targets:
		if can_get_target(numbers, target):
			return true
	return false		
	
