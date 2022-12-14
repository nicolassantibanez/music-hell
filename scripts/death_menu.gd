extends MarginContainer


onready var give_up = $VBoxContainer/GiveUp
onready var continue_2 = $VBoxContainer/Continue2

onready var lives = $"../Lives"



func _ready():
	continue_2.connect("pressed", self, "_on_continue_pressed")
	give_up.connect("pressed", self, "_on_give_up_pressed")
	lives.connect("muere", self, "_on_muere")
	hide()

func _on_muere():
	visible = !visible
	get_tree().paused = visible

		
func _on_continue_pressed():
	hide()
	get_tree().paused = false
	print("sasasasasasas")
	get_tree().reload_current_scene()
	
func _on_give_up_pressed():
	LivesCounter.deaths = 0
	get_tree().paused = false
	print("sasasasasasas")
	
	get_tree().change_scene("res://scenes/ui/main_menu.tscn")
	
	
	
