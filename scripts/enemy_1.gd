extends KinematicBody2D

onready var bullet_scene = preload("res://scenes/notas/nota_morada_1.tscn")

export var hp: int = 2
export (bool) var fire_activated = true

var player = null
var move = Vector2.ZERO
export var speed: float = 1
onready var timer = get_node("Timer")
onready var protagonista = $"%Protagonista"

func _ready():
	pass

func _physics_process(delta):
	move = Vector2.ZERO
	if is_instance_valid(player):
		move = position.direction_to(player.position) * speed
	else:
		move = Vector2.ZERO
		
	move = move.normalized()
	move = move_and_collide(move)


# Ver las clase del viernes 
func _on_Area2D_body_entered(body):
	if body != self and body == protagonista:
		print(body)
		player = body
		 


func _on_Area2D_body_exited(body):
	player = null


func _fire():
	var bullet = bullet_scene.instance()
	bullet.position = get_global_position()
	bullet.player = player
	get_parent().add_child(bullet)
	timer.set_wait_time(1)
	
func _on_Timer_timeout():
	if player != null and fire_activated:
		_fire()

func take_damage():
	print("enemigo recibe daño")
	hp -= 1
	if hp <= 0:
		queue_free()
