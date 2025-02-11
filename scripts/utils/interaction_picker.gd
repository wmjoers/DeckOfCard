# V2
class_name InteractionPicker


var _space_state: PhysicsDirectSpaceState2D
var _max_results: int

var _card_results: Array[Card] = []
var _area_results: Array[InteractionArea] = []


func  _init(space_state: PhysicsDirectSpaceState2D, max_results: int = 52) -> void:
	_space_state = space_state
	_max_results = max_results


func clear_results() -> void:
	_card_results.clear()
	_area_results.clear()


func pick_with_position(position: Vector2, interaction_type_flags: int) -> bool:
	
	clear_results()
	
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = position
	parameters.collide_with_areas = true
	parameters.collide_with_bodies = false
	parameters.collision_mask = interaction_type_flags
	
	
	var intersect_result: Array[Dictionary]  = _space_state.intersect_point(parameters, _max_results)
	print("Intersections: ", intersect_result.size())

	for ir in intersect_result: 
		if ir.has("collider") and ir["collider"] is InteractionArea:
			var collider: InteractionArea = ir["collider"]
			var parent = collider.get_parent()
			if parent and parent is Card:
				_card_results.append(parent as Card)
			else:
				_area_results.append(collider)
				
	if _card_results.size() > 0:
		_card_results.sort_custom(func(a: Card , b: Card): return a.z_index > b.z_index)
		
	return has_areas() or has_cards()


func has_cards() -> bool:
	return _card_results.size() > 0


func has_areas() -> bool:
	return _area_results.size() > 0


func get_top_card() -> Card:
	if has_cards():
		return _card_results[0]
	return null


func get_all_cards() -> Array[Card]:
	return Array(_card_results)


func get_top_area() -> InteractionArea:
	if has_areas():
		return _area_results[0]
	return null


func get_all_areas() -> Array[InteractionArea]:
	return Array(_area_results)
