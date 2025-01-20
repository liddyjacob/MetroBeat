extends Control

@onready
var highlight = $Highlight
@onready
var selected = $Selected
@onready
var Parent = get_parent()

var relative_position = 0
var is_in_focus = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_hitbox_mouse_entered():
	# Tell parent that this beat has been entered at this positon
	Parent.communicate_beat_focus(relative_position)

func _on_hitbox_mouse_exited():
	# Tell parent that this beat has been exited at this positon
	Parent.communicate_beat_unfocus(relative_position)

func focus():
	highlight.show()
	
func unfocus():
	highlight.hide()
	
func set_selected(value: bool):
	if value:
		selected.show()
	else:
		selected.hide()

func _on_hitbox_gui_input(event):
	Parent.communicate_gui_input(event, relative_position)
	pass # Replace with function body.
