extends KinematicBody2D


var velocity = Vector2(0,0)
var speed = 300
onready var sprite = $Sprite
onready var anim_player = $AnimationPlayer

func _ready():
	var mouse_pos = get_global_mouse_position()

func _physics_process(delta):
#	velocity = velocity.move_toward(mouse_pos, delta)
#	velocity = velocity.normalized() * speed
#	position = position + velocity
	var collision_info = move_and_collide(velocity.normalized() * delta * speed)
	anim_player.play("viaje")
	
	if collision_info:
		queue_free()
func on_timer_timeot():
	queue_free()
