# V2
class_name CardAnimations

static func move_card(tree: SceneTree, card: Card, position: Vector2, seconds: float, floating: bool = false) -> Tween:
	var distance = card.global_position.distance_to(position)
	if distance <= 2:
		card.global_position = position
		return
	
	card.set_floating(floating)
	var tw = tree.create_tween()
	tw.set_ease(Tween.EASE_IN_OUT)
	tw.set_trans(Tween.TRANS_QUAD)
	tw.tween_property(card, "global_position", position, seconds)
	tw.tween_callback(func():
		card.set_floating(false)
	)
	return tw

static func move_and_rotate_card(tree: SceneTree, card: Card, position: Vector2, rotation: float, seconds: float, floating: bool = false) -> Tween:
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


static func flip_card(tree: SceneTree, card: Card, seconds: float, delay: float = 0) -> Tween:
	var tw = tree.create_tween()
	if delay > 0:
		tw.tween_interval(delay)
	tw.set_ease(Tween.EASE_IN_OUT)
	tw.set_trans(Tween.TRANS_QUAD)
	tw.tween_property(card, "scale", Vector2(0.0, 1.0), seconds/2.0)
	tw.tween_callback(func():
		card.flipp()
	)
	tw.tween_property(card, "scale", Vector2(1.0, 1.0), seconds/2.0)	
	return tw

static func shake_card(tree: SceneTree, card: Card, repeats: int = 1) -> Tween:
	var org_pos: Vector2 = card.global_position
	var left_pos: Vector2 = org_pos + Vector2.LEFT * 2
	var right_pos: Vector2 = org_pos + Vector2.RIGHT * 2
	
	repeats = max(repeats, 1)
	
	var tw = tree.create_tween()
	for i in range(repeats):
		tw.tween_property(card, "global_position", left_pos, 0.04)	
		tw.tween_property(card, "global_position", right_pos, 0.04)	
	tw.tween_property(card, "global_position", org_pos, 0.04)	
	return tw

static func wiggle_card(tree: SceneTree, card: Card, repeats: int = 1) -> Tween:
	var org_rot: float = card.rotation
	var left_rot: float = org_rot - deg_to_rad(4.0)
	var right_rot: float = org_rot + deg_to_rad(4.0)
	
	repeats = max(repeats, 1)
	
	var tw = tree.create_tween()
	for i in range(repeats):
		tw.tween_property(card, "rotation", left_rot, 0.1)	
		tw.tween_property(card, "rotation", right_rot, 0.1)	
	tw.tween_property(card, "rotation", org_rot, 0.1)	
	return tw
