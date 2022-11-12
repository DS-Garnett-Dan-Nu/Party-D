extends Sprite

onready var gunsfx = $GunSFX
onready var flash = get_node("B_Spawn_pos/flash")
onready var flash2 = $B_Spawn_pos/flash2
onready var player = get_node("/root/Test_World/Player")

export var bullet_speed = 1100
export var fire_rate = 0.05


var bullet = preload("res://scn/prototype_files/Cannon.tscn")
var can_fire = true
var is_dead = false
var bullet_control = true
#onready var b_spawn_pos = $B_Spawn_pos



func _ready():
	player.connect("playerIsDead",self,"if_player_die")
	flash.hide()
	flash2.hide()
	
func _process(delta: float) -> void:
	#b_spawn_pos.look_at(get_global_mouse_position())
	look_at(get_global_mouse_position())

	#Aligning SFX and Animations
	if Input.is_action_pressed("Fire") and can_fire and is_dead == false:
		if Input.is_action_pressed("Fire") and gunsfx.playing == false:
			gunsfx.play()
			yield(get_tree().create_timer(0.8), "timeout")
			bullet_physics()
			bullet_control = false
		elif bullet_control == false:
			bullet_physics()
		
	if !Input.is_action_pressed("Fire"):
		gunsfx.stop()
		bullet_control = true
		


func if_player_die():
	is_dead = true
	if is_dead == true:
		can_fire = false
		#yield(get_tree().create_timer(0.01), "timeout")



func bullet_physics():
	#gun flash animation and sfx
		flash.show()
		flash2.show()
		flash.play("flash")
		flash2.play("flash2")
		
		#bullet physics
		var bullet_instance = bullet.instance()
		bullet_instance.position = $B_Spawn_pos/BulletPoint.get_global_position()
		bullet_instance.rotation_degrees = rotation_degrees
		bullet_instance.apply_impulse(Vector2(), Vector2(bullet_speed, 0).rotated(rand_range(rotation - 0.05, rotation + 0.05)))
		get_tree().get_root().add_child(bullet_instance)
		can_fire = false
		
		
		#bullet physics (fire rate control)
		yield(get_tree().create_timer(fire_rate), "timeout")
		can_fire = true
		
		#gun flash animation
		flash.hide()
		flash2.hide()
