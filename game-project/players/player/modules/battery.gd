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

func activate() -> void:
	active = elem_dict.battery_included()

func _process(dt:float) -> void:
	drain_battery_automatically(dt)

func drain_battery_automatically(dt:float) -> void:
	if not active: return
	var rate := config.battery_drain_rate * dt
	rate *= prog_data.interpolate(config.prog_battery_drain_rate)

func change_power(dp:float) -> float:
	if not active: return 1.0
	
	power = clamp(power + dp, 0.0, 1.0)
	if is_empty():
		on_battery_empty()
	elif is_full():
		on_battery_full()
	else:
		battery_charging.emit(power)
	battery_changed.emit(power)
	
	return power

func get_ratio() -> float:
	if not active: return 1.0
	return power

func is_empty() -> bool:
	if not active: return false
	return power <= 0.0

func is_full() -> bool:
	if not active: return true
	return power >= 1.0

func recharge() -> void:
	if not active: return
	
	GSignalBus.feedback.emit(get_position(), "Recharge!")
	change_power(1.0)
	audio_player.play()

func on_battery_full() -> void:
	battery_full.emit()

func on_battery_empty() -> void:
	GSignalBus.feedback.emit(get_position(), "Battery Empty!")
	battery_empty.emit()
	audio_player_reverse.play()

func get_speed_factor() -> float:
	return config.battery_speed_reduction_if_empty if is_empty() else 1.0
