class_name CardTweens


static func move_card_to_pos(tree: SceneTree, card: Card, position: Vector2, rotation: float, seconds: float, floating: bool = false) -> Tween:
	
	var distance = card.global_position.distance_to(position)
	if distance <= 2:
		card.global_position = position
		return
	
	card.set_floating(floating)
	var tw = tree.create_tween()
	tw.set_ease(Tween.EASE_IN_OUT)
	tw.set_trans(Tween.TRANS_QUAD)
	tw.set_parallel(true)
	tw.tween_property(card, "global_position", position, seconds)
	tw.tween_property(card, "rotation", rotation, seconds)	
	tw.set_parallel(false)
	tw.tween_callback(func():
		card.set_floating(false)
	)
	return tw
	
static func move_card_to_pos_with_speed(tree: SceneTree, card: Card, position: Vector2, rotation: float, speed: float, floating: bool = false) -> Tween:
	var distance = card.global_position.distance_to(position)
	if distance <= 2:
		card.global_position = position
		return

	var seconds = distance / speed
	return move_card_to_pos(tree, card, position, rotation, seconds, floating)

static func randomize_posistion(position: Vector2, max_distance: float) -> Vector2:
	var distance = randf_range(0, max_distance)
	var angle = randf_range(0, TAU)
	var offset = Vector2.from_angle(angle) * distance
	return  position + offset
	

static func randomize_rotation(rotation: float, max_tilt: float) -> float:
	return rotation + randf_range(-max_tilt, max_tilt)
