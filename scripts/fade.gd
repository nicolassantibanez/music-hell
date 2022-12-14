extends CanvasLayer

signal faded

onready var animation_player = $AnimationPlayer

func _ready():
	hide()

func fade_out():
	animation_player.play("fade_out")
	yield(animation_player, "animation_finished")
	emit_signal("faded")

func fade_in():
	animation_player.play("fade_in")
	yield(animation_player, "animation_finished")
	emit_signal("faded")
	
# No usada
func change_scene(scene: PackedScene):
	Fade.fade_out()
	yield(Fade, "faded")
	get_tree().change_scene_to(scene)
	Fade.fade_in()
	yield(Fade, "faded")
