extends Area2D

onready var animation_player = $AnimationPlayer
onready var sprite = $Sprite
const SPEED = 100
var velocity = Vector2(0,0)

func _ready():
	sprite.modulate = Color(1, 0, 0)
	connect("body_entered", self, "_on_body_entered")

func _physics_process(delta):
	position += transform.x * SPEED * delta
	animation_player.play("viajeRoja1")
#	var collision_info = move_and_slide(velocity.normalized() * delta * speed)
#	animation_plater.play("viajeRoja1")
	
func _on_KillerTimer_timeout():
	queue_free()
	
func _on_body_entered(body: Node):
	queue_free()
