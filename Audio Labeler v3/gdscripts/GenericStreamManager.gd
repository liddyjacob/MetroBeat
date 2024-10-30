extends Control

var rel_position = -1

var original_data_stream = []
var data_stream = []
var zoom_options = []

var zoom_level = 0

var focus_wave_data_start = 0
var focus_wave_data_end = 0

var max_abs_data_stream = 0

@onready
var streamFG = $"StreamFG"
@onready
var audio_tool = get_node("/root/Master Audio Tool")

@export var time_window = 1.0
@export var reflect = false
@export var data_source = "raw"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func draw_stream():
	focus_wave_data_start = round(data_stream.size() * rel_position) - size.x / 2
	focus_wave_data_end = focus_wave_data_start + size.x
	# redraw
	streamFG.queue_redraw()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# If the audio position changed..
	if audio_tool.rel_position != rel_position:
		# ...then Get a new relative position
		rel_position = audio_tool.rel_position
		draw_stream()


# Pass needed data onto stream:
func load_data_stream(in_data_stream):
	original_data_stream = in_data_stream
	
# Zoom data in 
func adjust_data_for_zoom():
	data_stream = []
	var zoom = zoom_options[zoom_level + 3]
	for index in range(0, ceil(original_data_stream.size() / zoom)):
		var threshold = min(zoom, original_data_stream.size() - index*zoom )
		var app_value = 0
		for j in range(0, threshold):
			app_value = app_value + original_data_stream[index*zoom + j] / float(threshold)
		data_stream.append(app_value)
	max_abs_data_stream = max(data_stream.max(), -data_stream.min())
	
# Initialize data 
func initialize_defaults():
	var zoom_center = round((6000 / size.x) * time_window)
	zoom_options = [max(1, round(zoom_center / 16)), max(1, round(zoom_center / 4)), max(1, round(zoom_center / 2)), zoom_center, zoom_center * 2, zoom_center * 4, zoom_center * 8]
	adjust_data_for_zoom()
	pass
	
# Zoom in on the stream
func zoom_in():
	if zoom_level != -3:
		zoom_level = zoom_level - 1
		adjust_data_for_zoom()
		draw_stream()

# Zoom out on the stream
func zoom_out():
	if zoom_level != 3:
		zoom_level = zoom_level + 1
		adjust_data_for_zoom()
		draw_stream()
