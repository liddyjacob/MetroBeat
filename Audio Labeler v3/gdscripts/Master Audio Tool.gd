extends Control

var rel_position = 0
var raw_audio_data = Array()
var playback_position = 0

@onready
var CloseUpDrawArea = $"CloseUp/DrawArea"
@onready
var audio_stream = get_node("MusicPlayer")


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
	rel_position = rel_pos

func _ready():
	# Build wave instance
	
	# load instance up with data
	var audio_data_file = FileAccess.open('res://output.txt', FileAccess.READ)
	var line = audio_data_file.get_line()
	raw_audio_data = Array()
	while line:
		raw_audio_data.append(str_to_var(line))
		line = audio_data_file.get_line()
	
	
	# Update data and draw
	CloseUpDrawArea.update_wave_data(raw_audio_data)
	
	# Make cameras work



