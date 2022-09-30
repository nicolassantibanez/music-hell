extends Node2D

# Signals
signal note_hit

# Exports
export (String, FILE, "*.mid") var midi_file:String = ""
export (String, FILE, "*.mp3, *.wav, *.ogg") var music_file:String = ""
export (int) var offset_midi:int = 5
export (String) var right_catcher_track:String = ""
export (PoolIntArray) var right_catcher_notes:PoolIntArray
export (String) var left_catcher_track:String = ""
export (PoolIntArray) var left_catcher_notes:PoolIntArray
export (int) var notes_spawn_height:int = -200
export (bool) var testing:bool = false
export (int) var seconds_to_print_test = 10

var delta_sum = 0.0
var played_notes:Dictionary = {}

onready var timer:Timer = get_node("Timer")
onready var music = get_node("AudioStreamPlayer")
onready var midi = get_node("MidiPlayer")

onready var note_catchers := {
#	36: {
	"left": {
		"color": Color.yellow,
		"key": "play_left",
		"node": get_node("Buttons/left_catcher"),
		"queue": [],
	},
#	38: {
	"right": {
		"color": Color.green,
		"key": "play_right",
		"node": get_node("Buttons/right_catcher"),
		"queue": [],
	},
}

# Called when the node enters the scene tree for the first time.
func _ready():
	for catcher in note_catchers.values():
		catcher.node.connect("body_entered", self, "_on_catcher_body_entered")
		catcher.node.connect("body_exited", self, "_on_catcher_body_exited")
	
	if testing:
		timer.set_wait_time(seconds_to_print_test)
		timer.connect("timeout", self, "_on_timer_timeout")
		timer.start()
		
	midi.set_file(midi_file)	# Se agrega el path del archivo .mid al midi player
	midi.connect("midi_event", self, "_on_midi_event")
	
	if File.new().file_exists(music_file):
		var sfx = load(music_file) 
		music.stream = sfx



func _process(delta):
	delta_sum += delta
	
	for s in note_catchers.values():
		if Input.is_action_just_pressed(s.key):
			if not s.queue.empty():
#				if s.queue.front().test_hit(delta_sum):
				if s.queue.front().test_hit():
					s.queue.pop_front().hit(s.node.global_position)
					print("hit")
					emit_signal("note_hit")
				else:
					print("TOO EARLY")
			else:
				print("WUT??")
				
		if not s.queue.empty():
			if s.queue.front().test_miss():
				s.queue.pop_front().miss()
				print("miss")

	for s in note_catchers.values():
		s.node.pressed = Input.is_action_pressed(s.key)
	
	if not midi.playing:
		midi.play()
	if delta_sum >= offset_midi and not music.playing:
		print("Playing midi!")
		music.play()
#		midi.play()

func _on_midi_event(channel, event):
	# Si estamos en "testing", iremos agregando las notas y tracks que
	# se han tocado, siempre y cuando sea un evento de note_on -> 144
	# o note_off -> 128.
	if testing and event.type == 144:
		_add_to_played_notes(channel.track_name, event.note)

	if channel.track_name == left_catcher_track and event.type == 144:
		var nota = event.note;
		if nota in left_catcher_notes or left_catcher_notes.empty():
			var catcher = note_catchers.get("left")
			_spawn_note_over_catcher(catcher)
	if channel.track_name == right_catcher_track and event.type == 144:
		var nota = event.note;
		if nota in right_catcher_notes or right_catcher_notes.empty():
			var catcher = note_catchers.get("right")
			_spawn_note_over_catcher(catcher)

func _spawn_note_over_catcher(catcher):
	if catcher:
		var play_note = preload("res://scenes/play_note.tscn").instance()
		add_child(play_note)
		play_note.expected_time     = delta_sum + 1.25
		play_note.speed_y = (catcher.node.global_position.y - notes_spawn_height) / offset_midi
		play_note.global_rotation   = catcher.node.global_rotation # Ver que hacer con esto, capaz no nos sirva
		play_note.global_position.y = notes_spawn_height;
		play_note.global_position.x = catcher.node.global_position.x
		play_note.color             = catcher.color
		catcher.queue.push_back(play_note)
	else:
		print("(debug) catcher ", catcher, " doesn't exist!")
	

func _on_timer_timeout():
	print("---> Tests results! <---")
	for track in played_notes.keys():
		print(track+":")
		for note in played_notes[track].keys():
			print("  -> Nota ", note, " : ", played_notes[track][note])
	
func _on_catcher_body_entered(body:Node):
	body.entered_catcher = true
	body.is_in_catcher = true
	print("El nodo ", body.name, " entró al Left Catcher!")

func _on_catcher_body_exited(body:Node):
	body.is_in_catcher = false

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

