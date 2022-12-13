extends KinematicBody2D

# Ideas:
# - Que spawnee enemigos
# - Que dispare una nota mas grande

onready var bullet_scene = preload("res://scenes/notas/nota_morada_1.tscn")
onready var minion_scene = preload("res://scenes/enemy_1.tscn")

var hp: int = 20
var total_hp = hp
var fire_activated = true

var player = null
const DEBUG_MODE = true

var bullet_counter = 0
const big_bullet = 10

var _idle_count = 0
var attack_period = 2
const attack_types = ["movement_ne", "movement_nw", "movement_se", "movement_sw", "spawn_minions"]
var attack_set = attack_types

onready var patron_1 = $Patron1
onready var patron_2 = $Patron2
var patrones = [patron_1, patron_2]

onready var timer = get_node("Timer")
onready var protagonista = $"%Protagonista"
onready var area_2d = $Area2D
onready var health_bar = $HealthBar
onready var animation_tree = $AnimationTree
var rng = RandomNumberGenerator.new()

var move = Vector2.ZERO
export var speed: float = 1
var stop_distance = 90.0

var half_life = false

var fire_time: float = 1.0
signal spawn_points_changed()

func _ready():
	# para inicializar los patrones de ataque
	patron_1.rotate_speed = 100
	patron_1.periodo = 0.2
	patron_1.spawn_points = 1
	patron_1.fire = false
	
	patron_2.spawn_points = 60
	patron_2.rotate_speed = 0
	patron_2.periodo = 0.7
	patron_2.fire = false
	
	rng.randomize()
	randomize() # Para randomizar los ataques
	area_2d.connect("body_entered", self, "_on_Area2D_body_entered")
	area_2d.connect("body_exited", self, "_on_Area2D_body_exited")
	timer.connect("timeout", self, "_on_Timer_timeout")
	health_bar.value = hp
	health_bar.max_value = hp


func _physics_process(delta):
	if half_life:
		move = Vector2.ZERO
		if is_instance_valid(player) and (position - player.position).length() > stop_distance:
			# print("Distancia: ", (position - player.position).length())		
			move = position.direction_to(player.position) * speed	
		move = move.normalized()
		move = move_and_collide(move)


func _on_Area2D_body_entered(body:Node):
	if body != self and body == protagonista:
		player = body
		 
func _on_Area2D_body_exited(body):
	if body != self and body == protagonista:
		player = null


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
	
func spawn_minions():
	var minion_1 = minion_scene.instance()
	var minion_2 = minion_scene.instance()
	var minion_3 = minion_scene.instance()
	var minions = [minion_1, minion_2, minion_3]
	for minion in minions:
		minion.position = get_global_position() + Vector2(rng.randi_range(-50, 50), rng.randi_range(-50, 50))
		# TODO: ver como hacer que se muevan los minions
		get_parent().add_child(minion)

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

func activate_pattern():
	var patron = randi() % patrones.size()
	if patron == 0: 
		patron_1.fire = true
	else:
		patron_2.fire = true

func deactivate_pattern():
	patron_1.fire = false
	patron_2.fire = false

func half_life():
	patron_2.fire = true
	fire_time = 0.2
	half_life = true

func take_damage(dmg_to_take:int):
	print("enemigo recibe daño: ", dmg_to_take)
	hp -= dmg_to_take
	health_bar.value = hp
	if hp < total_hp/2:
		animation_tree.set_condition("half_life", true)
		
	if hp <= 0:
		animation_tree.set_condition("death", true)

func queque_free2():
	queue_free()




