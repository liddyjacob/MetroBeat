extends ColorRect

# All of the wave data
var wave_data = Array()
# max of wave data
var max_wave_data = Array()
# The wave data we are focused on
var focus_wave_data_start = 0
var focus_wave_data_end = 0



var audio_tick_delta = -1



# Skip X frames before next draw
var skip_frames = 2

var draw_frame_on_zero = 0

# The last set of data we focused on:

# The set of lines that we want to draw
var lineset = Array()

# The relative position of the audio last recieved from audio tool.
var rel_position = 0

@onready
var audio_tool = get_node("/root/Master Audio Tool")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# If the audio position changed..
	if audio_tool.rel_position != rel_position:
		# ...then Get a new relative position
		rel_position = audio_tool.rel_position

		focus_wave_data_start = round(wave_data.size() * rel_position)
		focus_wave_data_end = min(focus_wave_data_start + size.x, wave_data.size())
		# redraw

		queue_redraw()
		

func _draw():		
	draw_set_transform(-Vector2.RIGHT * focus_wave_data_start)

	for index in range(focus_wave_data_start, focus_wave_data_end):
		if index == 0:
			continue

		draw_line(Vector2.RIGHT * (index - 1) + Vector2.UP * ((wave_data[index - 1] * size.y / max_wave_data) - size.y)/2, 
		Vector2.RIGHT * index + Vector2.UP * ((wave_data[index] * size.y / max_wave_data) - size.y)/2, 
		Color.BLACK,
		2)
	

func update_wave_data(new_wave_data):
	# Get new data
	wave_data = new_wave_data
	max_wave_data = max(new_wave_data.max(), -new_wave_data.min())
	

