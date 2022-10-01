extends Area2D

# Esta nota sigue al jugador

onready var animation_player = $AnimationPlayer
const SPEED = 2
var move = Vector2.ZERO
var look_vec = Vector2.ZERO
var player = null

func _ready():
	look_vec = player.position - global_position
	animation_player.play("viajeMorado")
	
func _physics_process(delta):
	move = Vector2.ZERO
	move = move.move_toward(look_vec, delta)
	move = move.normalized() * SPEED
	position += move


