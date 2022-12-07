extends Node2D

export(String) var title
export(Resource) var dialogue
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	DialogueManager.show_example_dialogue_balloon(title, dialogue)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
