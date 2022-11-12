extends KinematicBody2D

#var switchfly = true
#var switchstay = true
#var spawner_move_distance = 700
#var spawner_move_speed = 15

const CANCEL = true
var pending_yield

signal playerIsDead
signal explosive
signal zone_entered
signal zone_existed
signal shake_after_damage
signal stayEnemy_explode

#Custom mouse cursor
var target_micon = load("res://assets/misc/mouse icons/target_icon.png")
#VFXs
onready var hpscreen = $HealthScreen

#onready var blast = $PlatformCharIdle/Blast


#Player Stats
var is_dead = false
var score = 0
var speed = 200.0
var take_damage = false
onready var damageTimer = $PlatformCharIdle/Damage_Timer
#export var wait_time = 2

#Player Health
onready var h1 = $Hearts/h1
onready var h2 = $Hearts/h2
onready var h3 = $Hearts/h3
onready var hpani = $Hearts/health

#Falls to death
var fall_death_control = true

# Jump Function
export var fallMultiplier = 150.0
export var lowJumpMultiplier = 100.0
export var jumpForce = 500.0
var jump_released = false

# Physics
var vel = Vector2()
var earthGravity = 9.807
export var gravityScale = 100.0
var on_floor = false

#Nodes
onready var player = $PlatformCharIdle
onready var gun = $TestPlayerGun
onready var b_spawn_pos = $TestPlayerGun/B_Spawn_pos
onready var player_hitbox = $PlatformCharIdle/Hitbox/CollisionShape2D
onready var player_cam = $Camera2D
onready var BGM = get_node("/root/Test_World/BGM")

#var stayenemy = preload("res://scn/prototype_files/stay_enemy.tscn")




#onready var spawner = $Spawners
#onready var spawnerfly = $Spawners/Spawnfly
#onready var spawnerstay = $Spawners/Spawnstay

func _ready():
	#stayenemy.connect("explode_after_damage",self,"send_another_signal")
	randomize()
	hpani.play("RESET")
	
	
	#Setting Custom mouse cursor
	Input.set_custom_mouse_cursor(target_micon,Input.CURSOR_ARROW,Vector2(16,16))
	
	
	
	
	
#onready var sprite : Sprite = $PlatformCharIdle
func _physics_process(delta):
	
	
	
	#Hp icon count
	hp_icon_count()
	
	#Falls to Death
	if player_hitbox.global_position.y > 3000 and fall_death_control == true:
		fall_death_control = false #this is needed because physics process is so fast that death() was called so many times that the endscen SFXs started to stutter
		death()
		
	#Player Movement and left-right facing stuffs
	if is_dead == false:
		if Input.is_action_just_released("ui_accept"):
			jump_released = true

		#Applying gravity to player
		vel += Vector2.DOWN * earthGravity * gravityScale * delta

		#Jump Physics
		if vel.y > 0: 
			vel += Vector2.DOWN * earthGravity * fallMultiplier * delta 
		elif vel.y < 0 && jump_released: 
			vel += Vector2.DOWN * earthGravity * lowJumpMultiplier * delta
		if on_floor:
			if Input.is_action_just_pressed("ui_accept"): 
				vel = Vector2.UP * jumpForce #Normal Jump action
				jump_released = false
		
		vel = move_and_slide(vel, Vector2.UP) 
		
		if is_on_floor(): 
			on_floor = true
		else: 
			
			on_floor = false
			
		vel.x = 0
		# Movement and Inputs
		if Input.is_action_pressed("Move_left"):
			vel.x -= speed
			player.play("Walk",false)
		elif Input.is_action_pressed("Move_right"):
			vel.x += speed
			player.play("Walk",false)
		else:
			player.play("Idle")
			
		if not is_on_floor():
			player.play("Air")

		#Walk Backwards
		if Input.is_action_pressed("Move_right") and player.global_position.x > get_global_mouse_position().x:
			player.play("Walk",true)
			
		if Input.is_action_pressed("Move_left") and player.global_position.x < get_global_mouse_position().x:
			player.play("Walk",true)
			
		_flip()
		


func _flip():
	var direction = sign(get_global_mouse_position().x - player.global_position.x)
	if direction < 0:
		b_spawn_pos.global_position = gun.global_position + Vector2(0,-5)
		gun.flip_v = true
		player.flip_h = true
	else:
		b_spawn_pos.global_position = gun.global_position + Vector2(0,-5)
		gun.flip_v = false
		player.flip_h = false
		


#Hp icon count
func hp_icon_count():
	if Caption.playerHp == 2:
		h3.hide()
		#blast.modulate = Color("ffffff")
		
	elif Caption.playerHp == 1:
		h2.hide()
		hpani.play("hp_crit")
		#blast.modulate = Color("ff2e2e")
		
	elif Caption.playerHp <= 0:
		h1.hide()
		


#func _process(delta):
		#position setter
	#spawner.global_position = player.global_position + Vector2(0, -300)
#
#	if switchfly == true:
#		spawnerfly.position.x += spawner_move_speed
#		if spawnerfly.position.x > spawner_move_distance:
#			spawner_move_speed = rand_range(25,50)
#			switchfly = false
#
#	if switchfly == false:
#		spawnerfly.position.x -= spawner_move_speed
#		if spawnerfly.position.x < -spawner_move_distance:
#			spawner_move_speed = rand_range(25,50)
#			switchfly = true
#
#	if switchstay == true:
#		spawnerstay.position.x += spawner_move_speed
#		if spawnerstay.position.x > spawner_move_distance:
#			spawner_move_speed = rand_range(25,50)
#			switchstay = false
#
#	if switchstay == false:
#		spawnerstay.position.x -= spawner_move_speed
#		if spawnerstay.position.x < -spawner_move_distance:
#			spawner_move_speed = rand_range(25,50)
#			switchstay = true
		
		

	

func death():
	BGM.stop()
	#blast.modulate = Color("ffffff")
	is_dead = true
	visible = false
	player_hitbox.set_deferred("disabled", true)
	yield(get_tree().create_timer(0.5), "timeout")
	emit_signal("playerIsDead")
	
	#Remove Custom mouse cursor
	Input.set_custom_mouse_cursor(null)


func _on_Hitbox_area_entered(area):
	if area.is_in_group("EnemyHurtbox"):
		Caption.playerHp -= 1
		if Caption.playerHp < 3 and Caption.playerHp > 0:
		
			emit_signal("explosive")
			
		elif Caption.playerHp <= 0:
			death()
	
	#if area.is_in_group("EnteringZone"):
		#emit_signal("zone_entered")
	
		#damageTimer.start()
		#if take_damage == true:
		#Caption.playerHp -= 1
		#if Caption.playerHp < 3 and Caption.playerHp > 0:
			#emit_signal("stayEnemy_explode")
		#elif Caption.playerHp <= 0:
			#death()
	#elif !area.is_in_group("EnteringZone"):
		#take_damage = false
		#damageTimer.stop()


#func send_another_signal():
	#emit_signal("shake_after_damage")


#func _on_Damage_Timer_timeout():
	#take_damage = true
	
	


#func _on_Hitbox_area_exited(area):
	#if !area.is_in_group("EnteringZone"):
		#emit_signal("zone_existed")
