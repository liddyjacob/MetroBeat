extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_completed_gui_input(event):
	gui_input(event) # Replace with function body.


func _on_total_gui_input(event):
	gui_input(event) # Replace with function body.

func gui_input(event):
	# If selected, we may need to move the audio around
	if event is InputEventMouseButton and event.pressed:
		# Get the audio tool
		var audio_tool = get_node("/root/Master Audio Tool")
		#var audioStream = get_node("/root/AudioTool/MusicPlayer")
		
		audio_tool.set_playback_to(event.position[0]/size.x)
		
		#var rel_position = event.position[0]/1500
		#var seconds = rel_position * audioStream.stream.get_length()
		#audioStream.seek(seconds)
