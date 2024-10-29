extends ColorRect

var amp_data = Array()
var max_amp_data = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_amp_data(new_amp_data):
	# Get new data
	amp_data = new_amp_data
	max_amp_data = new_amp_data.max()
	queue_redraw()



func _draw():
	print("drawing amp...")

	for pixel in range(0, size.x):
		if pixel == 0:
			continue
		var index_last = round((float(pixel - 1) / size.x) * amp_data.size())
		var index_curr = round((float(pixel) / size.x ) * amp_data.size()) - 1

		draw_line(Vector2.RIGHT * (pixel - 1) + Vector2.UP * ((amp_data[index_last] * size.y / max_amp_data) - size.y)/2, 
		Vector2.RIGHT * pixel + Vector2.UP * ((amp_data[index_curr] * size.y / max_amp_data) - size.y)/2, 
		Color.BLACK,
		2)


