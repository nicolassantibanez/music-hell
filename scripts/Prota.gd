extends KinematicBody2D

export(NodePath) var viewport_container_node_path: NodePath
export(NodePath) var viewport_node_path: NodePath
onready var viewport_container: ViewportContainer = get_node(viewport_container_node_path)
onready var viewport: Viewport = get_node(viewport_node_path)

var velocity = Vector2()
var ACCELERATION = 10000
var SPEED = 100

onready var pivot = $Pivot
onready var anim_player = $AnimationPlayer
onready var anim_tree = $AnimationTree
onready var playback = anim_tree.get("parameters/playback")
onready var rhythm_sys = $"../../../ColorRect/RhythmSystem"

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


func _process(delta):
#	var mouse_pos = get_viewport().get_mouse_position()
#	print(mouse_pos)
#	$Node2D.look_at(mouse_pos)
#	print(root)
#	var mouse_pos = root.get_global_mouse_position() - get_viewport().canvas_transform.origin
#	var local_to_viewport: Transform2D = get_viewport_transform() * get_global_transform()
#	var viewport_to_local: Transform2D = local_to_viewport.affine_inverse()
###
##	var texture_to_viewport: Transform2D = viewport_container
##
##	var mouse_position_viewport: Vector2 = texture_to_viewport * viewport_container.get_local_mouse_position()
#	var mouse_position_viewport: Vector2 = viewport_container.get_local_mouse_position()
#
#	var mouse_position_local: Vector2 = viewport_to_local * mouse_position_viewport + global_position
#	var mouse_position_local = get_viewport_tran
#	var mouse_position = get_local_mouse_position()
	$Node2D.look_at(viewport_container.get_local_mouse_position())
	print("Mouse pos: ", viewport_container.get_local_mouse_position(), "; Player_pos: ", position)
	
	

#	$Node2D.look_at(get_global_mouse_position())
#	$Node2D.look_at(get_viewport().get_mouse_position())
#	var _scale_factor := OS.window_size / get_viewport().size
#	print(_scale_factor)
#	var _resolved_mpos := (get_global_mouse_position() - get_viewport().canvas_transform.origin) / _scale_factor
#	$Node2D.look_at(_resolved_mpos)
#	$Node2D.look_at(get_global_mouse_position() + get_local_mouse_position())


func shoot():
	var bullet = bulletPath.instance()
	get_parent().add_child(bullet)
	bullet.position = $Node2D/Position2D.global_position
	bullet.velocity = get_global_mouse_position() - bullet.position

# Puede haber un debuf cuando un contador llegue a cierto punto
func _on_rhythm_system_note_hit():
	if rhythm_sys != null:
		shoot()














