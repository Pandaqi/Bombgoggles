class_name MapData extends Resource

var bounds : Rect2
var hidden_elements : Array[HiddenElement] = []
var player_beacons : Array[PlayerBeacon] = []
var element_reminders : Array[ElementReminder] = []
var ground_layers : Array[GroundLayer] = []

@export var config : ConfigTemplate

func reset() -> void:
	bounds = Rect2()
	hidden_elements = []
	element_reminders = []
	player_beacons = []
	ground_layers = []

func add_hidden_element(e:HiddenElement) -> void:
	hidden_elements.append(e)

func remove_hidden_element(e:HiddenElement) -> void:
	hidden_elements.erase(e)

func add_element_reminder(r:ElementReminder) -> void:
	element_reminders.append(r)

func add_player_beacon(b:PlayerBeacon) -> void:
	player_beacons.append(b)

func add_ground_layer(g:GroundLayer) -> void:
	ground_layers.append(g)

func get_all_static_objects() -> Array:
	return player_beacons.duplicate(false) + element_reminders.duplicate(false)

func is_out_of_bounds(pos:Vector2) -> bool:
	return pos.x < bounds.position.x or pos.y < bounds.position.y or pos.x >= (bounds.position.x + bounds.size.x) or pos.y >= (bounds.position.y + bounds.size.y)

func get_random_position(dist_from_edge := Vector2.ZERO) -> Vector2:
	return bounds.position + dist_from_edge + Vector2(randf(), randf()) * (bounds.size - 2 * dist_from_edge)

func query_position(params:Dictionary = {}) -> Vector2:
	var pos := Vector2.ZERO
	var bad_pos := true
	
	var range_avoid : float = 0.0 if not ("range" in params) else params.range
	var range_avoid_squared := range_avoid * range_avoid
	var num_tries := 0
	var max_tries := 100
	
	if "avoid_edge" in params and params.avoid_edge:
		params.dist_from_edge = config.map_def_spawn_dist_from_edge
	
	var dist_from_edge : Vector2 = Vector2.ZERO if not ("dist_from_edge" in params) else params.dist_from_edge*Vector2.ONE
	
	while bad_pos:
		num_tries += 1
		if num_tries >= max_tries: break
		
		pos = get_random_position(dist_from_edge)
		bad_pos = false
		
		if "avoid" in params:
			for node in params.avoid:
				var dist_squared := pos.distance_squared_to(node.get_position())
				if dist_squared > range_avoid_squared: continue
				bad_pos = true
				break
	
	return pos

func query_overlaps(pos:Vector2, params:Dictionary = {}) -> Array:
	var all_elems : Array = []
	if "include" in params: all_elems += params.include
	if "hidden_elements" in params: all_elems += hidden_elements
	
	if "exclude" in params:
		for elem in params.exclude:
			all_elems.erase(elem)
	
	var search_range : float = 0.0 if not ("range" in params) else params.range
	
	var overlapping_elems : Array = []
	for elem in all_elems:
		if not elem or not is_instance_valid(elem): continue
		
		var range_squared := 0.0
		range_squared += config.hidden_element_overlap_range
		range_squared += search_range
		range_squared *= range_squared # make sure this one is squared too, AFTER all other calculations done
		
		var dist_squared := pos.distance_squared_to(elem.get_position())
		if dist_squared > range_squared: continue
		overlapping_elems.append(elem)
	
	return overlapping_elems

func is_hole_at(pos:Vector2) -> bool:
	for g in ground_layers:
		if not g.is_already_hole_at(pos): return false
	return true
