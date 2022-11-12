extends Node2D


var enemy = preload("res://scn/prototype_files/flyingEnemy.tscn")

#func _ready():
	#randomize()
	
func _on_EnemyTimer_timeout():
	var rng = 4
	
	$Player/Path2D/PathFollow2D.offset = rng.randi_range(0, 3664)
	var instance = enemy.instance()
	
	instance.golbal_position = $Player/Path2D/PathFollow2D/Position2D.global_position
	add_child(instance)
	
	
