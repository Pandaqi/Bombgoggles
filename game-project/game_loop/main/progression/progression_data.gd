class_name ProgressionData extends Resource

@export var config : ConfigTemplate
var start_time := 0.0 # ms
var cur_time := 0.0

var max_time := 0.0

var winning_player : Player
var num_plays := 0
var num_plays_before_tutorial_disappears := 1

func reset(st: float, mt: float) -> void:
	start_time = st
	max_time = mt
	
	num_plays += 1
	winning_player = null

func update_time(ct:float) -> void:
	cur_time = ct

func get_time_elapsed_seconds() -> float:
	return (cur_time - start_time) / 1000.0

func get_ratio() -> float:
	if max_time <= 0.0003: return 0.0
	return clamp(get_time_elapsed_seconds() / max_time, 0.0, 1.0)

func interpolate(val:Dictionary) -> float:
	return lerp(val.min, val.max, get_ratio())
