extends Node2D

var playback_position = 0
var rel_position = 0
var audio_file = ""
@onready
var audio_stream = get_node("MusicPlayer")

# Set playback position, and seek if active
func set_playback_to(rel_position):
	playback_position = rel_position * audio_stream.stream.get_length()
	if audio_stream.has_stream_playback():
		audio_stream.seek(playback_position)

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
		
func load_mp3(path):
	# I don't know why this won't open. Clearly, we can see the file in res/music
	var dir = DirAccess.open('res://music')
	print(dir.get_files()[0])
	
	
	var file = FileAccess.open(dir.get_files()[0], FileAccess.READ)
	print(file)
	var sound = AudioStreamMP3.new()
	sound.data = file.get_buffer(file.get_length())
	return sound

func restart():
	var new_stream = load_mp3(audio_file)
	print(new_stream)
	#audio_stream.stream = load_mp3(audio_file)
	

func open_audio():
	# Open a selected audio file
	var output = []
	OS.execute('pwd', [], output)
	var err_no = OS.execute('bash', ['-c', 'cd music; zenity --file-selection'], output)
	if err_no == 0:
		var base_path = output[0]
		
		# this replaces the beginning of the file with res
		audio_file = "res://" + output[1].substr(base_path.length())
		
		print(audio_file)
		restart()
		
	else:
		print("Failure to load file")



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if audio_stream.has_stream_playback():
		playback_position = audio_stream.get_playback_position()
	rel_position = playback_position / audio_stream.stream.get_length()
	pass


func _on_music_player_finished():
	playback_position = 0

