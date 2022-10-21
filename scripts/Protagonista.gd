extends KinematicBody2D

var velocity = Vector2()
var ACCELERATION = 10000
var SPEED = 100

onready var pivot = $Pivot
onready var anim_player = $AnimationPlayer
onready var anim_tree = $AnimationTree
onready var playback = anim_tree.get("parameters/playback")
onready var rhythm_sys = $"%RhythmSystem"
onready var invunerability_timer = $InvunerabilityTimer
onready var player_sprite = $Pivot/Sprite
onready var take_damage_sfx = $TakeDamageSFX

const bulletPath = preload("res://scenes/notas/corchea_azul.tscn")

func _ready():
	anim_tree.active = true
	if rhythm_sys != null:
		rhythm_sys.connect("note_hit", self, "_on_rhythm_system_note_hit")
		print("(debug) Rhythm System is connected!")
	else:
		print("(debug warning) Rhythm System is null")
	invunerability_timer.connect("timeout", self, "_on_invunerability_timer_tiemout")


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
	if invunerability_timer.is_stopped():
		take_damage_sfx.play()
		anim_player.play("damage")
		anim_player.queue("flash")
		invunerability_timer.start()
		LivesCounter.lives -= 1
		
func _on_invunerability_timer_tiemout():
	anim_player.play("rest")
	