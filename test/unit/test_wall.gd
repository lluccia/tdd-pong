extends 'res://addons/gut/test.gd'

var Wall = load('res://scripts/wall.gd')
var Ball = load('res://scripts/ball.gd')

var _wall

func before_each():
	_wall = Wall.new()

func after_each():
	_wall.free()

func test_can_create_wall():
	assert_not_null(_wall)

func test_can_bounce_ball():
	var ball = double(Ball).new()
	
	var dir = Vector2(1, 1).normalized()
	stub(ball, 'get_direction').to_return(dir)
	stub(ball, 'set_direction').to_do_nothing()

	_wall.bounce(ball)

	assert_called(ball, 'set_direction', [dir * Vector2(1, -1)])


func test_get_set_color():
	assert_accessors(_wall, 'color', Color(1, 1, 1), Color(0, 0, 0)) 
