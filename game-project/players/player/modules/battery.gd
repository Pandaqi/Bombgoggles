class_name ModuleBattery extends Node2D

var power := 1.0
var active := true

@export var elem_dict : ElementDictionary
@onready var audio_player : AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var audio_player_reverse : AudioStreamPlayer2D = $AudioStreamPlayer2D2

signal battery_empty()
signal battery_charging()
signal battery_full()

func activate() -> void:
	active = elem_dict.battery_included()

func change_power(dp:float) -> void:
	if not active: return
	
	power = clamp(power + dp, 0.0, 1.0)
	if is_empty():
		on_battery_empty()
	elif is_full():
		on_battery_full()
	else:
		battery_charging.emit()

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
