extends Control

#Load da Scenes!
var mainmenu = "res://scn/GUIs/Mainmenu.tscn"

#Misc Vars
var is_paused = false setget set_is_paused

#Nodes
onready var control = $control

# Called when the node enters the scene tree for the first time.
func _ready():
	control.visible = false

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		self.is_paused = !is_paused


func set_is_paused(value):
	is_paused = value
	get_tree().paused = is_paused
	control.visible = is_paused
	
	




func _on_mainmenu_pressed():
	get_tree().change_scene(mainmenu)
	self.is_paused = false


func _on_continue_pressed():
	self.is_paused = false


func _on_restart_pressed():
	self.is_paused = false
	get_tree().reload_current_scene()
