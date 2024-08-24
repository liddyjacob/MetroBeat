extends Control

@onready var drop_down_menu = $OptionButton
@onready var audio_tool = get_node("/root/AudioTool")

# Add items to the dropdown
func add_items():
	for item in audio_tool.sounds_array:
		drop_down_menu.add_item(item)
	

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_option_button_item_selected(index):
	audio_tool.open_audio(index)

