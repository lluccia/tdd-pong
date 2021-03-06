extends 'res://addons/gut/test.gd'

var GameScene = load('res://scenes/Game.tscn')

var _game

func before_each():
	_game = GameScene.instance()
	add_child(_game)

func after_each():
	remove_child(_game)
	_game.free()

func _p1_scores():
	_game.get_node("P2KillBox").emit_signal('kill_ball')
	
func _p2_scores():
	_game.get_node("P1KillBox").emit_signal('kill_ball')
	
func test_get_set_p1_score():
	assert_accessors(_game, 'p1_score', 0, 10)

func test_get_set_p2_score():
	assert_accessors(_game, 'p2_score', 0, 10)

func test_get_set_max_score():
	assert_accessors(_game, 'max_score', 10, 0)

func test_when_p1_killbox_emits_kill_ball_then_ball_is_recentered():
	var ball = _game.get_ball() 
	var orig_pos = ball.get_position()
	
	ball.set_position(Vector2(1,1))
	
	_p2_scores()
	assert_eq(ball.get_position(), orig_pos)

func test_when_p2_killbox_emits_kill_ball_then_ball_is_recentered():
	var ball = _game.get_ball() 
	var orig_pos = ball.get_position()
	
	ball.set_position(Vector2(1,1))
	
	_p1_scores()
	assert_eq(ball.get_position(), orig_pos)

func test_when_p1_killbox_kills_ball_p2_score_increases():
	_p2_scores()
	
	assert_eq(_game.get_p2_score(), 1)

func test_when_p2_killbox_kills_ball_p1_score_increases():
	_p1_scores()
	
	assert_eq(_game.get_p1_score(), 1)

func test_score_labels_show_score_on_start():
	assert_eq(_game.get_node("P1Score").text, "0")
	assert_eq(_game.get_node("P2Score").text, "0")

func test_when_p1_scores_then_score_is_updated():
	_p1_scores()
	assert_eq(_game.get_node("P1Score").text, "1")

func test_when_p2_scores_then_score_is_updated():
	_p2_scores()
	assert_eq(_game.get_node("P2Score").text, "1")

func test_when_p1_scores_then_ball_speed_is_reset():
	var ball = _game.get_node("Ball")
	var initial_speed = ball.get_speed()
	
	ball.set_speed(initial_speed + 100)

	_p1_scores()

	assert_eq(ball.get_speed(), initial_speed)

func test_when_p2_scores_then_ball_speed_is_reset():
	var ball = _game.get_node("Ball")
	var initial_speed = ball.get_speed()
	
	ball.set_speed(initial_speed + 100)

	_p2_scores()

	assert_eq(ball.get_speed(), initial_speed)

func test_when_p1_reaches_max_score_game_over_emmited():
	watch_signals(_game)
	_game.set_max_score(2)

	_p1_scores()
	_p1_scores()

	assert_signal_emitted(_game, 'game_over')

func test_when_p2_reaches_max_score_game_over_emmited():
	watch_signals(_game)
	_game.set_max_score(3)

	_p2_scores()
	_p2_scores()
	_p2_scores()

	assert_signal_emitted(_game, 'game_over')

func test_when_game_ends_ball_stops_moving():
	_game.set_max_score(2)

	_p1_scores()
	_p1_scores()
	
	assert_eq(_game.get_ball().get_speed(), 0)
	
