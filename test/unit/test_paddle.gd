extends 'res://addons/gut/test.gd'

var Paddle = load('res://scripts/paddle.gd')
var Ball = load('res://scripts/ball.gd')

var _paddle
var _ball

func before_each():
	_paddle = Paddle.new()
	_ball = double(Ball).new()

func after_each():
	_paddle.free()
	_ball.free()

func test_can_create_paddle():
	assert_not_null(_paddle)

func test_bounce_inverts_x():
	stub(_ball, 'get_direction').to_return(Vector2(1, 1))
	stub(_ball, 'get_speed').to_return(100)

	_paddle.bounce(_ball)
	var new_x = get_call_parameters(_ball, 'set_direction', 0)[0].x

	assert_eq(new_x, -1.0)

func test_bounce_inverts_x_other_direction():
	stub(_ball, 'get_direction').to_return(Vector2(-1, 1))
	stub(_ball, 'get_speed').to_return(100)

	_paddle.bounce(_ball)
	var new_x = get_call_parameters(_ball, 'set_direction', 0)[0].x

	assert_eq(new_x, 1.0)

func test_bounce_increases_speed_10_percent():
	stub(_ball, 'get_direction').to_return(Vector2(-1, 1))
	stub(_ball, 'get_speed').to_return(100)

	_paddle.bounce(_ball)
	var new_speed = get_call_parameters(_ball, 'set_speed', 0)[0]

	assert_eq(new_speed, 110)

func test_bounce_changes_y_randomly():
	stub(_ball, 'get_direction').to_return(Vector2(-1, 1))
	stub(_ball, 'set_direction').to_do_nothing()
	stub(_ball, 'get_speed').to_return(100)
	stub(_ball, 'set_speed').to_do_nothing()

	_paddle.bounce(_ball)

	for _i in range(1000):
		_paddle.bounce(_ball)

	var last_y = get_call_parameters(_ball, 'set_direction', 0)[0].y
	var current_y = 0
	var num_equal = 0

	var min_y = 3
	var max_y = -3

	for i in range(1,1000):
		current_y = get_call_parameters(_ball, 'set_direction', i)[0].y
		if (current_y == last_y):
			num_equal += 1

		max_y = max(max_y, current_y)
		min_y = min(min_y, current_y)

	assert_eq(num_equal, 0)

	assert_between(max_y, .3, .5)
	assert_between(min_y, -.5, -.3)

func test_move_up_moves_by_speed_times_delta():
	_paddle.set_position(Vector2(0,300))
	var orig_pos = _paddle.get_position()

	_paddle.set_speed(20)
	_paddle.move_up(.5)
	
	assert_eq(_paddle.get_position().y, orig_pos.y - 10, 'moves up by .5 * 20')

func test_move_down_moves_by_speed_times_delta():
	_paddle.set_position(Vector2(0,300))
	var orig_pos = _paddle.get_position()

	_paddle.set_speed(30)
	_paddle.move_down(.5)
	
	assert_eq(_paddle.get_position().y, orig_pos.y + 15, 'moves down by .5 * 30')
