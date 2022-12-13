extends Node2D

# Constant variables
const ENEMY_PATH = preload("res://scenes/enemy_1_level01.tscn")

# Exported variables
export(int) var enemies_to_spawn = 3

# Public variables
var current_enemies = 0

# Private variables
var _player_entered = false

# Onready variables
onready var room_area2d = $RoomArea2D
onready var enemies_spawn_shape = $EnemiesSpawnArea2D/CollisionShape2D
onready var protagonista = $"%Protagonista"
onready var gates = [$LeftGate, $RightGate]

# Called when the node enters the scene tree for the first time.
func _ready():
	_open_gates()
	room_area2d.connect("body_entered", self, "_on_room_area2d_body_entered")
	room_area2d.connect("body_exited", self, "_on_room_area2d_body_exited")

func _process(delta):
	if current_enemies == 0:
		_open_gates()

func _spawn_enemies():
	for i in range(enemies_to_spawn):
		var room_x = enemies_spawn_shape.shape.extents.x
		var room_y = enemies_spawn_shape.shape.extents.y
		var spawn_pos = Vector2(rand_range(-room_x, room_x) + global_position.x, rand_range(-room_y, room_y) + global_position.y)
		var enemy = ENEMY_PATH.instance()
		enemy.position = spawn_pos
		get_parent().add_child(enemy)
		enemy.protagonista = self.protagonista
		current_enemies += 1

func _open_gates():
	for gate in gates:
		gate.open_gate()

func _close_gates():
	for gate in gates:
		gate.close_gate()

func _on_room_area2d_body_entered(body: Node):
	if body == protagonista and not _player_entered:
		# Cerramos las puertas del room
		_player_entered = true
		_close_gates()
		_spawn_enemies()

func _on_room_area2d_body_exited(body: Node):
	if body != protagonista and body.has_method("take_damage"):
		current_enemies -= 1
