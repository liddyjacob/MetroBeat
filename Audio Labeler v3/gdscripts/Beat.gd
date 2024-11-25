class_name Beat
extends Node

const musical_annotation: PackedScene = preload("res://musical_annotation.tscn")

var relative_position: float

static func new_beat(relative_position: float):
	var new_beat = musical_annotation.instantiate()
	new_beat.relative_position = relative_position
	return new_beat
