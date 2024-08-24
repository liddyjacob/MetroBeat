extends Node2D

var playback_position = 0
var rel_position = 0
var audio_file = ""
var sounds_array = Array()
var sounds_dict = {}

@onready
var audio_stream = get_node("MusicPlayer")
@onready 
var selector = $select_file


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

# Set a new stream based off audio file
func restart():
	set_playback_to(0)
	audio_stream.stream = sounds_dict[audio_file]
	

# Get the name of an audio file, then open it
func open_audio(audio_id):
	audio_file = sounds_array[audio_id]
	# Open a selected audio file
	restart()

# Called when the node enters the scene tree for the first time.
func _ready():
	# Gets all music and stores it in a handy dropdown
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
	selector.add_items() # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if audio_stream.has_stream_playback():
		playback_position = audio_stream.get_playback_position()
	rel_position = playback_position / audio_stream.stream.get_length()
	pass


func _on_music_player_finished():
	playback_position = 0

