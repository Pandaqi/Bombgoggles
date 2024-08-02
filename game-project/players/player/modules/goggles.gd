class_name ModuleGoggles extends Node

@export var map_data : MapData
@export var config : ConfigTemplate
@export var elem_dict : ElementDictionary
@onready var entity : Player = get_parent()

var battery : ModuleBattery
var locked := false
var haywire := false
var active := false

signal slots_updated(new_vals:Dictionary)

func activate(b:ModuleBattery) -> void:
	active = true
	battery = b
	battery.battery_empty.connect(func(): set_locked(true))
	battery.battery_charging.connect(func(): set_locked(false))

func set_locked(l:bool) -> void:
	# @TODO: some particles or permanent animation to signal this is the case
	locked = l

func _process(_dt:float) -> void:
	check_distances()

func check_distances() -> void:
	if locked: return
	
	var elems := map_data.hidden_elements
	var list : Array[float] = []
	for type in elem_dict.types:
		var val := convert_dist_to_ratio( get_dist_to_closest(elems, type) )
		
		# battery is special => it shows your current battery power, not distance to such elements
		if type == HiddenElement.HiddenElementType.BATTERY:
			val = 1.0 - battery.get_ratio()
		
		# haywire just means it temporarily gives garbage data
		if haywire: 
			val = randf()
		
		# not active means everything responds with "nothing"
		if not active:
			val = 1.0
		
		list.append(val)
		
	slots_updated.emit(list)

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
