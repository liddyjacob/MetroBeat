extends ColorRect


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var audio_tool = get_node("/root/AudioTool")

	size.x = audio_tool.rel_position * get_parent().size.x
