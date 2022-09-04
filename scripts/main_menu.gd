extends MarginContainer

onready var play = $VBoxContainer/PLay
onready var controls = $VBoxContainer/Controls
onready var credits = $VBoxContainer/HBoxContainer/Credits
onready var exit = $VBoxContainer/HBoxContainer/Exit


func _ready():
	play.connect("pressed", self, "_on_play_pressed")
	exit.connect("pressed", self, "_on_exit_pressed")
	credits.connect("pressed", self, "_on_credits_pressed")
	controls.connect("pressed", self, "_on_controls_pressed")

func _on_play_pressed():
	get_tree().change_scene("res://scenes/level_01.tscn")

func _on_credits_pressed():
	pass
	
func _on_controls_pressed():
	pass

func _on_exit_pressed():
	get_tree().quit()

