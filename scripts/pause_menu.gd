extends MarginContainer

onready var resume = $VBoxContainer/Resume
onready var restart = $VBoxContainer/HBoxContainer/Restart
onready var quit = $VBoxContainer/HBoxContainer/Quit
onready var vol = $VBoxContainer/vol

export var audio_bus_name := "Master"

onready var _bus := AudioServer.get_bus_index(audio_bus_name)
	
onready var value = 0




func _ready():
	
	resume.connect("pressed", self, "_on_resume_pressed")
	restart.connect("pressed", self, "_on_restart_pressed")
	quit.connect("pressed", self, "_on_quit_pressed")
	vol.connect("value_changed", self, "_on_value_changed")
	
	value = db2linear(AudioServer.get_bus_volume_db(_bus))
	hide()


func _on_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(_bus, linear2db(value))


# TODO: Hacer que cuando haga la pausa no se pare todo 


func _input(event):
	if event.is_action_pressed("menu"):
		visible = !visible
		get_tree().paused = visible

func _on_resume_pressed():
	hide()
	get_tree().paused = false
	
func _on_restart_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()
	



func _on_quit_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://scenes/ui/main_menu.tscn")
	
	
func _on_volume_value_changed(value: float):
	pass
#	AudioServer.set_bus_volume_db()
	
