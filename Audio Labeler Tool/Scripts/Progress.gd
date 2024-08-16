extends ColorRect


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var music_player = get_parent().get_parent()
	var playback_position = music_player.get_playback_position() / music_player.stream.get_length()
	size.x = playback_position * get_parent().size.x
