extends Node2D

func _ready():
	LivesCounter.lives=5
	$DeathLive2.hide()
	$DeathLive3.hide()
	$DeathLive4.hide()
	$DeathLive5.hide()
	
	if LivesCounter.lives==4:
		$DeathLive5.show()
		
	if LivesCounter.lives==3:
		$DeathLive4.show()
		
	if LivesCounter.lives==2:
		$DeathLive3.show()
		
	if LivesCounter.lives==1:
		$DeathLive2.show()
		
	if LivesCounter.lives==0:
	# when killed
		get_tree().reload_current_scene()
