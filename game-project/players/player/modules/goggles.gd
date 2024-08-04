class_name ModuleGoggles extends Node

@export var map_data : MapData
@export var config : ConfigTemplate
@export var elem_dict : ElementDictionary
@onready var entity : Player = get_parent()

@onready var timer_haywire : Timer = $TimerHaywire

var lives : ModuleLives
var battery : ModuleBattery
var locked := false
var haywire := false
var active := false
var slots : Array[float] = [0.0, 0.0, 0.0]

signal slots_updated(new_vals:Dictionary)

func activate(b:ModuleBattery, l:ModuleLives) -> void:
	active = true
	battery = b
	battery.battery_empty.connect(func(): set_locked(true))
	battery.battery_charging.connect(func(): set_locked(false))
	
	lives = l

func set_locked(l:bool) -> void:
	# @TODO: some particles or permanent animation to signal this is the case
	locked = l

func go_haywire():
	haywire = true
	timer_haywire.stop()
	timer_haywire.wait_time = randf_range(config.goggle_haywire_duration.min, config.goggle_haywire_duration.max)
	timer_haywire.start()

func _on_timer_haywire_timeout() -> void:
	haywire = false

func _process(_dt:float) -> void:
	check_distances()

func check_distances() -> void:
	if locked: return
	
	var terrain_type_below := map_data.get_terrain_type_below(entity.position)
	var elems := map_data.hidden_elements
	var list : Array[float] = []
	for i in range(elem_dict.types.size()):
		var type = elem_dict.types[i]
		var val := convert_dist_to_ratio( get_dist_to_closest(elems, type) )
		
		# battery is special => it shows your current battery power, not distance to such elements
		if type == HiddenElement.HiddenElementType.BATTERY and config.goggle_battery_shows_battery_power:
			val = 1.0 - battery.get_ratio()
		
		# haywire just means it temporarily gives garbage data
		if haywire: 
			val = randf()
		
		# not active means everything responds with "nothing"
		if not active:
			val = 1.0
		
		# locking individual just means the goggle will not move at all from its previous value
		var lock_individual := false
		if config.terrain_locks_goggle_of_same_type and terrain_type_below == type:
			lock_individual = true
			
		if lock_individual:
			val = slots[i]
		
		list.append(val)
	
	slots = list
	slots_updated.emit(list)

# between 0.0 and 1.0, where 0.0 means results are completely random, and 1.0 means results are completely accurate
func get_accuracy() -> float:
	if not config.goggle_accuracy_loss_on_life_loss: return 1.0
	
	var bounds = config.goggle_accuracy_bounds
	var ratio = clamp(lives.lives / config.lives_starting_num, 0.0, 1.0)
	return lerp(bounds.min, bounds.max, ratio)
	
# 1.0 = as far away as possible, 0.0 = you're literally there
func convert_dist_to_ratio(dist:float) -> float:
	var accuracy_randomizer := (randf() - 0.5) * (1.0 - get_accuracy())
	return clamp(dist / config.hidden_element_max_dist + accuracy_randomizer, 0.0, 1.0)

func get_dist_to_closest(elems:Array[HiddenElement], type:HiddenElement.HiddenElementType) -> float:
	var pos := entity.get_position()
	var closest_dist := INF
	for elem in elems:
		if not elem.is_type(type): continue
		var dist = pos.distance_to(elem.get_position())
		closest_dist = min(dist, closest_dist)
	return closest_dist
