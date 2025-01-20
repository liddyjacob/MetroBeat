extends Control

var rel_position = 0
var raw_audio_data = Array()
var amp_audio_data = Array()
var playback_position = 0
var beat_array = Array()
const DELTA = .001
var highlighted_beat = null
var tempo = null
var sounds_array = [] 
var sounds_dict = {}
var audio_file = ''


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
# Save the beats to a file
func savebeats():
	var file = FileAccess.open("user://" + audio_file + ".beats", FileAccess.WRITE)
	var array_as_string = ""
	for beat in beat_array:
		array_as_string = array_as_string + str(beat) + "\n"
	file.store_string(array_as_string)
	
	

# add a beat to the track
func add_beat(rel_position):
	beat_array.append(rel_position)
	beat_array.sort()
	for stream_node in streams_node.get_children():
		stream_node.add_beat(rel_position)
	
	savebeats()


func highlight_beat(beat_rel_position):
	highlighted_beat = beat_rel_position
	
	# Set estimated tempo based of last 5 beats:
	estimate_tempo()
	
	BPMTextEditor.text = str(tempo)
	
	
func remove_beat(rel_position):
	beat_array.erase(rel_position)
	for stream_node in streams_node.get_children():
		stream_node.remove_beat(rel_position)

	savebeats()

# Binary search for next beat
func get_next_beat():
	if beat_array.size() == 0 or (rel_position >= beat_array[-1]):
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
				metronome.percuss_in(max(0, sec_remaining - .004))

# Set the position that we are in the song
func set_playback_to(rel_pos):
	print(rel_pos)
	playback_position = rel_pos * audio_stream.stream.get_length()
	print(playback_position)
	if audio_stream.has_stream_playback():
		audio_stream.seek(playback_position)

func _load_tracks():
	var path = "res://music/"
	var dir = DirAccess.open(path)
	dir.list_dir_begin()
	while true:
		var file_name = dir.get_next()
		if file_name == "":
			#break the while loop when get_next() returns ""
			break
		elif !file_name.begins_with("."): 
			#get_next() returns a string so this can be used to load the images into an array.
			if !file_name.ends_with(".import"):
				sounds_array.append(file_name)
				sounds_dict[file_name] = AudioStreamOggVorbis.load_from_file(path + file_name)
									
	sounds_array.sort()
	dir.list_dir_end()
	
	for item in sounds_array:
		$SelectTrack.add_item(item) # Replace with function body.

func restart():
	audio_stream.stream = sounds_dict[audio_file]
	set_playback_to(0)

func rebuild_waveform():

	# load instance up with data
	var audio_data_file = FileAccess.open('res://wav.txt', FileAccess.READ)
	var line = audio_data_file.get_line()
	raw_audio_data = Array()
	while line:
		raw_audio_data.append(str_to_var(line))
		line = audio_data_file.get_line()
	
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
	
	
func _ready():
	# Build wave instance
	PhysicsServer2D.set_active(false)
	PhysicsServer3D.set_active(false)
	_load_tracks()
	#rebuild_waveform()

	

func report_hover(hover_rel_position):
	for stream_node in streams_node.get_children():
		stream_node.show_line_marker(hover_rel_position)

func hide_hover():
	for stream_node in streams_node.get_children():
		stream_node.hide_line_marker()

func report_empty_press_event(press_rel_position):
	if mode.is_annotate():
		add_beat(press_rel_position)
		metronome.percuss()
	
func report_annotated_press_event(press_rel_position):
	if mode.is_annotate():
		remove_beat(press_rel_position)
		sound_box.delete_sound()
	if mode.is_select():
		highlight_beat(press_rel_position)

# Repeats the spacing of the last <repeat_length> beats
func repeat_selected(repeat_length):
	if not highlighted_beat:
		return
	var position = beat_array.bsearch(highlighted_beat)
	if position < repeat_length:
		return
		
	for i in range(position - 8, position):
		var delta_to_next = beat_array[i+1] - beat_array[i]
		# Add it
		add_beat(highlighted_beat + delta_to_next)
		
		# Change the highlighted beat
		highlighted_beat = highlighted_beat + delta_to_next 
		
	# Move the time
	set_playback_to(highlighted_beat)	
	
func beat_focus(rel_position):
	for stream_node in streams_node.get_children():
		stream_node.focus_beat(rel_position)
		
func beat_unfocus(rel_position):
	for stream_node in streams_node.get_children():
		stream_node.unfocus_beat(rel_position)

func estimate_tempo():
	if not highlighted_beat:
		return
	var position = beat_array.bsearch(highlighted_beat)
	if position == 0:
		return
	
	var latest_beats = beat_array.slice(max(0, position - 4), position + 1)
	print(latest_beats)
	var distances = []
	for i in range(latest_beats.size() - 1):
		print(latest_beats[i + 1] - latest_beats[i])
		distances.append(latest_beats[i + 1] - latest_beats[i])
	
	var sum = func(a,b):
		return(a + b)
	
	print(distances)
	var total = distances[0]
	if distances.size() > 1: 
		total = distances.reduce(sum)
	
	var avg = total / (distances.size())
	
	tempo = (1 / (avg *  (audio_stream.stream.get_length() / 60)))
	

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

func report_add_tempo_event():
	if highlighted_beat:
		var listed_tempo = float(BPMTextEditor.text)
		# Find distance to next beat based on tempo
		var delta_to_next = (1 / (listed_tempo  *  (audio_stream.stream.get_length() / 60)))
		print("Adding " + str(highlighted_beat + delta_to_next))
		
		# Add it
		add_beat(highlighted_beat + delta_to_next)
		
		# Change the highlighted beat
		highlighted_beat = highlighted_beat + delta_to_next 
		
		# Move the time
		set_playback_to(highlighted_beat)
		

func _input(event):
	if ! BPMTextEditor.has_focus():
		if Input.is_key_pressed(KEY_A):
			highlighted_beat = null
			print("Annotate Mode.")
			mode.set_annotate()
			
		if Input.is_key_pressed(KEY_S):
			highlighted_beat = null
			print("Select Mode.")
			mode.set_select()
			
		if Input.is_key_pressed(KEY_D):
			highlighted_beat = null
			print("Drag Mode.")
			mode.set_drag()
			
		if Input.is_key_pressed(KEY_LEFT):
			slight_reverse()
			
		if Input.is_key_pressed(KEY_RIGHT):
			slight_forward()
			
		if Input.is_key_pressed(KEY_SPACE):
			toggle_playback()



func _on_select_track_item_selected(audio_id):
	audio_file = sounds_array[audio_id]
	var err_id_wav = OS.execute('python3', ['audio_scripts/waveform_get.py', 'music/' + audio_file])
	var err_id_amp = OS.execute('python3', ['audio_scripts/amplitude_get.py', 'music/' + audio_file])
	if err_id_wav == 0 and err_id_amp == 0:
		print("Waveform sucessfully created")
	else:
		print("Error encountered loading audio")
	# Open a selected audio file
	restart()
	rebuild_waveform()


func _on_select_track_focus_entered():
	pass # Replace with function body.
