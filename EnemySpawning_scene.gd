extends Node2D

# Load da Player
onready var player = get_node("/root/Test_World/Player")

# Load da enemies
var flyenemy = preload("res://scn/prototype_files/flyingEnemy.tscn")
var stayenemy = preload("res://scn/prototype_files/stay_enemy.tscn")

# Nodes
onready var spawners = $Spawnfly
onready var stayspawn = $StaySpawnPos

#Spawn Positions
onready var spawnPosition = $SpawnPosition
onready var p2d1 = $SpawnPosition/Position2D
onready var p2d2 = $SpawnPosition/Position2D2
onready var p2d3 = $SpawnPosition/Position2D3
onready var p2d4 = $SpawnPosition/Position2D4
onready var p2d5 = $SpawnPosition/Position2D5
onready var p2d6 = $SpawnPosition/Position2D6
onready var p2d7 = $SpawnPosition/Position2D7
onready var p2d8 = $SpawnPosition/Position2D8
onready var p2d9 = $SpawnPosition/Position2D9
onready var p2d10 = $SpawnPosition/Position2D10
onready var p2d11 = $SpawnPosition/Position2D11

#Difficulty control
var diff_rate = 3
var diff_stay_rate = 1
onready var spawntimer = $SpawnTimer
onready var spawndiffinterval = $spawndiffinterval

#other var
var extra_pos = 200



func _ready():
	#Starting the timer
	spawndiffinterval.start(0.1)
	spawntimer.start()


func _on_SpawnTimer_timeout():
	#Changing Spawn Positions
	var nodes = get_tree().get_nodes_in_group("spawnn")
	var node = nodes[randi() % nodes.size()]
	
	#For Flying enemy
	var enemy = flyenemy.instance()
	add_child(enemy)
	enemy.position = spawners.position
	
	var position = node.position
	spawners.position = position
	
	#For Stay Enemy
	var action = round(rand_range(0,diff_stay_rate))
	#print(action)
	if action == 1:
		var stay_enemy = stayenemy.instance()
		add_child(stay_enemy)
		stay_enemy.position = stayspawn.position
		if diff_stay_rate < 20:
			diff_stay_rate += round(rand_range(0,1))
	else:
		pass

# Calculating Position Manually
func _process(delta):
	#BG follow
	
	p2d1.global_position = player.global_position + Vector2(-740, -148) + Vector2(-extra_pos, -extra_pos)
	p2d2.global_position = player.global_position + Vector2(-512, -576) + Vector2(-extra_pos, -extra_pos)
	p2d3.global_position = player.global_position + Vector2(-384, -576) + Vector2(-extra_pos, -extra_pos)
	p2d4.global_position = player.global_position + Vector2(-256, -576) + Vector2(-extra_pos, -extra_pos)
	p2d5.global_position = player.global_position + Vector2(-128, -576) + Vector2(-extra_pos, -extra_pos)
	p2d6.global_position = player.global_position + Vector2(0, -576) + Vector2(0, -extra_pos)
	p2d7.global_position = player.global_position + Vector2(128, -576) + Vector2(extra_pos, -extra_pos)
	p2d8.global_position = player.global_position + Vector2(256, -576) + Vector2(extra_pos, -extra_pos)
	p2d9.global_position = player.global_position + Vector2(384, -576) + Vector2(extra_pos, -extra_pos)
	p2d10.global_position = player.global_position + Vector2(512, -576) + Vector2(extra_pos, -extra_pos)
	p2d11.global_position = player.global_position + Vector2(740, -148) + Vector2(extra_pos, -extra_pos)
	
	
	
#Positionings for Stay Enemy
	if Input.is_action_pressed("Move_right"):
		stayspawn.global_position = player.global_position + Vector2(640, -948)
		
	elif Input.is_action_pressed("Move_left"):
		stayspawn.global_position = player.global_position + Vector2(-640, -948)
	
	else:
		var action = round(rand_range(0,1))
		if action == 1:
			stayspawn.global_position = player.global_position + Vector2(rand_range(400,600), -948)
		else:
			stayspawn.global_position = player.global_position + Vector2(rand_range(-400,-600), -948)



#Difficulty rate
func _on_spawndiffinterval_timeout():
	if diff_rate > 0.5:
		spawntimer.wait_time = diff_rate
		diff_rate -= 0.01
	else:
		spawntimer.wait_time = rand_range(1,0.5)



