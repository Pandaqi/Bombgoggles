class_name Progression extends Node

@export var progression_data : ProgressionData
@export var config : ConfigTemplate
@onready var audio_player : AudioStreamPlayer = $AudioStreamPlayer

var level_done := false
signal level_finished()

func activate() -> void:
	progression_data.reset(Time.get_ticks_msec(), config.prog_max_time)
	GSignalBus.game_over.connect(end_level)
	
func start_level(pm:PlayersModifier) -> void:
	audio_player.play()
	get_tree().paused = false
	
	if OS.is_debug_build() and config.debug_instant_gameover:
		await get_tree().process_frame
		pm.kill_all()

func end_level(winning_player:Player) -> void:
	if level_done: return # to prevent acidentally going to game over multiple times when all players die, for example
	
	level_done = true
	get_tree().paused = true
	audio_player.play()
	progression_data.winning_player = winning_player
	level_finished.emit()

func _on_timer_timeout() -> void:
	progression_data.update_time(Time.get_ticks_msec())
