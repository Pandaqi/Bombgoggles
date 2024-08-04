class_name ModuleLives extends Node2D

var lives := 0

@export var config : ConfigTemplate
@export var map_data : MapData

@onready var entity : Player = get_parent()
@onready var audio_player : AudioStreamPlayer2D = $AudioStreamPlayer2D

signal lives_depleted()
signal lives_changed(new_lives:int)

func activate() -> void:
	change_lives(config.lives_starting_num)

func drain() -> void:
	change_lives(-lives)

func change_lives(dl:int) -> int:
	var old_lives := lives
	lives = clamp(lives + dl, 0, config.lives_max)
	
	if lives != old_lives:
		var txt := "+ Life!" if dl >= 0 else "- Life!"
		GSignalBus.feedback.emit(entity.get_position(), txt)
		audio_player.pitch_scale = randf_range(0.9, 1.1)
		audio_player.play()
	
	if lives <= 0:
		lives_depleted.emit()
	
	lives_changed.emit(lives)
	return lives
