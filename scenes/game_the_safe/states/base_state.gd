class_name BaseState

enum State {
	READY,
	BUILD_LEVEL,
	DEAL_HAND,
	CHECK_FREE_LOCKS,
	CHECK_ACES, 
	PLAY_CARDS,
	DISCARD_HAND,
	#GAME_OVER_WIN,
	#GAME_OVER_LOSE,
	NULL,
}

var game: GameTheSafe

var is_finished = false
var next_state: State = State.NULL
var transition_delay: float = 0.0

var _tree: SceneTree: 
	get:
		return game.get_tree()


func _init(game: GameTheSafe) -> void:
	self.game = game


func ready_state() -> void:
	pass


func enter_state(from_state: State) -> void:
	pass

	
func exiting_state() -> void:
	pass


func process(delta: float) -> void:
	pass

func physics_process(delta: float) -> void:
	pass

func input(event: InputEvent) -> void:
	pass
	

func _exit_to(next_state: State, transition_delay: float = 0.0) -> void:
	self.next_state = next_state
	self.transition_delay = transition_delay
	is_finished = true
