class_name ProgressionData extends Resource

@export var config : ConfigTemplate
var start_time := 0.0 # ms
var cur_time := 0.0

var winning_player : Player
var num_plays := 0
var num_plays_before_tutorial_disappears := 1

func reset() -> void:
	num_plays += 1
	start_time = Time.get_ticks_msec()
	winning_player = null

func update_time() -> void:
	cur_time = Time.get_ticks_msec()

func get_time_elapsed_seconds() -> float:
	return (cur_time - start_time) / 1000.0

func get_ratio() -> float:
	return clamp(get_time_elapsed_seconds() / config.prog_max_time, 0.0, 1.0)

func interpolate(val:Dictionary) -> float:
	return lerp(val.min, val.max, get_ratio())
