extends Area2D

signal kill_ball

func _on_KillBox_area_entered(_area):
	emit_signal('kill_ball')
