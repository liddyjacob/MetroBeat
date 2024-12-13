extends Control

var rel_position = 0
var raw_audio_data = Array()
var amp_audio_data = Array()
var playback_position = 0
var beat_array = Array()
const DELTA = .001


@onready
var audio_stream = get_node("MusicPlayer")
@onready
var streams_node = $"Streams"
@onready
var metronome = $"Metronome"
@onready
var sound_box = $"SoundBox"
@onready
var mode = $"Mode"
@onready
var BPMTextEditor = $"BPMAnnotator/TextEdit"

#

# add a beat to the track
func add_beat(rel_position):
	beat_array.append(rel_position)
	beat_array.sort()
	for stream_node in streams_node.get_children():
		stream_node.add_beat(rel_position)

func highlight_beat(rel_position):
	print("Highlighting beat at  " + str(rel_position))

func remove_beat(rel_position):
	beat_array.erase(rel_position)
	for stream_node in streams_node.get_children():
		stream_node.remove_beat(rel_position)

# Binary search for next beat
func get_next_beat():
	if beat_array.size() == 0 or (rel_position > beat_array[-1]):
		return null
	return beat_array[beat_array.bsearch(rel_position, false)]
	
func get_beat_ids_in_range(rel_start, rel_end):
	if (beat_array.size() == 0) or (rel_start > beat_array[-1]) or (rel_end < beat_array[0]) :
		return null
	
	var start_position = beat_array.bsearch(rel_start, false)
	var end_position = beat_array.bsearch(rel_end, false)
			
	return Vector2(start_position, end_position)
	
func stop():
	playback_position = audio_stream.get_playback_position()
	audio_stream.stop()

func play():
	audio_stream.play(playback_position)

func is_playing():
	return audio_stream.is_playing()

func toggle_playback():
	# If playing, stop
	if audio_stream.has_stream_playback():
		stop()
	else:
	# If not playing, play
		play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if audio_stream.stream:
		if audio_stream.has_stream_playback():
			playback_position = audio_stream.get_playback_position()
		rel_position = playback_position / audio_stream.stream.get_length()
		
		# Binary search for next beat
		var closest_next_beat = get_next_beat()
		# Calculate the number of seconds until the next beat
		
		# Emit percuss signal in x seconds
		if closest_next_beat:
			var sec_remaining = audio_stream.stream.get_length() * (closest_next_beat - rel_position) 
			if sec_remaining < .025:
				metronome.percuss_in(sec_remaining)

# Set the position that we are in the song
func set_playback_to(rel_pos):
	print(rel_pos)
	playback_position = rel_pos * audio_stream.stream.get_length()
	print(playback_position)
	if audio_stream.has_stream_playback():
		audio_stream.seek(playback_position)

func _ready():
	# Build wave instance
	
	# load instance up with data
	var audio_data_file = FileAccess.open('res://output.txt', FileAccess.READ)
	var line = audio_data_file.get_line()
	raw_audio_data = Array()
	while line:
		raw_audio_data.append(str_to_var(line))
		line = audio_data_file.get_line()
	
	var small_raw_audio_data = []
	var target_reduction = 8
	for index in range(0, ceil(raw_audio_data.size() / target_reduction)):
		var threshold = min(target_reduction, raw_audio_data.size() - index*target_reduction )
		var app_value = 0
		for j in range(0, threshold):
			app_value = app_value + raw_audio_data[index*target_reduction + j] / float(threshold)
		small_raw_audio_data.append(app_value)
			
	#raw_audio_data = small_raw_audio_data
	
	# Update data and draw
	#CloseUpDrawArea.update_wave_data(raw_audio_data)
	
	var audio_amp_file = FileAccess.open('res://amp.txt', FileAccess.READ)
	line = audio_amp_file.get_line()
	amp_audio_data = Array()
	while line:
		amp_audio_data.append(str_to_var(line))
		line = audio_amp_file.get_line()

	var data_sources = {
		"raw": raw_audio_data,
		"amp": amp_audio_data,
	}
	
	for stream_node in streams_node.get_children():
		stream_node.load_data_stream(data_sources[stream_node.data_source])
		stream_node.initialize_defaults()

func report_hover(hover_rel_position):
	for stream_node in streams_node.get_children():
		stream_node.show_line_marker(hover_rel_position)

func hide_hover():
	for stream_node in streams_node.get_children():
		stream_node.hide_line_marker()

func report_empty_press_event(press_rel_position):
	add_beat(press_rel_position)
	metronome.percuss()
	
func report_annotated_press_event(press_rel_position):
	if mode.is_annotate():
		remove_beat(press_rel_position)
		sound_box.delete_sound()
	if mode.is_select():
		highlight_beat(press_rel_position)
		
	
func beat_focus(rel_position):
	for stream_node in streams_node.get_children():
		stream_node.focus_beat(rel_position)
		
func beat_unfocus(rel_position):
	for stream_node in streams_node.get_children():
		stream_node.unfocus_beat(rel_position)


func slight_reverse():
	if rel_position < DELTA:
		set_playback_to(0)
	else:
		set_playback_to(rel_position - DELTA)
	
func slight_forward():
	if 1 - rel_position < DELTA:
		set_playback_to(1)
	else:
		set_playback_to(rel_position + DELTA)

func _input(event):
	if ! BPMTextEditor.has_focus():
		if Input.is_key_pressed(KEY_A):
			print("Annotate Mode.")
			mode.set_annotate()
			
		if Input.is_key_pressed(KEY_S):
			print("Select Mode.")
			mode.set_select()
			
		if Input.is_key_pressed(KEY_D):
			print("Drag Mode.")
			mode.set_drag()
			
		if Input.is_key_pressed(KEY_LEFT):
			slight_reverse()
			
		if Input.is_key_pressed(KEY_RIGHT):
			slight_forward()
			
		if Input.is_key_pressed(KEY_SPACE):
			toggle_playback()
