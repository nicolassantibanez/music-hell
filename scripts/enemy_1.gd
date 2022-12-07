extends KinematicBody2D

onready var bullet_scene = preload("res://scenes/notas/nota_morada_1.tscn")

export var hp: int = 2
export (bool) var fire_activated = true
export (float) var stop_distance = 50.0

var player = null
var move = Vector2.ZERO
export var speed: float = 1
onready var timer = get_node("Timer")
onready var protagonista = $"%Protagonista"

func _ready():
	pass

func _physics_process(delta):
	move = Vector2.ZERO
	if is_instance_valid(player) and (position - player.position).length() > stop_distance:
		print("Distancia: ", (position - player.position).length())		
		move = position.direction_to(player.position) * speed
		
	move = move.normalized()
	move = move_and_collide(move)


# Ver las clase del viernes 
func _on_Area2D_body_entered(body:Node):
	if body != self and body == protagonista:
		print("Veo al protagonista!!!")
		player = body
	print("Veo algo:", body)
		 


func _on_Area2D_body_exited(body):
	if body != self and body == protagonista:
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

func take_damage(dmg_to_take:int):
	print("enemigo recibe daño: ", dmg_to_take)
	hp -= dmg_to_take
	if hp <= 0:
		queue_free()
