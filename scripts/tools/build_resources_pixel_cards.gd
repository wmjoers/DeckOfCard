@tool
extends EditorScript


const SOURCE_TEXTURE: Texture2D = preload("res://assets/graphics/cardsLarge_tilemap.png")
const CARD_TEXTURES_PATH: String = "res://resources/card_textures/"
const CARD_INFO_PATH: String = "res://resources/card_info/"
const DECK_INFO_PATH: String = "res://resources/deck_info/"
const CARD_START_POS: Vector2 = Vector2i(11, 2)
const CARD_DISTANCE: Vector2 = Vector2i(65, 65)
const CARD_SIZE: Vector2 = Vector2i(42, 60)


func _run() -> void:
	print("Building resources")
	_build_resources_for_suite(CardInfo.Suit.HEARTS, 0, 0)
	_build_resources_for_suite(CardInfo.Suit.DIAMONDS, 0, 1)
	_build_resources_for_suite(CardInfo.Suit.CLUBS, 0, 2)
	_build_resources_for_suite(CardInfo.Suit.SPADES, 0, 3)
	_build_resources_for_card(CardInfo.Suit.RED, CardInfo.Rank.JOKER, 13, 2)
	_build_resources_for_card(CardInfo.Suit.BLACK, CardInfo.Rank.JOKER, 13, 3)
	_build_card_texture_resource(CardInfo.Suit.COLORLESS, CardInfo.Rank.BACK, 13, 1)
	_build_standard_deck_info_resource()


func _build_resources_for_suite(suit: CardInfo.Suit, col: int, row: int) -> void:
	for rank in range(0, 13):
		_build_resources_for_card(suit, rank, col+rank, row)


func _build_resources_for_card(suit: CardInfo.Suit, rank: CardInfo.Rank, col: int, row: int) -> void:
	var texture_file_path: String = _build_card_texture_resource(suit, rank, col, row)
	_build_card_info_resource(suit, rank, texture_file_path)


func _build_card_texture_resource(suit: CardInfo.Suit, rank: CardInfo.Rank, col: int, row: int) -> String:
	var x: float = CARD_START_POS.x + CARD_DISTANCE.x * col
	var y: float = CARD_START_POS.y + CARD_DISTANCE.y * row
	var rect: Rect2 = Rect2(x, y, CARD_SIZE.x, CARD_SIZE.y)
	var file_path = _get_file_path(CARD_TEXTURES_PATH, suit, rank, "_tx")
	var tx: AtlasTexture = AtlasTexture.new()
	tx.atlas = SOURCE_TEXTURE
	tx.region = rect
	ResourceSaver.save(tx, file_path)
	return file_path


func _build_card_info_resource(suit: CardInfo.Suit, rank: CardInfo.Rank, texture_file_path: String) -> void:
	var file_path = _get_file_path(CARD_INFO_PATH, suit, rank)
	var ci: CardInfo = CardInfo.new()
	ci.suit = suit
	ci.rank = rank
	ci.texture = load(texture_file_path)
	ResourceSaver.save(ci, file_path)


func _build_standard_deck_info_resource() -> void:
	var file_path: String = DECK_INFO_PATH + "standard_deck_info.tres"
	var deck_info: DeckInfo = DeckInfo.new()
	for suit in range(0, 4):
		for rank in range(0, 13):
			var info_file_path: String = _get_file_path(CARD_INFO_PATH, suit, rank)
			deck_info.card_info_list.append(load(info_file_path))
	ResourceSaver.save(deck_info, file_path)


func _get_file_path(folder_path: String, suit: CardInfo.Suit, rank: CardInfo.Rank, postfix: String = "") -> String:
	var suit_name: String = CardInfo.Suit.keys()[suit].to_lower() 
	var rank_name: String = CardInfo.Rank.keys()[rank].to_lower()
	var file_path: String = folder_path + suit_name + "_" + rank_name + postfix + ".tres"
	return file_path
