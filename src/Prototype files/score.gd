extends Label


func _process(delta):
	ALIGN_CENTER
	text = "Score: " + String(Caption.points + Caption.stayEnemyPoints)
