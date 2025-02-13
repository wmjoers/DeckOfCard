extends Node2D


class_name GameTheSafe


@onready var deck_marker: Marker2D = $DeckMarker
@onready var discard_pile_marker: Marker2D = $DiscardPileMarker
@onready var table_node: Node2D = $Table
@onready var locks_node: Node2D = $Locks
@onready var hand_node: Node2D = $Hand
@onready var addition_area: InteractionArea = $AddRect/AdditionArea
@onready var subtraction_area: InteractionArea = $SubRect/SubtractionArea


const DECK_INFO: DeckInfo = preload("res://resources/deck_info/standard_deck_info.tres")
const CARD_SCENE: PackedScene = preload("res://scenes/card/card.tscn")

const CARD_DEFAULT_MAX_TILT: float = deg_to_rad(1.0)
const CARD_IN_DECK_MAX_TILT: float = deg_to_rad(4.0)
const CARD_IN_DISCARD_MAX_TILT: float = deg_to_rad(25.0)
const CARD_IN_DISCARD_SPREAD: float = 20.0


var deck: Array[Card] = []
var hand: Array[Card] = [ null, null, null, null, null ]
var hand_pos: Array[Vector2] = []
var locks: Array[Lock] = []

var _card_collection: CardCollection

var _next_state: BaseState.State = BaseState.State.NULL
var _last_state: BaseState.State = BaseState.State.NULL
var _current_state: BaseState.State = BaseState.State.READY
var _current_state_impl: BaseState = null


func _ready() -> void:	
	_init_game()
	_init_cards()
	_next_state = BaseState.State.BUILD_LEVEL
	_goto_next_state()


func _init_game() -> void:
	for child in locks_node.get_children():
		if child is Lock:
			locks.append(child as Lock)
	for child in hand_node.get_children():
		if child is Marker2D:
			hand_pos.append(child.global_position)	


func _init_cards() -> void:
	DECK_INFO.card_info_list.shuffle()
	
	for i in range(0, DECK_INFO.card_info_list.size()):
		var card = CARD_SCENE.instantiate()
		table_node.add_child(card)
		card.flipp()
		card.rotation = CardUtils.get_random_tilt(0, CARD_IN_DECK_MAX_TILT)
		card.global_position = deck_marker.global_position - Vector2(0.1, 0.1) * i
		card.set_card_info(DECK_INFO.card_info_list.pop_back())
		deck.append(card)
		
	_card_collection = CardCollection.new(table_node)
	_card_collection.clear_all_card_states()


func _exit_current_state() -> void:
	if _current_state_impl:
		_current_state_impl.exiting_state()
		_current_state_impl = null
	_last_state = _current_state
	_current_state = BaseState.State.NULL


func _goto_next_state_delayed(seconds: float) -> void:
	var timer: SceneTreeTimer = get_tree().create_timer(seconds)
	timer.timeout.connect(_goto_next_state)


func _goto_next_state() -> void:
	var next_state_impl: BaseState = StateFactory.create_state_impl(_next_state, self)	
	
	if next_state_impl:
		next_state_impl.ready_state()
		_current_state = _next_state
		_current_state_impl = next_state_impl
		next_state_impl.enter_state(_last_state)


func _physics_process(delta: float) -> void:
	if _current_state_impl == null:
		return

	_current_state_impl.physics_process(delta)


func _process(delta: float) -> void:
	if _current_state_impl == null:
		return
		
	_current_state_impl.process(delta)
	
	if _current_state_impl.is_finished:
		var _delay: float =  _current_state_impl.transition_delay
		_next_state = _current_state_impl.next_state
		_exit_current_state()
		if _delay > 0.0:
			_goto_next_state_delayed(_delay)
		else:
			_goto_next_state()

func _input(event: InputEvent) -> void:
	if _current_state_impl:
		_current_state_impl.input(event)

func clear_all_card_states() -> void:
	_card_collection.clear_all_card_states()
	
func clear_all_area_states() -> void:
	addition_area.set_interaction_type_flags(0)
	addition_area.set_reacts_to_interaction_type_flags(0)
	subtraction_area.set_interaction_type_flags(0)
	subtraction_area.set_reacts_to_interaction_type_flags(0)

func to_front(card: Card) -> void:
	_card_collection.to_front(card)
	
func to_front_array(cards: Array[Card]) -> void:
	_card_collection.to_front_array(cards)

func get_card_from_deck() -> Card:
	var card: Card = deck.pop_back()
	return card
	
func discard_card(card: Card) -> void:
	var org_pos: Vector2 = discard_pile_marker.global_position
	var pos: Vector2 = CardUtils.get_random_position(org_pos, CARD_IN_DISCARD_SPREAD)
	var rot: float = CardUtils.get_random_tilt(0, CARD_IN_DISCARD_MAX_TILT)
	CardAnimations.move_and_rotate_card(get_tree(), card, pos, rot, 0.4, true)
