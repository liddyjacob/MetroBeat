extends Node2D

var playback_position = 0
var rel_position = 0
@onready
var audio_stream = get_node("MusicPlayer")

# Set playback position, and seek if active
func set_playback_to(rel_position):
	playback_position = rel_position * audio_stream.stream.get_length()
	if audio_stream.has_stream_playback():
		audio_stream.seek(playback_position)

func toggle_playback():
	if audio_stream.has_stream_playback():
		playback_position = audio_stream.get_playback_position()
		audio_stream.stop()
	else:
		audio_stream.play(playback_position)

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

