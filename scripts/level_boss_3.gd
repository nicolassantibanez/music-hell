extends Node2D


onready var boss_3 = $YSort/KinematicBody2D
onready var changer = $YSort/changer
onready var goal = $YSort/changer/Goal


func _ready():
	changer.visible = false
#	changer.hide()
	goal.collision_shape_2d.set_deferred("disabled", true)
	
	boss_3.connect("boss_muere", self, "_on_muerte_boss")
	
func _on_muerte_boss():
	goal.collision_shape_2d.set_deferred("disabled", false)
	changer.visible = true
