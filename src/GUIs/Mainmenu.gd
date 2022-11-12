extends Node2D


var maingame = "res://scn/prototype_files/Test_World.tscn"
onready var arcademenu = $ArcadeMenu/CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	arcademenu.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_TextureButton_pressed():
	pass # Replace with function body.







func _on_exit_pressed():
	get_tree().quit()


func _on_Acade_pressed():
	arcademenu.show()
