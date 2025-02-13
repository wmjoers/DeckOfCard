class_name StateFactory

static func create_state_impl(state: BaseState.State, game: GameTheSafe) -> BaseState:
	match state:
		BaseState.State.BUILD_LEVEL:
			return BuildLevelState.new(game)
		BaseState.State.DEAL_HAND:
			return DealHandState.new(game)
		BaseState.State.PLAY_CARDS:
			return PlayCardsState.new(game)
		BaseState.State.DISCARD_HAND:
			return DiscardHandState.new(game)
		BaseState.State.CHECK_FREE_LOCKS:
			return CheckFreeLocksState.new(game)
		BaseState.State.CHECK_ACES:
			return CheckAcesState.new(game)
		BaseState.State.CHECK_GAME_OVER:
			return CheckGameOverState.new(game)
			
	return null
