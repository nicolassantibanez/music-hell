extends Node2D

# Signals
signal note_hit(combo)
signal note_missed(combo)
signal too_many_misses()

var DEBUGG_MODE = false


const MISSES_TO_DEBUF = 5
const MAX_COMBO = 10
const HIT_PARTICLES_PATH = preload("res://scenes/note_hit_particles.tscn")

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
export (int) var left_many_notes_filter = 1
export (int) var right_many_notes_filter = 1
export (Texture) var left_play_note_texture
export (Texture) var right_play_note_texture

var delta_sum = 0.0
var played_notes:Dictionary = {}
var left_many_notes_counter = 0
var right_many_notes_counter = 0
var combo_count = 0 setget set_combo_count
var miss_count = 0

onready var timer:Timer = get_node("Timer")
onready var offset_timer:Timer = get_node("OffsetTimer")
onready var music = get_node("AudioStreamPlayer")
onready var midi = get_node("MidiPlayer")
onready var hit_sfx = $HitSFX
onready var miss_sfx = $MissSFX


onready var note_catchers := {
#	36: {
	"left": {
		"color": Color.yellow,
		"key": "play_left",
		"node": get_node("Buttons/left_catcher"),
		"play_note_texture": left_play_note_texture,
		"queue": [],
	},
#	38: {
	"right": {
		"color": Color.green,
		"key": "play_right",
		"node": get_node("Buttons/right_catcher"),
		"play_note_texture": right_play_note_texture,
		"queue": [],
	},
}

func set_combo_count(value:int):
	if value < 0:
		combo_count = 0
	elif value > MAX_COMBO:
		combo_count = MAX_COMBO
	else:
		combo_count = value

# Called when the node enters the scene tree for the first time.
func _ready():
	# Conectamos el timer para empezar la cancion en el instante correcto
	offset_timer.set_wait_time(offset_midi)
	offset_timer.connect("timeout", self, "_on_offset_timer_timeout")
	offset_timer.start()
	
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
					set_combo_count(combo_count + 1)
					miss_count = 0
					s.queue.pop_front().hit(s.node.global_position)
					_note_hit_feedback(s)
					if DEBUGG_MODE: print("hit, combo=", combo_count)
					emit_signal("note_hit", combo_count)
				else:
					set_combo_count(0)
					miss_count += 1
					_note_miss_feedback()
					if miss_count >= MISSES_TO_DEBUF:
						emit_signal("too_many_misses")
					emit_signal("note_missed", combo_count, miss_count)
					if DEBUGG_MODE: print("TOO EARLY")
			else:
				if DEBUGG_MODE: print("WUT??")
				
		if not s.queue.empty():
			if s.queue.front().test_miss():
				set_combo_count(combo_count - 1)
				s.queue.pop_front().miss()
				emit_signal("note_missed", combo_count, miss_count)
#				print("miss")

	for s in note_catchers.values():
		s.node.pressed = Input.is_action_pressed(s.key)
	
	if not midi.playing:
		midi.play()
#	if delta_sum >= offset_midi and not music.playing:
#		print("Playing midi!")
#		music.play()
##		midi.play()

func _on_midi_event(channel, event):
	# Si estamos en "testing", iremos agregando las notas y tracks que
	# se han tocado, siempre y cuando sea un evento de note_on -> 144
	# o note_off -> 128.
	if testing and event.type == 144:
		_add_to_played_notes(channel.track_name, event.note)

	if channel.track_name == left_catcher_track and event.type == 144:
		var nota = event.note;
		if left_many_notes_counter != 0:
			left_many_notes_counter = (left_many_notes_counter+1) % left_many_notes_filter
			return
		left_many_notes_counter = (left_many_notes_counter+1) % left_many_notes_filter
			
		if nota in left_catcher_notes or left_catcher_notes.empty():
			var catcher = note_catchers.get("left")
			_spawn_note_over_catcher(catcher)
	if channel.track_name == right_catcher_track and event.type == 144:
		var nota = event.note;
		if right_many_notes_counter != 0:
			right_many_notes_counter = (right_many_notes_counter+1) % right_many_notes_filter
			return
		right_many_notes_counter = (right_many_notes_counter+1) % right_many_notes_filter
		if nota in right_catcher_notes or right_catcher_notes.empty():
			var catcher = note_catchers.get("right")
			_spawn_note_over_catcher(catcher)

func _spawn_note_over_catcher(catcher):
	if catcher:
		var play_note = preload("res://scenes/play_note.tscn").instance()
		add_child(play_note)
		if catcher.play_note_texture != null:
			play_note.sprite.texture = catcher.play_note_texture
		play_note.expected_time     = delta_sum + 1.25
		play_note.speed_y = (catcher.node.global_position.y - notes_spawn_height) / offset_midi
		play_note.global_rotation   = catcher.node.global_rotation # Ver que hacer con esto, capaz no nos sirva
		play_note.global_position.y = notes_spawn_height;
		play_note.global_position.x = catcher.node.global_position.x
#		play_note.color             = catcher.color
		catcher.queue.push_back(play_note)
	else:
		if DEBUGG_MODE: print("(debug) catcher ", catcher, " doesn't exist!")
	

func _on_timer_timeout():
	if DEBUGG_MODE: print("---> Tests results! <---")
	for track in played_notes.keys():
		if DEBUGG_MODE: print(track+":")
		for note in played_notes[track].keys():
			if DEBUGG_MODE: print("  -> Nota ", note, " : ", played_notes[track][note])

func _on_offset_timer_timeout():
	if DEBUGG_MODE: print("Music Starting!")
	music.play()
	
func _on_catcher_body_entered(body:Node):
	body.entered_catcher = true
	body.is_in_catcher = true

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

func _note_hit_feedback(catcher):
	# SFX feedback
	hit_sfx.play()
	# Visual feedback
	var hit_particles = HIT_PARTICLES_PATH.instance()
	get_parent().add_child(hit_particles)
	hit_particles.color = catcher.color
	hit_particles.position = catcher.node.position
	hit_particles.emitting = true

func _note_miss_feedback():
	# SFX feedback
	miss_sfx.play()
