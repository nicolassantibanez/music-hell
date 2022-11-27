extends Node2D

const bullet_scene = preload("res://scenes/notas/nota_roja_1.tscn")
onready var shoot_timer = $SpawnTimer
onready var rotater = $Rotater

export var rotate_speed: float = 0
export var periodo: float = 1
export var spawn_points: int = 60
export var radius: float = 10
export var fire: bool = true


func _ready():
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
	if fire:
		for s in rotater.get_children():
			var bullet = bullet_scene.instance()
			get_parent().get_parent().add_child(bullet)
			bullet.position = s.global_position
			bullet.rotation = s.global_rotation
