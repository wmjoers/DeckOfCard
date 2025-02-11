extends Node2D

const STANDARD_DECK_INFO: DeckInfo = preload("res://resources/deck_info/standard_deck_info.tres")
@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	var card_info: CardInfo = STANDARD_DECK_INFO.card_info_list.pick_random()
	sprite_2d.texture = card_info.texture
	
