class_name ElementDictionaryModifier extends Node

@export var elem_dict : ElementDictionary
@export var config : ConfigTemplate
@export var players_data : PlayersData

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
	
	var types_possible := elem_dict.all_types.duplicate(false)
	var types : Array[HiddenElement.HiddenElementType] = []
	
	# every game has the bomb
	types.append(HiddenElement.HiddenElementType.BOMB)
	
	# on single player, treasure is always included
	if players_data.single_player:
		types.append(HiddenElement.HiddenElementType.TREASURE)
	
	# if battery is not a thing, remove it from the options
	if not config.beacon_shows_battery:
		types_possible.erase(HiddenElement.HiddenElementType.BATTERY)
	
	# now just fill up randomly
	types_possible.shuffle()
	while types.size() < elem_dict.keys.size():
		types.append(types_possible.pop_back())
	
	types.shuffle()
	elem_dict.types = types
	
	# finally, cache some extra info/calculations based on what we just did
	elem_dict.reload_data()
