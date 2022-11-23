extends KinematicBody2D

onready var bullet_scene = preload("res://scenes/notas/nota_morada_1.tscn")

var hp: int = 50
var fire_activated = true

var player = null
const DEBUG_MODE = true


onready var timer = get_node("Timer")
onready var protagonista = $"%Protagonista"
onready var area_2d = $Area2D

var _idle_count = 0
var attack_period = 2
const attack_types = ["left_attack" , "right_attack", "front_attack"]
var attack_set = attack_types
onready var animation_tree = $AnimationTree


func _ready():
	randomize() # Para randomizar los ataques
	area_2d.connect("body_entered", self, "_on_Area2D_body_entered")
	area_2d.connect("body_exited", self, "_on_Area2D_body_exited")
	timer.connect("timeout", self, "_on_Timer_timeout")

func _physics_process(delta):
	pass

func increase_idle_count():
	_idle_count += 1
	if DEBUG_MODE: print("SE AUMENTA EL IDLE", _idle_count)
	if _idle_count > attack_period:
		_idle_count = 0
		attack()

func attack():
	var attack = attack_set[randi() % attack_set.size()]
	if DEBUG_MODE: print(attack)
	animation_tree.set_condition(attack, true)




# Ver las clase del viernes 
func _on_Area2D_body_entered(body:Node):
	if body != self and body == protagonista:
		player = body
		 

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

