extends Area2D

# Esta nota sigue al jugador

const SPEED = 2
var move = Vector2.ZERO
var look_vec = Vector2.ZERO
var player = null
var _damage = 1
onready var sprite = $Sprite
onready var animation_player = $AnimationPlayer

func _ready():
	look_vec = player.position - global_position
	animation_player.play("viajeMorado")
#	sprite.modulate = Color(0.8, 0, 1)
	connect("body_entered", self, "_on_body_entered")
	
func _physics_process(delta):
	move = Vector2.ZERO
	move = move.move_toward(look_vec, delta)
	move = move.normalized() * SPEED
	position += move

func _on_body_entered(body: Node):
	if body.has_method("take_damage") and body.name == "Protagonista": # and no enemigo
		body.take_damage(self._damage)
		queue_free()
	if not body.has_method("take_damage"):
		queue_free()

