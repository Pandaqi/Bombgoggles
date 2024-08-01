class_name MapData extends Resource

var bounds : Rect2
var hidden_elements : Array[HiddenElement] = []
var player_beacons : Array[PlayerBeacon] = []
var element_reminders : Array[ElementReminder] = []

@export var config : ConfigTemplate

func reset():
	bounds = Rect2()
	hidden_elements = []
	element_reminders = []
	player_beacons = []

func add_element_reminder(r:ElementReminder) -> void:
	element_reminders.append(r)

func add_player_beacon(b:PlayerBeacon) -> void:
	player_beacons.append(b)

func get_all_static_objects() -> Array[Node2D]:
	return player_beacons.duplicate(false) + element_reminders.duplicate(false)

func is_out_of_bounds(pos:Vector2) -> bool:
	return pos.x < bounds.position.x or pos.y < bounds.position.y or pos.x >= (bounds.position.x + bounds.size.x) or pos.y >= (bounds.position.y + bounds.size.y)

func get_random_position() -> Vector2:
	return bounds.position + Vector2(randf(), randf()) * bounds.size

func query_position(params:Dictionary = {}) -> Vector2:
	var pos := Vector2.ZERO
	var bad_pos := true
	
	var range_avoid : float = 0.0 if not ("range" in params) else params.range
	var range_avoid_squared := range_avoid * range_avoid
	var num_tries := 0
	var max_tries := 100
	
	while bad_pos:
		num_tries += 1
		if num_tries >= max_tries: break
		
		pos = get_random_position()
		bad_pos = false
		
		if "avoid" in params:
			for node in params.avoid:
				var dist_squared := pos.distance_squared_to(node.get_position())
				if dist_squared > range_avoid_squared: continue
				bad_pos = true
				break
	
	return pos

func query_overlaps(pos:Vector2, params:Dictionary = {}) -> Array[Node2D]:
	var all_elems : Array[Node2D] = []
	if "include" in params: all_elems += params.include
	if "hidden_elements" in params: all_elems += hidden_elements
	
	if "exclude" in params:
		for elem in params.exclude:
			all_elems.erase(elem)
	
	var search_range : float = 0.0 if not ("range" in params) else params.range
	
	var overlapping_elems : Array[Node2D] = []
	for elem in all_elems:
		var range_squared := 0.0
		if elem is HiddenElement: range_squared += config.hidden_element_overlap_range
		
		range_squared += search_range
		range_squared *= range_squared # make sure this one is squared too, AFTER all other calculations done
		
		var dist_squared := pos.distance_squared_to(elem.get_position())
		if dist_squared > range_squared: continue
		overlapping_elems.append(elem)
	
	return overlapping_elems
