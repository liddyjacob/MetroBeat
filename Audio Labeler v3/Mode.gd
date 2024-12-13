extends Control

# Default Mode
var mode = "A"

@onready
var mode_text = $"ModeText"

# Called when the node enters the scene tree for the first time.
func _ready():
	reset_text()
	pass # Replace with function body.


func reset_text():
	if mode == "A":
		mode_text.text = "[b]ANNOTATE[/b] | (s)elect | (d)rag "
	if mode == "S":
		mode_text.text = "(a)nnotate | [b]SELECT[/b] | (d)rag"
	if mode == "D":
		mode_text.text = "(a)nnotate  | (s)elect | [b]DRAG[/b]"

func set_annotate():
	mode = "A"
	reset_text()
	
func is_annotate():
	return mode == "A"
	
func set_select():
	mode = "S"
	reset_text()
	
func is_select():
	return mode == "S"
	
func set_drag():
	mode = "D"
	reset_text()
	
func is_drag():
	return mode == "D"
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
