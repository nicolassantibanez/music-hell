extends Node2D

# Constant variables
const ENEMY_PATH = preload("res://scenes/enemy_1.tscn")

# Exported variables
export(int) var enemies_to_spawn = 3

# Public variables
var current_enemies = 0

# Private variables
var _player_entered = false

# Onready variables
onready var room_area2d = $RoomArea2D
onready var room_shape = $RoomArea2D/CollisionShape2D
onready var protagonista = $"%Protagonista"

# Called when the node enters the scene tree for the first time.
func _ready():
	room_area2d.connect("body_entered", self, "_on_room_area2d_body_entered")
	room_area2d.connect("body_exited", self, "_on_room_area2d_body_exited")

func _spawn_enemies():
	for i in range(enemies_to_spawn):
		var room_x = room_shape.shape.extents.x
		var room_y = room_shape.shape.extents.y
		var spawn_pos = Vector2(rand_range(-room_x, room_x) + global_position.x, rand_range(-room_y, room_y) + global_position.y)
		var enemy = ENEMY_PATH.instance()
		enemy.player = protagonista
		enemy.position = spawn_pos
		get_parent().add_child(enemy)
		current_enemies += 1

func _on_room_area2d_body_entered(body: Node):
	if body == protagonista and not _player_entered:
		# TODO: Cerramos las puertas del room
		_player_entered = true
		_spawn_enemies()

func _on_room_area2d_body_exited(body: Node):
	if body != protagonista and body.has_method("take_damage"):
		current_enemies -= 1
