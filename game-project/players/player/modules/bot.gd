class_name ModuleBot extends Node2D

signal movement_vector_update(vec, dt)

var target_element : HiddenElement = null
var target_position : Vector2 = Vector2.ZERO
var active := false

var interactor_hidden : ModuleInteractorHidden
var battery : ModuleBattery
var beacon_manager : ModuleBeaconManager

@export var map_data : MapData
@export var config : ConfigTemplate

@onready var entity : Player = get_parent()
@export var players_data : PlayersData

# @NOTE: this simply adds some subtle randomness to movement, which makes it less predictable and robotic; nothing special
@onready var timer_random : Timer = $TimerRandom

func activate(ih:ModuleInteractorHidden, b:ModuleBattery, bm:ModuleBeaconManager) -> void:
	interactor_hidden = ih
	battery = b
	beacon_manager = bm
	
	active = true
	pick_new_target()
	restart_timer_random()

func has_target_element() -> bool:
	return target_element != null and is_instance_valid(target_element)

func target_element_lost() -> bool:
	return target_element != null and (not is_instance_valid(target_element) or interactor_hidden.is_excluded(target_element))

func _process(dt:float) -> void:
	if not active: return
	move_to_target(dt)

func move_to_target(dt:float) -> void:
	# default to a randomly selected position nearby
	var pos := target_position
	
	# we have a specific element to reach? go there
	if has_target_element():
		pos = target_element.position
	
	# our battery is empty/low? go to beacon
	if battery.get_ratio() <= config.bot_battery_power_to_run_back:
		pos = beacon_manager.get_beacon_position()
	
	var vec_to_target := pos - self.global_position
	movement_vector_update.emit(vec_to_target.normalized(), dt)
	
	var dist_to_target := vec_to_target.length()
	var close_enough := dist_to_target <= 0.5*config.hidden_element_overlap_range
	var should_pick_new_target := close_enough or target_element_lost()
	if should_pick_new_target:
		pick_new_target()

func pick_new_target() -> void:
	target_element = null
	
	# get all hidden elements in range ...
	var all_elems := map_data.query_overlaps(global_position, { "hidden_elements": true, "range": config.bot_search_range })
	var elems : Array[HiddenElement] = []
	var undesirable_elems : Array[HiddenElement] = []
	for elem in all_elems:
		# ... which are "desirable" ( = not bad for us)
		if not elem.is_desirable(): 
			undesirable_elems.append(elem)
			continue
			
		# ... which will actually do something for us (instead of repeatedly visiting something that just tells us "already at max!"
		if interactor_hidden.is_excluded(elem): continue
		
		# ... and no other player is clearly closer
		var my_dist : float = elem.global_position.distance_to(entity.global_position)
		var closest_dist_others : float = players_data.get_closest_dist_to(elem.global_position, [entity])
		var others_are_much_closer := closest_dist_others <= 0.5*my_dist
		if others_are_much_closer: continue
		
		elems.append(elem)

	# if nothing close, pick a random point in the world and walk there
	var nothing_nearby = elems.size() <= 0
	if nothing_nearby:
		var query_params : Dictionary = { 
			"circle": { 
				"pos": global_position, 
				"radius": config.bot_random_walk_range
			}, 
			"avoid": undesirable_elems
		}
		target_position = map_data.query_position(query_params)
		return
	
	# otherwise, pick a suitable element and go for it
	# if there's a treasure, always prefer it
	var treasures : Array[HiddenElement] = []
	for elem in elems:
		if not elem.type == HiddenElement.HiddenElementType.TREASURE: continue
		treasures.append(elem)
	
	var rand_elem : HiddenElement = elems.pick_random()
	if treasures.size() > 0: rand_elem = treasures.pick_random()
	
	target_element = rand_elem

func _on_timer_random_timeout() -> void:
	if not active: return
	if not has_target_element(): pick_new_target()
	restart_timer_random()

func restart_timer_random():
	timer_random.wait_time = randf_range(3.5, 10.5)
	timer_random.start()
