tool
extends Area2D

export(bool) var pressed setget set_pressed
export(Color) var color
export(Texture) var custom_texture:Texture

onready var sprite = $Sprite
onready var collision_shape = get_node("CollisionShape2D")

func set_pressed(value:bool) -> void:
	pressed = value


func _ready():
	if custom_texture != null:
		sprite.texture = load(custom_texture.resource_path)
	print(collision_shape.shape.extents)
	pass


func _process(delta):
	if pressed:
		sprite.modulate = lerp(sprite.modulate, color, 1.0)
		sprite.scale.y = lerp(sprite.scale.y, 0.95, 1.0)
		sprite.scale.x = lerp(sprite.scale.x, 0.95, 1.0)
	else:
		sprite.modulate = lerp(sprite.modulate, Color.white, delta * 10.0)
		sprite.scale.y = lerp(sprite.scale.y, 1.0, delta * 10.0)
		sprite.scale.x = lerp(sprite.scale.x, 1.0, delta * 10.0)
