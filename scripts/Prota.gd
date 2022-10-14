extends KinematicBody2D

signal health_updated(health)
signal killed()

var velocity = Vector2()
var ACCELERATION = 10000
var SPEED = 100

export (float) var max_health = 100

onready var health = max_health setget _set_health

onready var pivot = $Pivot
onready var anim_player = $AnimationPlayer
onready var anim_tree = $AnimationTree
onready var playback = anim_tree.get("parameters/playback")
onready var rhythm_sys = $"%RhythmSystem"

const bulletPath = preload("res://scenes/notas/corchea_azul.tscn")

func _ready():
	anim_tree.active = true
	if rhythm_sys != null:
		rhythm_sys.connect("note_hit", self, "_on_rhythm_system_note_hit")
		print("(debug) Rhythm System is connected!")
	else:
		print("(debug warning) Rhythm System is null")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# warning-ignore:unused_argument
func _physics_process(delta):
	velocity = move_and_slide(velocity, Vector2.UP)
	
	# movimiento
	var move_input = Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up","move_down")
	)

	velocity = velocity.move_toward(move_input * SPEED, ACCELERATION * delta)
	
	# Animacion
	if Input.is_action_pressed("move_right") and not Input.is_action_pressed("move_left"):
		pivot.scale.x = 1
	if Input.is_action_pressed("move_left") and not Input.is_action_pressed("move_right"):
		pivot.scale.x = -1
	if Input.is_action_just_released("move_down"):
		pivot.scale.x = 1
		playback.travel("idleDown")
	if Input.is_action_just_released("move_up"):
		pivot.scale.x = 1
		playback.travel("idleUp")	
	if Input.is_action_just_released("move_left") or Input.is_action_just_released("move_right"):
		playback.travel("idle")	
	
	if abs(velocity.x) > 20:
		playback.travel("run")
		
	if velocity.y < -20:
		playback.travel("runUp")
		
	if velocity.y > 20:
		playback.travel("runDown")

	$Node2D.look_at(get_global_mouse_position())



func shoot():
	var bullet = bulletPath.instance()
	get_parent().add_child(bullet)
	bullet.position = $Node2D/Position2D.global_position
	bullet.velocity = get_global_mouse_position() - bullet.position

# Puede haber un debuf cuando un contador llegue a cierto punto
func _on_rhythm_system_note_hit():
	if rhythm_sys != null:
		shoot()

func take_damage():
	print("Protagonista recibe daño")

func damage(amount):
	_set_health(health-amount)

func kill():
	pass

func _set_health(value):
	var prev_health = health
	health = clamp(value, 0 ,max_health)
	if health != prev_health:
		emit_signal("health_updated", health)
		if health==0:
			kill()
			emit_signal("killed")
