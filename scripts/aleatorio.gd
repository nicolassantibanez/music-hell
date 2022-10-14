extends Node2D

const bullet_scene = preload("res://scenes/notas/nota_roja_1.tscn")
onready var shoot_timer = $SpawnTimer
onready var rotater = $Rotater

var rng = RandomNumberGenerator.new()

var rotate_speed: float = 0
var periodo: float = 1
var spawn_points: int = 150
export var radius: float = 10
export var umbral: float = 0.5

func _ready():
	rng.randomize()
	var step = 2 * PI /spawn_points
	
	for i in range(spawn_points):
		var spawn_point = Node2D.new()
		var pos = Vector2(radius, 0).rotated(step * i)
		spawn_point.position = pos
		spawn_point.rotation = pos.angle()
		rotater.add_child(spawn_point)
		
	shoot_timer.wait_time = periodo
	shoot_timer.start()
	
	

func _process(delta):
	var new_rotation = rotater.rotation_degrees + rotate_speed * delta
	rotater.rotation_degrees = fmod(new_rotation, 360)
	


func _on_SpawnTimer_timeout():
	for s in rotater.get_children():
		var posibility = rng.randf() 
		if posibility < umbral:
			var bullet = bullet_scene.instance()
			get_tree().root.add_child(bullet)
			bullet.position = s.global_position
			bullet.rotation = s.global_rotation
		
	shoot_timer.wait_time = rng.randf_range(0.1, 4.0)
	shoot_timer.start()
