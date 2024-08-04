class_name MapElementsSpawner extends Node2D

@onready var timer : Timer = $Timer
@export var map_data : MapData
@export var config : ConfigTemplate
@export var elem_dict : ElementDictionary
@export var prog_data : ProgressionData

@export var hidden_element_scene : PackedScene

func activate() -> void:
	restart_timer()
	refresh_all_types()

func restart_timer() -> void:
	timer.wait_time = config.hidden_element_tick
	timer.start()
	timer.timeout.connect(refresh_all_types)

func get_elements_with_type(arr:Array[HiddenElement], type:HiddenElement.HiddenElementType) -> Array[HiddenElement]:
	var result : Array[HiddenElement] = []
	for elem in arr:
		if not elem.is_type(type): continue
		result.append(elem)
	return result

func refresh_all_types() -> void:
	var elems := map_data.hidden_elements
	var base_num := config.bounds_per_type_base
	var prog_mult := prog_data.interpolate(config.prog_element_bounds)
	var player_count_mult := config.prog_element_bounds_player_count[GInput.get_player_count()]
	
	for type in elem_dict.types:
		var elems_of_type = get_elements_with_type(elems, type)
		var num = elems_of_type.size()
		var data = elem_dict.get_data_for_type(type)
		
		var min_of_type = ceil(data.min_num * base_num * prog_mult)
		var max_of_type = ceil(data.max_num * base_num * prog_mult)
		if num >= max_of_type: continue
		
		while num < min_of_type:
			add_element_of_type(type)
			num += 1
		
		if randf() <= 0.5:
			add_element_of_type(type)

func add_element_of_type(tp:HiddenElement.HiddenElementType, paired_node = null) -> HiddenElement:
	var e : HiddenElement = hidden_element_scene.instantiate()
	var pos = map_data.query_position({ "avoid": map_data.hidden_elements, "range": config.min_dist_between_hidden_elements, "avoid_edge": true })
	e.set_position(pos)
	add_child(e)
	e.set_type(tp)
	e.set_visible(false)
	
	if OS.is_debug_build() and config.debug_show_hidden_elements:
		e.set_visible(true)
	
	map_data.add_hidden_element(e)
	e.died.connect(func(): map_data.remove_hidden_element(e))
	
	if tp == HiddenElement.HiddenElementType.BOMB and config.bombs_come_in_pairs:
		if not paired_node: 
			e.set_paired_node( add_element_of_type(tp, e) )
		else:
			e.set_paired_node(paired_node)
	
	return e
