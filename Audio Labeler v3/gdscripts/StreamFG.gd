extends ColorRect

var data_stream = []

@onready
var stream_manager = get_node("../")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _draw():
	draw_set_transform(-Vector2.RIGHT * stream_manager.focus_wave_data_start)

	for index in range(stream_manager.focus_wave_data_start, min(stream_manager.focus_wave_data_end, stream_manager.data_stream.size())):
		if index == 0:
			continue


		draw_line(Vector2.RIGHT * (index - 1) + Vector2.UP * ((stream_manager.data_stream[index - 1] * size.y / stream_manager.max_abs_data_stream) - size.y)/2, 
		Vector2.RIGHT * index + Vector2.UP * ((stream_manager.data_stream[index] * size.y / stream_manager.max_abs_data_stream) - size.y)/2, 
		Color.BLACK,
		2)
		
	if stream_manager.reflect:
		for index in range(stream_manager.focus_wave_data_start, min(stream_manager.focus_wave_data_end, stream_manager.data_stream.size())):
			if index == 0:
				continue

			draw_line(Vector2.RIGHT * (index - 1) + Vector2.DOWN * ((stream_manager.data_stream[index - 1] * size.y / stream_manager.max_abs_data_stream) + size.y)/2, 
			Vector2.RIGHT * index + Vector2.DOWN * ((stream_manager.data_stream[index] * size.y / stream_manager.max_abs_data_stream) + size.y)/2, 
			Color.BLACK,
			2)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

