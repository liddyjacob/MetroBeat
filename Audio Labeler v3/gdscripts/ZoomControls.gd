extends Control

@onready
var stream_manager = $".."

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_in_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		# Get the audio tool
		stream_manager.zoom_in()


func _on_out_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		# Get the audio tool
		stream_manager.zoom_out()
