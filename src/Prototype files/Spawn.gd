extends Node2D


#var Enemy = preload("res://scn/prototype_files/flyingEnemy.tscn")

const ROTATION_SPEED = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.





func _process(delta):
	rotation += ROTATION_SPEED * delta


