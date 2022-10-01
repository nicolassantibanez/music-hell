extends KinematicBody2D

onready var bullet_scene = preload("res://scenes/notas/nota_morada_1.tscn")

var player = null
var move = Vector2.ZERO
var speed = 1
onready var timer = get_node("Timer")


func _physics_process(delta):
	move = Vector2.ZERO
	if player:
		move = position.direction_to(player.position) * speed
	else:
		move = Vector2.ZERO
		
	move = move.normalized()
	move = move_and_collide(move)

func _on_Area2D_body_entered(body):
	if body != self:
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
	if player != null:
		_fire()

