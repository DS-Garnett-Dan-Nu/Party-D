extends Node

var world = null

func _process(delta):
	if Input.is_action_pressed("restart"):
		get_tree().reload_current_scene()
