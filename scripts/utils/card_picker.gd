class_name CardPicker


var _space_state: PhysicsDirectSpaceState2D


func  _init(space_state: PhysicsDirectSpaceState2D) -> void:
	_space_state = space_state


func _pick_top_card(pos: Vector2, interaction_mask: int) -> Card:
	var result = _pick_all_cards(pos, interaction_mask)
	if result.size() > 0:
		return result[0]
	return null


func _pick_all_cards(pos: Vector2, interaction_mask: int) -> Array[Card]:
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = pos
	parameters.collide_with_areas = true
	parameters.collide_with_bodies = false
	parameters.collision_mask = interaction_mask
	var intersect_result: Array[Dictionary]  = _space_state.intersect_point(parameters, 52)
	print("Intersections: ", intersect_result.size())

	var result: Array[Card] = []
	for ir in intersect_result: 
		if ir.has("collider") and ir["collider"] is Area2D:
			var collider: Area2D = ir["collider"]
			var parent: Node2D = collider.get_parent()
			if parent and parent is Card:
				result.append(parent)
	if result.size() > 0:
		result.sort_custom(func(a: Card , b: Card): return a.z_index > b.z_index)
		return result
	return []
