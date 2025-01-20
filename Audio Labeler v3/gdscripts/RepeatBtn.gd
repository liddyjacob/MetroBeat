extends ColorRect

var original_color = null

@onready
var audio_tool = get_node("/root/Master Audio Tool")

# Called when the node enters the scene tree for the first time.
func _ready():
	original_color = color
	color = Color.TRANSPARENT


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass




func _on_mouse_entered():
	color = original_color


func _on_mouse_exited():
	color = Color.TRANSPARENT
	pass # Replace with function body.


func _on_gui_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == 1:
		audio_tool.repeat_selected(get_meta('Multiplier'))
