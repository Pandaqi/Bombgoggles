class_name ElementDictionaryModifier extends Node

@export var elem_dict : ElementDictionary
@export var config : ConfigTemplate

func activate() -> void:
	regenerate()

func regenerate() -> void:
	var num_to_generate = elem_dict.count()
	elem_dict.keys.shuffle()

	# determine the inverts order
	var inverts : Array[bool] = []
	for i in range(num_to_generate):
		var inv := randf() <= config.hidden_element_invert_prob
		if config.hidden_element_invert_all: inv = true
		inverts.append(inv)
	
	if config.hidden_element_require_one_invert_each:
		if not inverts.has(false): inverts[0] = false
		if not inverts.has(true): inverts[1] = true
	
	inverts.shuffle()
	elem_dict.inverts = inverts
	
	# determine types included (and order)
	# @TODO: for now just fixed basic types, need to figure out what else and how to mix them in while keeping the game balanced
	var types : Array[HiddenElement.HiddenElementType] = [
		HiddenElement.HiddenElementType.BOMB, 
		HiddenElement.HiddenElementType.SPEED,
		HiddenElement.HiddenElementType.LIFE,
	]  
	types.shuffle()
	elem_dict.types = types
	
	# finally, cache some extra info/calculations based on what we just did
	elem_dict.reload_data()
