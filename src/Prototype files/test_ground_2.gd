extends Sprite

signal block_has_leave_vp




func _ready():
	connect("block_has_leave_vp", Global.world, "block_create_time")






func _on_Area2D_area_entered(area):
	emit_signal("block_has_leave_vp")
	queue_free()

