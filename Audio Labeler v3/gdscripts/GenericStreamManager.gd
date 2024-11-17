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
@onready
var streamBar = $"StreamBar"
@onready
var markerLine = $"MarkerLine"
@onready
var ScrollBarObj = $"ScrollBar"

@export var time_window = 1.0
@export var reflect = false
@export var data_source = "raw"
@export var window_type = "rolling"
@export var agg_method = "mean"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func draw_stream():
	if window_type == "rolling":
		focus_wave_data_start = round(data_stream.size() * rel_position) - size.x / 2
		focus_wave_data_end = focus_wave_data_start + size.x
	if window_type == "frame":
		focus_wave_data_start = round(data_stream.size() * rel_position)
		focus_wave_data_end = focus_wave_data_start + size.x
	
	ScrollBarObj.value = rel_position * ScrollBarObj.max_value
	# redraw
	streamFG.queue_redraw()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# If the audio position changed..
	if audio_tool.rel_position != rel_position:
		# ...then Get a new relative position
		rel_position = audio_tool.rel_position
		if window_type == "rolling":
			draw_stream()
		if window_type == "frame":
			if (round(data_stream.size() * rel_position) >= focus_wave_data_end) or (round(data_stream.size() * rel_position) < focus_wave_data_start):
				draw_stream()
			streamBar.position.x = size.x * (round(data_stream.size() * rel_position) - focus_wave_data_start) / (focus_wave_data_end - focus_wave_data_start) - 3

		


# Pass needed data onto stream:
func load_data_stream(in_data_stream):
	original_data_stream = in_data_stream
	
# Zoom data in 
func adjust_data_for_zoom():
	data_stream = []
	var zoom = zoom_options[zoom_level + 3]
	for index in range(0, ceil(original_data_stream.size() / zoom)):
		var threshold = min(zoom, original_data_stream.size() - index*zoom )
		if agg_method == "mean":
			var app_value = 0
			for j in range(0, threshold):
				app_value = app_value + original_data_stream[index*zoom + j] / threshold
			data_stream.append(app_value)
		if agg_method == "max":
			var app_values = []
			for j in range(0, threshold):
				app_values.append(original_data_stream[index*zoom + j])
			data_stream.append(app_values.max())
	max_abs_data_stream = max(data_stream.max(), -data_stream.min())
	
	# Reset stream bar for frame style stream
	if window_type == "frame":
		streamBar.position.x = -3
	
	# Set scroll bar page to be equal to appx length represented by time period.
	ScrollBarObj.page = 100 * (size.x / data_stream.size())
	
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



func _on_stream_hit_box_gui_input(event):
	if event is InputEventMouseMotion:
		audio_tool.report_hover(float(focus_wave_data_start + self.get_local_mouse_position().x) / data_stream.size())
	if event is InputEventMouseButton and event.pressed:
		audio_tool.report_press_event(float(focus_wave_data_start + self.get_local_mouse_position().x) / data_stream.size())

# Show a line marker if it is in range
func show_line_marker(line_rel_position):
	if (line_rel_position >= float(focus_wave_data_start) / data_stream.size()) and (line_rel_position < float(focus_wave_data_end) / data_stream.size()):
		markerLine.visible = true
		markerLine.position.x =  int(round(data_stream.size() * line_rel_position - focus_wave_data_start))
	else:
		markerLine.visible=false

# Hide the line marker if requested by the stream manager
func hide_line_marker():
	markerLine.visible = false


# When a scroll happens, we make sure the streamBar position
# still points to the right point in time, but move the audio data.
# This allows us to see forward and backward without moving the audio playback position. 
func _on_scroll_bar_scrolling():
	pass


func _on_stream_hit_box_mouse_exited():
	audio_tool.hide_hover()
	pass # Replace with function body.
