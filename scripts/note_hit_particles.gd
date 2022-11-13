extends CPUParticles2D

var is_init = false

# Called when the node enters the scene tree for the first time.
func _ready():
	is_init = true

func _process(delta):
	if self.is_emitting() == false:
		queue_free()
