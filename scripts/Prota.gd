extends KinematicBody2D

var velocity = Vector2()
var ACCELERATION = 100
var SPEED = 200

onready var pivot = $Pivot
onready var anim_player = $AnimationPlayer
onready var anim_tree = $AnimationTree
onready var playback = anim_tree.get("parameters/playback")


func _ready():
	anim_tree.active = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# warning-ignore:unused_argument
func _physics_process(delta):
	
	# movimiento
	var horizontal_move_input = Input.get_axis("move_left", "move_right")	
	var vertical_move_input = Input.get_axis("move_up","move_down")
	velocity.x = horizontal_move_input * SPEED
	velocity.y = vertical_move_input * SPEED
	velocity = move_and_slide(velocity, Vector2.UP)
	
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
	
