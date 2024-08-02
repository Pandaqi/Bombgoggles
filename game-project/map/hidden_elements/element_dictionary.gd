class_name ElementDictionary extends Resource

@export var config : ConfigTemplate
@export var keys := ["red", "green", "blue"]
@export var inverts := [false, false, false]
@export var types : Array[HiddenElement.HiddenElementType] = [
	HiddenElement.HiddenElementType.BOMB, 
	HiddenElement.HiddenElementType.SPEED, 
	HiddenElement.HiddenElementType.LIFE
]
@export var data_per_type : Array[HiddenElementData] = []

func type_is_in_game(tp:HiddenElement.HiddenElementType) -> bool:
	return types.has(tp)

func reload_data():
	data_per_type = []
	for type in types:
		var type_string : String = HiddenElement.HiddenElementType.keys()[type].to_lower()
		print(type_string)
		data_per_type.append(load("res://map/hidden_elements/types/" + type_string + ".tres"))

func count() -> int:
	return keys.size()

func get_index_of_type(type:HiddenElement.HiddenElementType) -> int:
	return types.find(type)

func get_index_of_key(key:String) -> int:
	return keys.find(key)

func is_inverted(tp:HiddenElement.HiddenElementType) -> bool:
	return inverts[get_index_of_type(tp)]

func convert_key_to_type(key:String) -> HiddenElement.HiddenElementType:
	return types[get_index_of_key(key)]

func get_element_range(tp:HiddenElement.HiddenElementType) -> float:
	return config.hidden_element_ranges[get_index_of_type(tp)]

func get_data_for_type(tp:HiddenElement.HiddenElementType) -> HiddenElementData:
	return data_per_type[get_index_of_type(tp)]

func get_color_for_type(tp:HiddenElement.HiddenElementType) -> Color:
	var color_key : String = keys[get_index_of_type(tp)]
	return config.goggle_colors[color_key]
