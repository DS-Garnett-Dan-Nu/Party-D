extends Position2D

# use a custom signal to tell the world scene to create blocks
# signals are usefull when instancing the block outside of this current scene
# this signal takes two arguments the block we want to create, and the location of the block
signal create_block(block, location)

var block_spawn_distance = 700
var block_spawn_permit = false
var player_positionx = 0
var player_positiony = 0
var starting_block_counter = 0
var t_roughness = 25
var t_difficulty = 0
var mxpos = true


# terrain roughness phases markers
export(int) var phase_1 = 75
export(int) var phase_2 = 125
export(int) var phase_3 = 175

export(int) var max_starting_blocks = 16
export(int) var tile_height = 25
export(int) var tile_height_big = 0
# the space in between each block
export(int) var grid_sizex = 0
# the block to preload so we can instance it later
export(PackedScene) var block = preload("res://scn/prototype_files/test_ground_2.tscn")




func _ready():
	randomize()
	#connect("create_block", Global.world, "_on_LevelGenerator_create_block")
	
	#Global.world = self
	# check if the world node exists through the global singleton
	#if Global.world != null:
		# if it is not equal to null which means it exists we will then
		# link the signal to the world, through the Global singleton
		#connect("create_block", Global.world, "_on_LevelGenerator_create_block")
		
func _on_create_block(player_position_foreign, permit):
	block_spawn_permit = permit
	player_positionx = player_position_foreign.x
	player_positiony = player_position_foreign.y

func block_creater(pos_y):
	global_position.y = pos_y
	
	t_difficulty += 1
	#print(t_difficulty)
	#terrain roughness
	var action = round(rand_range(0, t_roughness))
	if action >= 0 and action <= 3:
		global_position.y -= tile_height
	elif action >= 4 and action < 7:
		global_position.y += tile_height
	elif action == 8:
		global_position.y -= tile_height_big
	elif action == 9:
		global_position.y += tile_height_big
	
	emit_signal("create_block", block, global_position)





func _on_Timer_timeout():
	
	#tile_roughness
	if t_difficulty == phase_1:
		tile_height_big = 25
		t_roughness = 20
	elif t_difficulty == phase_2:
		t_roughness = 15
		tile_height_big = 50
	elif t_difficulty == phase_3:
		t_roughness = 10
		tile_height_big = 75
	
	#starting_blocks_creater
	if starting_block_counter < max_starting_blocks:
		# Do not change the order of these codes
		if mxpos == true:
			global_position.x += grid_sizex
			grid_sizex = 100
			block_creater(0)
			starting_block_counter += 1
			mxpos = false
		else:
			global_position.x = global_position.x * -1
			block_creater(0)
			global_position.x = global_position.x * -1
			starting_block_counter += 1
			mxpos = true
	
	#block where to create or not, right side
	if Input.is_action_pressed("Move_right") and block_spawn_permit == true:
		global_position.x = 0
		global_position.x = player_positionx + block_spawn_distance
		block_condi()


	#block where to create or not, left side
	if Input.is_action_pressed("Move_left") and block_spawn_permit == true:
		global_position.x = 0
		global_position.x = player_positionx - block_spawn_distance
		block_condi()

			
func block_condi():
	block_spawn_permit = false
	block_creater(0)
		
	#Second Y Block or not
	var action = round(rand_range(0,5))
	if action == 1:
		block_creater(global_position.y-400)
	else:
		pass
	

