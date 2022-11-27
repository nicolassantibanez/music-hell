extends CanvasLayer

signal faded

onready var animation_player = $AnimationPlayer



func fade_out():
	animation_player.play("fade_out")
	yield(animation_player, "animation_finished")
	emit_signal("faded")

func fade_in():
	animation_player.play("fade_in")
	yield(animation_player, "animation_finished")
	emit_signal("faded")
