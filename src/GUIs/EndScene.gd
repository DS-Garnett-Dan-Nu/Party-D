extends CanvasLayer

#Load da Scenes!
var mainmenu = "res://scn/GUIs/Mainmenu.tscn"

#Misc Vars
var is_paused = false setget set_is_paused
var time_sec = 0
var time_min = 0
var time_hrs = 0


#Nodes
onready var stayPoints = $stayK
onready var flyPoints = $flyK
onready var totalScore = $score
onready var TS = $TS
onready var tstimer = $TimeSurvivedTimer

func _ready():
	hide()

func set_is_paused(value):
	is_paused = value
	get_tree().paused = is_paused

func _on_mainmenu_pressed():
	self.is_paused = false
	get_tree().change_scene(mainmenu)

func _on_restart_pressed():
	self.is_paused = false
	get_tree().reload_current_scene()

func _on_exit_pressed():
	self.is_paused = false
	get_tree().quit()


func _process(delta):
	
	#Kill Score
	stayPoints.text = "X " + String(Caption.stayEnemyPoints)
	flyPoints.text = "X " + String(Caption.points)
	
	#Total Score
	totalScore.text = "Total Score: " + String(Caption.points + Caption.stayEnemyPoints)
	
	#Time Survived
	TS.ALIGN_CENTER
	
	TS.text = "Time Survived: " + String(time_sec) + " sec"
	
	#If player have survived pass over 60 sec
	if time_min > 0:
		TS.text = "Time Survived: " + String(time_min) + " min, " + String(time_sec) + " sec"
	
	#If player have survived pass over 60 min I don't know...
	if time_hrs > 0:
		TS.text = "Time Survived: " + String(time_hrs) + " hrs, " + String(time_min) + " min, " + String(time_sec) + " sec"
		



func _on_Player_playerIsDead():
	show()
	tstimer.stop()
	$BGM.play()
	self.is_paused = true


func _on_TimeSurvivedTimer_timeout():
	#Time Survived Calculator
	time_sec += 1
	if time_sec == 60:
		time_min += 1
		time_sec = 0
	if time_min == 60:
		time_hrs += 1
		time_min = 0
		
	print(time_sec)


func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		if tstimer.is_stopped() == false:
			tstimer.stop()
		else:
			tstimer.start()


func _on_continue_pressed():
	tstimer.start()
