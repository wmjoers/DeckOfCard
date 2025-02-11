extends Node2D
class_name Card


const BACK_TEXTURE = preload("res://resources/card_textures/colorless_back_tx.tres")

const NORMAL_SHADOW_POS: Vector2 = Vector2(-1, -1) 
const FLOATING_SHADOW_POS: Vector2 = Vector2(-3, -3) 

const NORMAL_COLOR: Color = Color(1,1,1,1)
const SELECTED_COLOR: Color = Color(1, 1, 0.8)


signal dropped(card: Card)


@onready var card_sprite: Sprite2D = $CardSprite
@onready var shadow_sprite: Sprite2D = $ShadowSprite
@onready var area: InteractionArea = $InteractionArea


@export var _card_info: CardInfo = null
@export var _flipped: bool = false
@export var _selected: bool = false
@export var _floating: bool = false


func _ready() -> void:
	_update_card()
	

func set_interaction_type(interaction_type: int, active: bool) -> void:
	area.set_collision_layer_value(interaction_type, active) 
	

func get_interaction_type(interaction_type: int) -> bool:
	return area.get_collision_layer_value(interaction_type)


func set_reacts_to_interaction_type(interaction_type: int, active: bool) -> void:
	area.set_collision_mask_value(interaction_type, active) 
	
	
func get_reacts_to_interaction_type(interaction_type: int) -> bool:
	return area.get_collision_mask_value(interaction_type)


func set_interaction_type_flags(interaction_type_flags: int) -> void:
	area.collision_layer = interaction_type_flags
	

func get_interaction_type_flags() -> int:
	return area.collision_layer


func set_reacts_to_interaction_type_flags(interaction_type_flags: int) -> void:
	area.collision_mask = interaction_type_flags
	

func get_reacts_to_interaction_type_flags() -> int:
	return area.collision_mask


func set_card_info(card_info: CardInfo) -> void:
	_card_info = card_info
	_update_card()


func get_card_info() -> CardInfo:
	return _card_info


func set_flipped(flipped: bool) -> void:
	_flipped = flipped
	_update_card()


func is_flipped() -> bool:
	return _flipped


func flipp() -> bool:
	_flipped = not _flipped
	_update_card()
	return _flipped


func set_floating(floating: bool) -> void:
	_floating = floating
	_update_card()


func is_floating() -> bool:
	return _floating


func set_selected(selected: bool) -> void:
	_selected = selected
	_update_card()


func is_selected() -> bool:
	return _selected


func toggle_selected() -> bool:
	_selected = not _selected
	_update_card()
	return _selected


func grab() -> void:
	set_floating(true)


func drop() -> void:
	set_floating(false)
	dropped.emit(self)


func _update_card() -> void:
	if _flipped:
		card_sprite.texture = BACK_TEXTURE
	else:
		if _card_info != null:
			card_sprite.texture = _card_info.texture
		else:
			card_sprite.texture = null
	
	if _floating:
		shadow_sprite.position = -FLOATING_SHADOW_POS
	else:
		shadow_sprite.position = -NORMAL_SHADOW_POS
	
	if _selected: 
		card_sprite.self_modulate = SELECTED_COLOR
	else:
		card_sprite.self_modulate = NORMAL_COLOR
