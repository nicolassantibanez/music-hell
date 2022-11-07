extends MarginContainer

onready var resume = $VBoxContainer/Resume
onready var restart = $VBoxContainer/Restart
onready var options = $VBoxContainer/HBoxContainer/Options
onready var quit = $VBoxContainer/HBoxContainer/Quit


func _ready():
	resume.connect("pressed", self, "_on_resume_pressed")
	restart.connect("pressed", self, "_on_restart_pressed")
	options.connect("pressed", self, "_on_options_pressed")
	quit.connect("pressed", self, "_on_quit_pressed")
	hide()


# TODO: Hacer que cuando haga la pausa no se pare todo 


func _input(event):
	if event.is_action_pressed("menu"):
		visible = !visible
		get_tree().paused = visible

func _on_resume_pressed():
	print("resume")
	hide()
	get_tree().paused = false
	
func _on_restart_pressed():
	print("restart")
	pass
	
func _on_options_pressed():
	print("options")
	pass
	
func _on_quit_pressed():
	print("quit")
	get_tree().change_scene("res://scenes/ui/main_menu.tscn")
	
