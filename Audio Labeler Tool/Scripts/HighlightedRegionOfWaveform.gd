extends Camera2D

@onready
var audio_tool = get_node("/root/AudioTool")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	offset.x = audio_tool.rel_position * 20000
	pass
