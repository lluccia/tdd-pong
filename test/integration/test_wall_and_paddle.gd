extends 'res://addons/gut/test.gd'

var WallScene = load('res://scenes/Wall.tscn')
var PaddleScene = load('res://scenes/Paddle.tscn')

func test_wall_and_paddle_can_collide_without_error():
	var wall = WallScene.instance()
	var paddle = PaddleScene.instance()

	wall.set_position(Vector2(80, 80))
	paddle.set_position(Vector2(100, 150))

	add_child(paddle)
	add_child(wall)

	paddle.set_speed(50)
	paddle.move_up(1)
	
	yield(yield_for(.5), YIELD)
	assert_true(true, 'no exception was thrown')
	
	remove_child(paddle)
	remove_child(wall)
	
