class_name ModuleTreasureTracker extends Node2D

var num := 0
var active := false

@export var elem_dict : ElementDictionary
@onready var audio_player : AudioStreamPlayer2D = $AudioStreamPlayer2D

signal treasure_changed(num:int)

func activate() -> void:
	active = elem_dict.treasure_included()

func change_treasure(dt:int) -> int:
	if not active: return 0
	
	num = clamp(num + dt, 0, 9)
	treasure_changed.emit(num)
	
	GSignalBus.feedback.emit(get_parent().get_feedback_position(), "Treasure!")
	
	audio_player.pitch_scale = randf_range(0.9, 1.1)
	audio_player.play()
	return num
