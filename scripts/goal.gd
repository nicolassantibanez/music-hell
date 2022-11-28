extends Area2D


export(PackedScene) var next_level

func _ready():
	connect("body_exited", self, "_on_body_entered")

func _on_body_entered(body: Node2D):
	Fade.fade_out()
	yield(Fade, "faded")
	get_tree().change_scene_to(next_level)
	Fade.fade_in()
	yield(Fade, "faded")
