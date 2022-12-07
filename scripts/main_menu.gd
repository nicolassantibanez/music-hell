extends MarginContainer

onready var play = $VBoxContainer/PLay
onready var tutorial = $VBoxContainer/Tutorial
onready var credits = $VBoxContainer/HBoxContainer/Credits
onready var exit = $VBoxContainer/HBoxContainer/Exit


func _ready():
	play.connect("pressed", self, "_on_play_pressed")
	exit.connect("pressed", self, "_on_exit_pressed")
	credits.connect("pressed", self, "_on_credits_pressed")
	tutorial.connect("pressed", self, "_on_tutorial_pressed")

func _on_play_pressed():
	get_tree().change_scene("res://scenes/level_01_oficial.tscn")

func _on_credits_pressed():
	get_tree().change_scene("res://scenes/ui/credits.tscn")

func _on_tutorial_pressed():
	get_tree().change_scene("res://scenes/tutorial.tscn")

func _on_exit_pressed():
	get_tree().quit()

