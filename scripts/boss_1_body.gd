extends KinematicBody2D

onready var bullet_scene = preload("res://scenes/notas/nota_morada_1.tscn")

var hp: int = 20
var total_hp = hp
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
onready var patron_radial = $PatronRadial

# Para la barra de vida
onready var health_bar = $HealthBar

var primera_vez = true
signal spawn_points_changed()

func _ready():
	randomize() # Para randomizar los ataques
	area_2d.connect("body_entered", self, "_on_Area2D_body_entered")
	area_2d.connect("body_exited", self, "_on_Area2D_body_exited")
	timer.connect("timeout", self, "_on_Timer_timeout")
	health_bar.value = hp
	health_bar.max_value = hp
	_fin_media_vida()

func _physics_process(delta):
	pass

func increase_idle_count():
	_idle_count += 1
	if DEBUG_MODE: print("SE AUMENTA EL IDLE", _idle_count)
	
	if hp <= total_hp/2 and primera_vez:
		primera_vez = false
		_idle_count = 0
		animation_tree.set_condition("half_life", true)
	
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

func _inicio_media_vida():
	print("SE INICIA EL ATAQUE DE MITAD DE VIDA")
	fire_activated = false
	patron_radial.rotate_speed = 100
	patron_radial.periodo = 0.2
	patron_radial.spawn_points = 10
	emit_signal("spawn_points_changed")
	
func _fin_media_vida():
	fire_activated = true
	patron_radial.rotate_speed = 5
	patron_radial.periodo = 1
	patron_radial.spawn_points = 6
	emit_signal("spawn_points_changed")
	print("SE FINALIZA EL ATAQUE DE MITAD DE VIDA")

func take_damage(dmg_to_take:int):
	print("enemigo recibe daño: ", dmg_to_take)
	hp -= dmg_to_take
	health_bar.value = hp
	if hp <= 0:
		animation_tree.set_condition("death", true)
#		queue_free()

func queque_free2():
	queue_free()
