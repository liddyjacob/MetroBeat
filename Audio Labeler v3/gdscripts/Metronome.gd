extends Node

var sample_hz = 11025.0 # Keep the number of samples to mix low, GDScript is not super fast.
var pulse_hz = 440.0
var phase = 0.0

var playback: AudioStreamPlayback = null # Actual playback stream, assigned in _ready().
var percuss = true

func percuss_in(seconds):
	var frames_avaliable = playback.get_frames_available()
	var time_covered = frames_avaliable / sample_hz
	if time_covered > seconds:
		var increment = pulse_hz / sample_hz
		var empty_space = 0
		var start_fill = int((seconds / time_covered) * frames_avaliable)
		while empty_space < start_fill:
			playback.push_frame(Vector2.ZERO)
			empty_space += 1
		while start_fill < frames_avaliable:
			phase = fmod(phase + increment, 1)
			playback.push_frame(Vector2.ONE * sin(phase * TAU))
			start_fill += 1
		
func _process(_delta):
	pass


func _ready():
	# Setting mix rate is only possible before play().
	$MetronomePlayer.stream.mix_rate = sample_hz
	$MetronomePlayer.play()
	playback = $MetronomePlayer.get_stream_playback()
	# `_fill_buffer` must be called *after* setting `playback`,
	# as `fill_buffer` uses the `playback` member variable.
	#_fill_buffer()

