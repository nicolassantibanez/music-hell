extends Node2D

onready var death_counter = $DeathCounter
var deaths
var dead: bool = false

signal muere 

func _ready():
	deaths = LivesCounter.deaths
	death_counter.text = "x%d" % deaths
	LivesCounter.lives=5
	$DeathLive2.hide()
	$DeathLive3.hide()
	$DeathLive4.hide()
	$DeathLive5.hide()

func _process(delta):
	if LivesCounter.lives==4:
		$DeathLive5.show()
		
	if LivesCounter.lives==3:
		$DeathLive4.show()
		
	if LivesCounter.lives==2:
		$DeathLive3.show()
		
	if LivesCounter.lives==1:
		$DeathLive2.show()
		
	if LivesCounter.lives==0 and not dead:
		print("Lives: pasa algo")
		dead = true
		LivesCounter.lives = 5
		LivesCounter.deaths = LivesCounter.deaths + 1
		deaths = LivesCounter.deaths
		death_counter.text = "x%d" % deaths
		emit_signal("muere")
		# when killed
#		get_tree().reload_current_scene()
