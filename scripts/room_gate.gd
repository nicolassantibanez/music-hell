extends StaticBody2D

# Private variables
var _is_open = false

# Onready variables
onready var collision_shape = $CollisionShape2D
onready var sprite = $Sprite
onready var anim_player = $AnimationPlayer

func _ready():
	pass # Replace with function body.

func open_gate():
	if _is_open:
		return
	_is_open = true
	collision_shape.set_deferred("disabled", true)
	anim_player.play("open")
	yield(anim_player, "animation_finished")	
	anim_player.play("opened")
#	sprite.hide()

func close_gate():
	if not _is_open:
		return
	_is_open = false
	collision_shape.set_deferred("disabled", false)
	anim_player.play("close")
	yield(anim_player, "animation_finished")
	anim_player.play("closed")
#	sprite.show()
