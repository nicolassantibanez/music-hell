extends MarginContainer

onready var back = $VBoxContainer/Back



func _ready():
	visible = false
	back.connect("pressed", self, "_on_back_pressed")


func _on_back_pressed():
	pass
