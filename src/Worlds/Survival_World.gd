extends Node2D

signal create_block(player_position)

#other var
var extra_pos = 200




#Difficulty control
var diff_rate = 3




#Nodes
onready var player_cam = $Player/Camera2D
onready var player = $Player/PlatformCharIdle



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










