extends Node2D

# Exports
export (String, FILE, "*.mid") var midi_file:String = ""
export (int) var offset_midi:int = 0
export (String) var right_catcher_track:String = ""
export (PoolIntArray) var right_catcher_notes:PoolIntArray
export (String) var left_catcher_track:String = ""
export (PoolIntArray) var left_catcher_notes:PoolIntArray
export (bool) var testing:bool = false
export (int) var seconds_to_print_test = 10

var delta_sum = 0.0
var played_notes:Dictionary = {}

onready var timer:Timer = get_node("Timer")
onready var music = get_node("AudioStreamPlayer")
onready var midi = get_node("MidiPlayer")

onready var note_catchers := {
	36: {
		"color": Color.yellow,
		"key": "move_left",
		"node": get_node("Buttons/left_catcher"),
		"queue": [],
	},
	38: {
		"color": Color.green,
		"key": "move_up",
		"node": get_node("Buttons/up_catcher"),
		"queue": [],
	},
}

# Called when the node enters the scene tree for the first time.
func _ready():
	if testing:
		timer.set_wait_time(seconds_to_print_test)
		timer.connect("timeout", self, "_on_timer_timeout")
		timer.start()
		
	midi.set_file(midi_file)	# Se agrega el path del archivo .mid al midi player
	midi.connect("midi_event", self, "_on_midi_event")



func _process(delta):
	delta_sum += delta
	
	for s in note_catchers.values():
		if Input.is_action_just_pressed(s.key):
			if not s.queue.empty():
				if s.queue.front().test_hit(delta_sum):
					s.queue.pop_front().hit(s.node.global_position)
					print("hit")
				else:
					print("TOO EARLY")
			else:
				print("WUT??")
				
		if not s.queue.empty():
			if s.queue.front().test_miss(delta_sum):
				s.queue.pop_front().miss()
				print("miss")

	for s in note_catchers.values():
		s.node.pressed = Input.is_action_pressed(s.key)
	
	if not midi.playing:
		midi.play()
	if delta_sum >= 1.25 and not music.playing:
		print("Playing midi!")
		music.play()
#		midi.play()

func _on_midi_event(channel, event):
	# Si estamos en "testing", iremos agregando las notas y tracks que
	# se han tocado, siempre y cuando sea un evento de note_on -> 144
	# o note_off -> 128.
	if testing and event.type == 144:
		_add_to_played_notes(channel.track_name, event.note)

	if channel.track_name == "Track 9" and event.type == 144:
		var nota = event.note;
		var s = note_catchers.get(nota)
		
#		if s and event.type == 1:
		if s:
			var i = preload("res://scenes/play_note.tscn").instance()
			add_child(i)
			i.expected_time     = delta_sum + 1.25
			i.global_rotation   = s.node.global_rotation
			i.global_position.y = -400
			i.global_position.x = s.node.global_position.x
			i.color             = s.color
			s.queue.push_back(i)
#		print("Nota: ", nota)

func _on_timer_timeout():
	print("---> Tests results! <---")
	for track in played_notes.keys():
		print(track+":")
		for note in played_notes[track].keys():
			print("  -> Nota ", note, " : ", played_notes[track][note])

func _add_to_played_notes(track:String, note:int):
	var track_dict = played_notes.get(track)
#	if track_dict and track_dict.has(note):
	if track_dict :
		if track_dict.has(note):
			played_notes[track][note] += 1
		else:
			played_notes[track][note] = 1
	else:
		played_notes[track] = {note: 1}

