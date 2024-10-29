extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_texture_button_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		print("Selected...")
		# Get audio player
		var audio_tool = get_node("/root/Master Audio Tool")
		audio_tool.toggle_playback()
