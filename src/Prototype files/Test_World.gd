extends Node2D

signal create_block(player_position)

#other var
var extra_pos = 200




#Difficulty control
var diff_rate = 3
var diff_stay_rate = 1
onready var spawntimer = $SpawnTimer
onready var spawndiffinterval = $spawndiffinterval



#Nodes
onready var player_cam = $Player/Camera2D
onready var player = $Player/Ani
onready var spawners = $Spawnfly
onready var stayspawn = $StaySpawnPos
#onready var spawnArea = $SpArea
#onready var spawnRect = $SpArea/SpawnArea

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


#Load da enemies
var flyenemy = preload("res://scn/prototype_files/flyingEnemy.tscn")
var stayenemy = preload("res://scn/prototype_files/stay_enemy.tscn")


# preload the level generator so we can instance it later
var level_generator = preload("res://scn/prototype_files/MapAIPrototype.tscn")
# set the level generator position that is being instanced
var level_generator_position = Vector2(0, 0)

# set the world variable to this node when it's created
# we do this through the Global singleton
# that way all nodes gain access to it
func _ready():
	Caption.points = 0
	Caption.stayEnemyPoints = 0
	Caption.playerHp = 3
	
	Global.world = self
	# the reason we don't have the level generator in the game at the start is..
	# the level generator needs to get access to Global.world
	# if the level generator is already in the game it won't see it
	# it needs access so it can connect the signal to the world
	instance_node(level_generator, self, level_generator_position)
	
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
	
	

# when the node has left the tree
# we want to set the world variable from the singleton back to null
# null will make sure that other nodes know it doesn't exist
func _exit_tree():
	Global.world = null

# this is a node instancing function
func instance_node(node, parent, location):
	# get a reference of the node that we are instancing
	var node_instance = node.instance()
	# add the child of that node instance to the parent
	parent.add_child(node_instance)
	# set that nodes position to the location argument
	node_instance.global_position = location

# this function is the signal that the level generator calls
# these arguments are filled out when the signal is emitted
# so these arguments will conatin data about the block we want to create and the location
#func _on_LevelGenerator_create_block(block, location):
	# this uses the instance node function that I created above
	

func block_create_time():
	emit_signal("create_block",player.global_position,true)

func _on_t_creater_create_block(block, location):
	instance_node(block, self, location)







# Calculating Position Manually
func _process(delta):
	#spawners.global_position = player.global_position + Vector2(0, -300)
	#spawnArea.global_position = player.global_position + Vector2(0, -300)
	#spawnPosition.global_position = player.global_position  * delta
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
