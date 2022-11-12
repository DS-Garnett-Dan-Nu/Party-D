extends Node2D

onready var arcademenu = $CanvasLayer

var survival = "res://scn/Worlds/Survival_World.tscn"

func _ready():
	arcademenu.hide()
	

func _on_survival_pressed():
	get_tree().change_scene(survival)


func _on_Back_pressed():
	arcademenu.hide()
