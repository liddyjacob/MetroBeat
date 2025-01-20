extends Control

@onready
var highlight = $highlight
@onready
var audio_tool = get_node("/root/Master Audio Tool")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_add_mouse_entered():
	highlight.show()
	pass # Replace with function body.


func _on_add_mouse_exited():
	highlight.hide()
	pass # Replace with function body.


func _on_add_gui_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == 1:
		audio_tool.report_add_tempo_event()
	pass # Replace with function body.
