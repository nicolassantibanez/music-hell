extends KinematicBody2D


var velocity = Vector2(0,0)
var speed = 300
onready var sprite = $Sprite
onready var anim_player = $AnimationPlayer
onready var area = $Area2D
onready var protagonista = $"%Protagonista"
func _ready():
	var mouse_pos = get_global_mouse_position()
	sprite.modulate = Color(0, 0, 1)
	area.connect("body_entered", self, "_on_body_entered")

func _physics_process(delta):
#	velocity = velocity.move_toward(mouse_pos, delta)
#	velocity = velocity.normalized() * speed
#	position = position + velocity
	var collision_info = move_and_collide(velocity.normalized() * delta * speed)
	print(collision_info)
	anim_player.play("viaje")
	

func on_timer_timeot():
	queue_free()
	
func _on_body_entered(body: Node):
	if body.has_method("take_damage") and body != protagonista:
		body.take_damage()
		queue_free()
	else:
		queue_free()
