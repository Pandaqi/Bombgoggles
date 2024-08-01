class_name ModuleGoggles extends Node

@export var map_data : MapData
@export var config : ConfigTemplate
@export var elem_dict : ElementDictionary
@onready var entity : Player = get_parent()

# @TODO: Visuals should listen to this and set the new values
signal slots_updated(new_vals:Dictionary)

func _process(_dt:float) -> void:
	check_distances()

func check_distances() -> void:
	var elems := map_data.hidden_elements
	var dict : Dictionary = {}
	for type in elem_dict.types:
		dict[type] = convert_dist_to_ratio( get_dist_to_closest(elems, type) )
	slots_updated.emit(dict)

# 1.0 = as far away as possible, 0.0 = you're literally there
func convert_dist_to_ratio(dist:float) -> float:
	return clamp(dist / config.hidden_element_max_dist, 0.0, 1.0)

func get_dist_to_closest(elems:Array[HiddenElement], type:HiddenElement.HiddenElementType) -> float:
	var pos := entity.get_position()
	var closest_dist := INF
	for elem in elems:
		if not elem.is_type(type): continue
		var dist = pos.distance_to(elem.get_position())
		closest_dist = min(dist, closest_dist)
	return closest_dist
