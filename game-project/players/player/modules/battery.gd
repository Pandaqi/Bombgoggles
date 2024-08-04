class_name ModuleBattery extends Node2D

var power := 1.0
var active := true

@export var elem_dict : ElementDictionary
@export var config : ConfigTemplate
@export var prog_data : ProgressionData
@onready var audio_player : AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var audio_player_reverse : AudioStreamPlayer2D = $AudioStreamPlayer2D2

signal battery_empty()
signal battery_charging(new_val:float)
signal battery_changed(new_val:float)
signal battery_full()

var lives : ModuleLives

func activate(l:ModuleLives) -> void:
	lives = l
	active = elem_dict.battery_included()

func _process(dt:float) -> void:
	drain_battery_automatically(dt)

func drain_battery_automatically(dt:float) -> void:
	if not active: return
	var rate := config.battery_drain_rate * dt
	rate *= prog_data.interpolate(config.prog_battery_drain_rate)
	change_power(-rate)

func change_power(dp:float) -> float:
	if not active: return 1.0
	
	var was_empty := is_empty()
	var was_full := is_full()
	power = clamp(power + dp, 0.0, 1.0)
	
	if is_empty() and not was_empty:
		on_battery_empty()
	elif is_full() and not was_full:
		on_battery_full()
	
	if not is_empty() and not is_full():
		battery_charging.emit(power)
	
	battery_changed.emit(power)
	
	return power

func get_ratio() -> float:
	if not active: return 1.0
	return power

func is_empty() -> bool:
	if not active: return false
	return power <= 0.00003

func is_full() -> bool:
	if not active: return true
	return power >= 1.0 - 0.0003

func recharge() -> void:
	if not active: return
	
	GSignalBus.feedback.emit(get_parent().get_feedback_position(), "Recharge!")
	change_power(1.0)
	audio_player.play()

func on_battery_full() -> void:
	battery_full.emit()

func on_battery_empty() -> void:
	GSignalBus.feedback.emit(get_parent().get_feedback_position(), "Battery Empty!")
	battery_empty.emit()
	audio_player_reverse.play()
	
	if config.battery_empty_loses_life:
		lives.change_lives(-1)

func get_speed_factor() -> float:
	return config.battery_speed_reduction_if_empty if is_empty() else 1.0
