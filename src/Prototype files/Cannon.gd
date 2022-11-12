extends RigidBody2D





func _on_Cannon_body_entered(body):
	if !body.is_in_group("player"):
		queue_free()


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
