extends KinematicBody2D

onready var player = get_node("/root/Test_World/Player")
onready var stayEnemy = $TestEnemy1
onready var explosion = $explosion
onready var hit_box = $TestEnemy1/Hitbox/CollisionShape2D
onready var col_box = $CollisionShape2D
onready var fire_attack = $TestEnemy1/Attack
onready var damageTimer = $DamageTimer
onready var damage_zone = $TestEnemy1/EnteringZone/CollisionShape2D



#export var wait_time = 0.8

const GRAVITY = 25
const FLOOR = Vector2(0,-1)

var damage = false
var velocity = Vector2()
var stun = false
var hp = 7



#signal explode_after_damage

func _ready():
	
	player.connect("explosive",self,"self_destruction")
	#player.connect("zone_entered",self,"spit_fire")
	#player.connect("zone_existed", self, "disabled_fire")
	#player.connect("stayEnemy_explode", self, "stayEnemy_destruction")
	explosion.hide()



func _physics_process(delta):
	velocity.y += GRAVITY
	velocity = move_and_slide(velocity,FLOOR)
	_flip_face()


	
	
func _flip_face():
	if player.global_position.x > stayEnemy.global_position.x:
		stayEnemy.flip_h = true
		fire_attack.rotation_degrees = 180
	elif player.global_position.x < stayEnemy.global_position.x:
		stayEnemy.flip_h = false
		fire_attack.rotation_degrees = 0
	else:
		pass
		
		
	



func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

#
#func _on_Hitbox_area_entered(area):
#	if area.is_in_group("EnemyDamager"):
#		area.get_parent().queue_free()

# Hitting with Bullet
func _on_Hitbox_area_entered(area):
	if area.is_in_group("EnemyDamager"):
		modulate = Color("ff0000")
		hp -= 1
		if hp <= 0:
			hit_box.set_deferred("disabled", true)
			explosion.show()
			explosion.play("explosion")
			Caption.stayEnemyPoints += 1
			
		stun = true
		$StunTimer.start()
		area.get_parent().queue_free()


func self_destruction():
	hit_box.set_deferred("disabled", true)
	explosion.show()
	explosion.play("explosion")
	

func _on_StunTimer_timeout():
	modulate = Color("ffffff")
	stun = false


func _on_explosion_animation_finished():
	queue_free()


#func spit_fire():
	#attack_ani.play("attack_ani")
	#damageTimer.start()
	#damage_zone.set_deferred("enabled", true)
	 
		#Caption.playerHp -= 1
		#emit_signal("explode_after_damage")
		#self_destruction()


#func stayEnemy_destruction():
	#hit_box.set_deferred("disabled", true)
	#explosion.show()
	#explosion.play("explosion")
	
	


#func _on_DamageTimer_timeout():
	#Caption.playerHp -= 1
#	if Caption.playerHp < 3 and Caption.playerHp > 0:
#		hit_box.set_deferred("disabled", true)
#		explosion.show()
#		explosion.play("explosion")
#	else:
#		pass


#func disabled_fire():
	#damage_zone.set_deferred("disabled", true)



