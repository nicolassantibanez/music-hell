tool
extends Area2D

export(bool) var pressed setget set_pressed
export(Color) var color

onready var sprite = get_node("Sprite")
onready var collision_shape = get_node("CollisionShape2D")

func set_pressed(value:bool) -> void:
	pressed = value


func _ready():
	print(collision_shape.shape.extents)
	pass


func _process(delta):
	if pressed:
		sprite.modulate = lerp(modulate, color, 1.0)
		sprite.scale.y = lerp(scale.y, 0.95, 1.0)
		sprite.scale.x = lerp(scale.x, 0.95, 1.0)
	else:
		sprite.modulate = lerp(modulate, Color.gray, delta * 10.0)
		sprite.scale.y = lerp(scale.y, 1.0, delta * 10.0)
		sprite.scale.x = lerp(scale.x, 1.0, delta * 10.0)
