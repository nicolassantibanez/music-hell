extends StaticBody2D

# Private variables
var _is_open = false

# Onready variables
onready var collision_shape = $CollisionShape2D
onready var sprite = $Sprite

func _ready():
	pass # Replace with function body.

func open_gate():
	_is_open = true
	collision_shape.set_deferred("disabled", true)
	# TODO: Hacemos animacion de abrir
	sprite.hide()

func close_gate():
	_is_open = false
	collision_shape.set_deferred("disabled", false)
	sprite.show()
	# TODO: Hacemos animacion de cerrar
