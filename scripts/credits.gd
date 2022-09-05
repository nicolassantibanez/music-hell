extends MarginContainer

onready var back = $Button


func _ready():
	back.connect("pressed", self, "_on_back_pressed")


func _on_back_pressed():
	get_tree().change_scene("res://scenes/ui/main_menu.tscn")
