#extends Sprite
extends KinematicBody2D

export(float) var expected_time
export(Color) var color setget set_color
export(float) var speed_y = 400.0
export(bool) var entered_catcher = false
export(bool) var is_in_catcher = false

var state = ""

onready var sprite:Sprite = get_node("Sprite")

func set_color(value:Color) -> void:
	color = value
	sprite.self_modulate = color

func test_hit() -> bool:
#func test_hit(time:float) -> bool:
#	if abs(expected_time - time) < 0.2:
#		return true
#	return false
	if (entered_catcher and is_in_catcher):
		return true
	return false

func test_miss() -> bool:
#func test_miss(time:float) -> bool:
#	if time > expected_time + 0.2:
#		return true
#	return false
#	if y_miss < self.global_position.y:
#		return true
#	return false
	if (entered_catcher and !is_in_catcher):
		return true
	return false

func hit(position_to_freeze:Vector2) -> void:
	state = "hit"
	global_position = position_to_freeze

func miss() -> void:
	state = "miss"

func _process(delta):
	if state == "hit":
		queue_free() # Elimina este nodo
		return
	
	# Velocidad de la nota
	global_position.y += delta * speed_y
	
	if state == "miss":
		if global_position.y > 600.0:
			queue_free()
