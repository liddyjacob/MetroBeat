extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_texture_button_pressed():
	# Call upstream handler
	var audio_tool = get_node("/root/AudioTool")
	audio_tool.open_audio()
