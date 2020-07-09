extends 'res://addons/gut/test.gd'

var Ball = load('res://scripts/ball.gd')

var ball

func before_each():
	ball = Ball.new()

func after_each():
	ball.free()

func test_can_create_ball():
	assert_not_null(ball)

func test_get_set_speed():
	assert_accessors(ball, 'speed', 0, 100)

func test_get_set_direction():
	assert_accessors(ball, 'direction', Vector2(0,0), Vector2(1,1).normalized())

func test_ball_moves_on_process():
	ball.set_speed(10)
	ball.set_direction(Vector2(1, 0))
	simulate(ball, 1, 1)
	assert_eq(ball.get_position(), Vector2(10, 0))
	
func test_ball_moves_vertically_on_process():
	ball.set_speed(10)
	ball.set_direction(Vector2(0, 1))
	simulate(ball, 2, .5)
	assert_eq(ball.get_position(), Vector2(0, 10))
	
func test_set_direction_normalizes_vector():
	ball.set_direction(Vector2(500, 100))
	assert_eq(ball.get_direction(), Vector2(500, 100).normalized())

