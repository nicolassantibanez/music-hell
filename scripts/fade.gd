extends CanvasLayer

signal faded

onready var animation_player = $AnimationPlayer

func _ready():
	hide()

func fade_out():
	show()
	animation_player.play("fade_out")
	yield(animation_player, "animation_finished")
	emit_signal("faded")
	hide()

func fade_in():
	show()
	animation_player.play("fade_in")
	yield(animation_player, "animation_finished")
	emit_signal("faded")
	hide()
