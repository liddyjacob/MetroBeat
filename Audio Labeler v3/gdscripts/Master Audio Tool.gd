extends Control

var rel_position = 0
var raw_audio_data = Array()
var amp_audio_data = Array()
var playback_position = 0

@onready
var audio_stream = get_node("MusicPlayer")
@onready
var streams_node = $"Streams"

#

func stop():
	playback_position = audio_stream.get_playback_position()
	audio_stream.stop()

func play():
	audio_stream.play(playback_position)

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


# Set the position that we are in the song
func set_playback_to(rel_pos):
	print("setting playback position")
	playback_position = rel_pos * audio_stream.stream.get_length()
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
	# Make cameras work



