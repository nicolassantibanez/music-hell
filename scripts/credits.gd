extends Node2D

onready var back = $Button
onready var animation_player = $AnimationPlayer


func _ready():
	back.connect("pressed", self, "_on_back_pressed")
	animation_player.play("slide")


func _on_back_pressed():
	get_tree().change_scene("res://scenes/ui/main_menu.tscn")

