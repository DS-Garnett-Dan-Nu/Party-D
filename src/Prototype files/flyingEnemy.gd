extends KinematicBody2D

onready var player = get_node("/root/Test_World/Player")
onready var flyEnemy = $TestEnemy1
#onready var player = get_node("/root/MainScene/TextureRect/Player")
onready var explode = $explode
onready var hit_box = $TestEnemy1/Hitbox/CollisionShape2D


var movementSpeed = 185

var direction = Vector2()
var stun = false
var hp = 5
 

func _ready():
	player.connect("explosive",self,"self_destruction")
	explode.hide()
	
	
func _physics_process(delta):
	#if player:
		#var direction = (player.position - position).normalized()
		#move_and_slide(direction * movementSpeed)
	if player and stun == false:
		direction = global_position.direction_to(player.global_position)
		move_and_collide(direction * movementSpeed * delta)
	elif stun:
		direction = lerp(direction, Vector2(0, 0), 0.3)
	
	
	
	
	
	_flip_face()
	
# Facing Towards Player
func _flip_face():
	if player.global_position.x > flyEnemy.global_position.x:
		flyEnemy.set_flip_h(true)
	else:
		flyEnemy.set_flip_h(false)

func _on_deathoffscreen_screen_exited():
	queue_free()





# Hitting With Bullet
func _on_Hitbox_area_entered(area):
	if area.is_in_group("EnemyDamager") and stun == false:
		modulate = Color("ff0000")
		direction = -direction * 4
		hp -= 1
		if hp <= 0:
			OnDeath()
			Caption.points += 1
		stun = false
		$Stun_timer.start()
		area.get_parent().queue_free()

# Stun Timer
func _on_Stun_timer_timeout():
	modulate = Color("ffffff")
	stun = false


func _on_explode_animation_finished():
	queue_free()


func OnDeath():
	#hit_box.disabled = true
	get_node("TestEnemy1/Hitbox/CollisionShape2D").set_deferred("disabled", true)
	movementSpeed = 0
	explode.show()
	explode.play("explode")
	
func self_destruction():
	OnDeath()
