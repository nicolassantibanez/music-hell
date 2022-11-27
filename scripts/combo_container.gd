extends Node2D

const CONTAINER_SIZE = 3

var fill_count = 0 setget _set_fill_count
var rng = RandomNumberGenerator.new()

onready var fill1:Sprite = $fill1
onready var fill2:Sprite = $fill2
onready var fill3:Sprite = $fill3
onready var fills = [fill1, fill2, fill3]

# Called when the node enters the scene tree for the first time.
func _ready():
	set_enable_fills(0)


#func _process(delta):
#    pass

func set_enable_fills(n: int):
	fill_count = n
	for i in range(CONTAINER_SIZE):
		if i < n:
			fills[i].visible = true
		else:
			fills[i].visible = false

func _set_fill_count(n):
	if n >= CONTAINER_SIZE:
		fill_count = CONTAINER_SIZE
	elif n < 0:
		fill_count = 0
	else:
		fill_count = n

