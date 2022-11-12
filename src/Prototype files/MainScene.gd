extends Node2D


var Enemy = preload("res://scn/prototype_files/flyingEnemy.tscn")

onready var sp = $Spawn
#func _ready():
	#randomize()
	
#func _on_EnemyTimer_timeout():
	#var rng = RandomNumberGenerator.new()
	#rng.randomize()
	
	#$Player/Path2D/PathFollow2D.offset = rng.randi_range(0, 3664)
	#var instance = enemy.instance()
	
	#instance.golbal_position = $Player/Path2D/PathFollow2D/Position2D.global_position
	#add_child(instance)
func _on_SpawnTimer_timeout():
	var enemy = Enemy.instance()
	add_child(enemy)
	enemy.position = sp.position
