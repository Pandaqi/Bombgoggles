class_name ElementDictionary extends Resource

@export var all_types : Array[HiddenElement.HiddenElementType] = []
@export var config : ConfigTemplate
@export var keys := ["red", "green", "blue"]
@export var inverts := [false, false, false]
@export var types : Array[HiddenElement.HiddenElementType] = [
	HiddenElement.HiddenElementType.BOMB, 
	HiddenElement.HiddenElementType.SPEED, 
	HiddenElement.HiddenElementType.LIFE
]
@export var data_per_type : Array[HiddenElementData] = []

func battery_included() -> bool:
	return type_is_in_game(HiddenElement.HiddenElementType.BATTERY) or config.beacon_shows_battery

func treasure_included() -> bool:
	return type_is_in_game(HiddenElement.HiddenElementType.TREASURE)

func type_is_in_game(tp:HiddenElement.HiddenElementType) -> bool:
	return types.has(tp)

func count() -> int:
	return keys.size()

func get_index_of_type(type:HiddenElement.HiddenElementType) -> int:
	return types.find(type)

func get_index_of_key(key:String) -> int:
	return keys.find(key)

func is_inverted(tp:HiddenElement.HiddenElementType) -> bool:
	var idx := get_index_of_type(tp)
	if idx == -1: return false
	return inverts[idx]

func convert_key_to_type(key:String) -> HiddenElement.HiddenElementType:
	return types[get_index_of_key(key)]

func get_element_range(tp:HiddenElement.HiddenElementType) -> float:
	var base_range : float = config.hidden_element_ranges[get_index_of_type(tp)]
	if config.hidden_element_ranges_make_equal > 0.0:
		base_range = config.hidden_element_ranges_make_equal
	
	var scale := get_data_for_type(tp).range_scale
	return base_range * scale

func get_data_for_type(tp:HiddenElement.HiddenElementType) -> HiddenElementData:
	var type_as_string : String = HiddenElement.HiddenElementType.keys()[tp].to_lower()
	return load("res://map/hidden_elements/types/" + type_as_string + ".tres")

func get_color_for_type(tp:HiddenElement.HiddenElementType) -> Color:
	var color_key : String = keys[get_index_of_type(tp)]
	return config.goggle_colors[color_key]
