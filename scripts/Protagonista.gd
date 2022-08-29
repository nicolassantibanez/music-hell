extends KinematicBody2D

var velocity = Vector2()
var ACCELERATION = 100
var SPEED = 200
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	var horizontal_move_input = Input.get_axis("move_left", "move_right")
	var vertical_move_input = Input.get_axis("move_up","move_down")
	velocity.x = horizontal_move_input * SPEED
	velocity.y = vertical_move_input * SPEED
	velocity = move_and_slide(velocity, Vector2.UP)
