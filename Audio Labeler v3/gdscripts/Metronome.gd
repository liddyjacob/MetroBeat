extends Node

var percussing = false

# Get parent node to see if audio is playing
@onready
var stream_manager = get_node("/root/Master Audio Tool")

# Play a beat if one is coming up.
func percuss_in(seconds):
	if !stream_manager.is_playing():
		return
	if percussing:
		return
	percussing = true
	var tween = get_tree().create_tween()
	tween.tween_callback(percuss_if_playing).set_delay(seconds) 
		
func _process(_delta):
	pass

func percuss():
	$MetronomePlayer.play()

func percuss_if_playing():
	if stream_manager.is_playing():
		$MetronomePlayer.play()
	percussing = false

func _ready():
	pass
