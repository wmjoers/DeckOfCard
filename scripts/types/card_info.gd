extends Resource


class_name CardInfo


enum Suit {
	HEARTS,
	DIAMONDS,
	CLUBS,
	SPADES,
	RED,
	BLACK,
	COLORLESS,
	UNKNOWN,
}


enum Rank {
	ACE,
	TWO,
	THREE,
	FOUR,
	FIVE,
	SIX,
	SEVEN,
	EIGHT,
	NINE,
	TEN,
	JACK,
	QUEEN,
	KING,
	JOKER,
	BACK,
	UNKNOWN,
}


enum SuitColor {
	RED,
	BLACK,
	COLORLESS,
	UNKNOWN,
}


@export var suit: Suit
@export var rank: Rank
@export var texture: Texture2D
