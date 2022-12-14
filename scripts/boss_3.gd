extends KinematicBody2D


onready var bullet_scene = preload("res://scenes/notas/nota_morada_1.tscn")
onready var minion_scene = preload("res://scenes/enemy_1.tscn")

var hp: int = 20
var total_hp = hp
var fire_activated = true

var player = null
const DEBUG_MODE = true

var bullet_counter = 0
const big_bullet = 10

# Para los ataques especiales
var _idle_count = 0
var movement_period = 4
const movement_types = ["counterclockwise", "clockwise"]
var movement_set = movement_types

onready var patron_recto = $PatronRecto
onready var patron_radial = $PatronRadial
onready var patron_aleatorio = $PatronAleatorio
var patrones = [patron_radial, patron_aleatorio]

onready var timer = get_node("Timer")
onready var protagonista = $"%Protagonista"
onready var area_2d = $Area2D
onready var health_bar = $HealthBar
onready var animation_tree = $AnimationTree
var rng = RandomNumberGenerator.new()

var half_life = false

var fire_time: float = 1.0
signal boss_muere

func _ready():
	patron_aleatorio.fire = false
	patron_recto.fire = true
	patron_radial.fire = false
	rng.randomize()
	randomize() # Para randomizar los ataques
	area_2d.connect("body_entered", self, "_on_Area2D_body_entered")
	area_2d.connect("body_exited", self, "_on_Area2D_body_exited")
	timer.connect("timeout", self, "_on_Timer_timeout")
	health_bar.value = hp
	health_bar.max_value = hp
	
func _on_Area2D_body_entered(body:Node):
	if body != self and body == protagonista:
		player = body
	
	 
func _on_Area2D_body_exited(body):
	if body != self and body == protagonista:
		player = null


func increase_idle_count():
	if DEBUG_MODE: print("SE AUMENTA EL IDLE", _idle_count)
	if _idle_count == 0:
		attack()
	
	if _idle_count == movement_period - 1:
		animation_tree.set_condition("multiple_attack", true)
	
	if _idle_count > movement_period:
		_idle_count = 0
		move()
	_idle_count += 1
		
func multiple_attack():
	for i in range(7):
		var bullet = bullet_scene.instance()
		bullet.position = get_global_position() + Vector2(rng.randi_range(-50, 50), rng.randi_range(-50, 50))
		bullet.player = player
		get_parent().add_child(bullet)
	
func activate_pattern():
	var patron = randi() % patrones.size()
	if patron == 0: 
		patron_radial.fire = true
	else:
		patron_aleatorio.fire = true

func deactivate_pattern():
	patron_radial.fire = false
	patron_aleatorio.fire = false
	
func attack():
	pass

func move():
	var movement = movement_set[randi() % movement_set.size()]
	if DEBUG_MODE: print(movement)
	animation_tree.set_condition(movement, true)
	
	
func _fire():
	var bullet = bullet_scene.instance()
	if bullet_counter == big_bullet:
		bullet_counter = 0
		bullet.scale = Vector2(4, 4)
	bullet.position = get_global_position()
	bullet.player = player
	get_parent().add_child(bullet)
	bullet_counter += 1
	timer.set_wait_time(fire_time)
	
func _on_Timer_timeout():
	if player != null and fire_activated:
		_fire()

func take_damage(dmg_to_take:int):
	print("enemigo recibe daño: ", dmg_to_take)
	hp -= dmg_to_take
	health_bar.value = hp
	if hp < total_hp/2 and not half_life:
		animation_tree.set_condition("half_life", true)	
	if hp <= 0:
		animation_tree.set_condition("death", true)

func queque_free2():
	emit_signal("boss_muere")
	queue_free()

