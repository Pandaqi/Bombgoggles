extends Node

enum InputDevice
{
	KEYBOARD,
	GAMEPAD
}

enum InputError
{
	DEFAULT = -100,
	DEVICE_ALREADY_REGISTERED = -101,
	MAX_DEVICES_REACHED = -102,
	CANT_REMOVE_DEVICE = -103,
	CANT_SPLIT_DEVICE = -104,
	CANT_COMBINE_DEVICE = -105
}

const keyboard_inputs = [
	[KEY_RIGHT, KEY_DOWN, KEY_LEFT, KEY_UP, KEY_SPACE],
	[KEY_D, KEY_S, KEY_A, KEY_W, KEY_T],
	[KEY_K, KEY_J, KEY_H, KEY_U, KEY_P],
	[KEY_B, KEY_V, KEY_C, KEY_F, KEY_Z]
]

const gamepad_inputs = [
	[
		[JOY_AXIS_LEFT_X, JOY_BUTTON_DPAD_RIGHT], 
		[JOY_AXIS_LEFT_Y, JOY_BUTTON_DPAD_DOWN], 
		[JOY_AXIS_LEFT_X, JOY_BUTTON_DPAD_LEFT],
		[JOY_AXIS_LEFT_Y, JOY_BUTTON_DPAD_UP],
		[JOY_BUTTON_X, JOY_BUTTON_Y, JOY_BUTTON_LEFT_SHOULDER, JOY_AXIS_TRIGGER_LEFT]
	],
	[
		JOY_AXIS_RIGHT_X, 
		JOY_AXIS_RIGHT_Y, 
		JOY_AXIS_RIGHT_X, 
		JOY_AXIS_RIGHT_Y, 
		[JOY_BUTTON_A, JOY_BUTTON_B, JOY_BUTTON_RIGHT_SHOULDER, JOY_AXIS_TRIGGER_RIGHT]
	]
]

# If 0, the input given is NOT a joystick so dir doesn't matter
const gamepad_input_dirs = [[1,0],[1,0],[-1,0],[-1,0],[0,0,0,1]]
const input_order : Array[String] = ["right", "down", "left", "up", "interact"]

# DICTIONARY that links "device id" to "player(s) using it"
var devices = {}

# ARRAY that links "player num" ( = index) to data about them "{ device, split }"
var device_order = []

# the "maximum player count" for the game
const max_devices : int = 4

# into how many players the keyboard can be split
const max_keyboard_devices : int = 4
var num_keyboard_players : int = 0

const max_gamepad_devices : int = 4
var max_splits_per_gamepad : int = 2

# for handling an axis (usually left/right triggers) as a BUTTON
const AXIS_AS_BUTTON_THRESHOLD : float = 0.9
var last_axis_val = {}

func _ready():
	build_device_dictionaries()
	build_input_map()
	build_ui_input_map()

func create_debugging_players():
	if not OS.is_debug_build(): return
	if get_player_count() > 0: return
	
	for i in range(1):
		add_new_player(InputDevice.KEYBOARD)

#
# Auto-fill the input map with all the right controls
#
func build_device_dictionaries():
	devices["-1"] = []
	for i in range(max_gamepad_devices):
		devices[str(i)] = []

func build_key(action, device, split):
	return action + "_" + str(device) + "_" + str(split)

func build_input_action(key, ev):
	if not InputMap.has_action(key): InputMap.add_action(key)
	InputMap.action_add_event(key, ev)

func build_ui_input_map():
	var ev
	
	#
	# Player login/logout
	#
	ev = InputEventKey.new()
	ev.keycode = KEY_ENTER
	build_input_action("add_keyboard_player", ev)
	
	ev = InputEventKey.new()
	ev.keycode = KEY_ESCAPE
	build_input_action("remove_keyboard_player", ev)
	
	#
	# Pause Menu
	#
	
	# opening/closing the menu
	ev = InputEventKey.new()
	ev.keycode = KEY_ESCAPE
	build_input_action("toggle_pause_menu", ev)
	
	ev = InputEventJoypadButton.new()
	ev.device = 0
	ev.button_index = JOY_BUTTON_BACK
	build_input_action("toggle_pause_menu", ev)
	
	ev = InputEventJoypadButton.new()
	ev.device = 0
	ev.button_index = JOY_BUTTON_START
	build_input_action("toggle_pause_menu", ev)
	
	# quitting out of this round
	ev = InputEventKey.new()
	ev.keycode = KEY_SPACE
	build_input_action("pause_menu_exit", ev)
	
	ev = InputEventJoypadButton.new()
	ev.device = 0
	ev.button_index = 0
	build_input_action("pause_menu_exit", ev)
	
	#
	# Game over
	#
	
	# restart
	ev = InputEventKey.new()
	ev.keycode = KEY_SPACE
	build_input_action("game_over_restart", ev)
	
	ev = InputEventJoypadButton.new()
	ev.device = 0
	ev.button_index = 0
	build_input_action("game_over_restart", ev)
	
	# back to menu
	ev = InputEventKey.new()
	ev.keycode = KEY_ESCAPE
	build_input_action("game_over_back", ev)
	
	ev = InputEventJoypadButton.new()
	ev.device = 0
	ev.button_index = 1
	build_input_action("game_over_back", ev)
	
	#
	# Settings
	#
	ev = InputEventKey.new()
	ev.keycode = KEY_ESCAPE
	build_input_action("close_settings", ev)
	
	ev = InputEventJoypadButton.new()
	ev.device = 0
	ev.button_index = 1
	build_input_action("close_settings", ev)
	
	ev = InputEventKey.new()
	ev.keycode = KEY_ESCAPE
	build_input_action("quit_game", ev)
	
	ev = InputEventJoypadButton.new()
	ev.device = 0
	ev.button_index = JOY_BUTTON_BACK
	build_input_action("quit_game", ev)

func build_input_map():
	#
	# Keyboard players
	# One device (-1), Four splits across it
	#
	for i in range(max_keyboard_devices):
		var id = -1
		var split = i
		
		for j in range(input_order.size()):
			var action = input_order[j]
			var key = build_key(action, id, split)
			var ev = InputEventKey.new()
			ev.keycode = keyboard_inputs[i][j]
			
			build_input_action(key, ev)
	
	#
	# Controller Players
	# One device per player, Two splits per device
	#
	for i in range(max_gamepad_devices):
		var id = i
		
		for s in range(max_splits_per_gamepad):
			var split = s
			var my_inputs = gamepad_inputs[split]
			
			for j in range(input_order.size()):
				var action = input_order[j]
				var key = build_key(action, id, split)
				
				var list = my_inputs[j]
				if not (list is Array): list = [list]
				
				var dir_list = gamepad_input_dirs[j]
				if not (dir_list is Array): dir_list = [dir_list]
				
				var num_options = min(list.size(), dir_list.size())
				
				for l in range(num_options):
					var btn_index = list[l]
					var input_dir = dir_list[l]
					
					var is_a_joystick = (input_dir != 0)
					
					if is_a_joystick:
						var ev = InputEventJoypadMotion.new()
						ev.set_device(id)
						ev.set_axis(btn_index)
						ev.set_axis_value(input_dir)
						
						build_input_action(key, ev)
					
					else:
						var ev = InputEventJoypadButton.new()
						ev.button_index = btn_index
						ev.set_device(id)
						build_input_action(key, ev)

func print_input_map():
	var ac = InputMap.get_actions()
	for action in ac:
		print("== ACTION == ")
		print(action)
		var input_list = InputMap.action_get_events(action)
		
		for inp in input_list:
			if not (inp is InputEventJoypadMotion): continue
			
			print(inp.as_text())

#
# Handle the actual EVENTS used to add/remove devices
#
func check_new_player(ev) -> InputManagerEvent:
	var data = InputManagerEvent.new()
	
	var res = check_new_gamepad(ev)
	if not is_error_code(res): 
		data.succeed(res, get_last_added_player())
		return data
	
	res = check_new_keyboard(ev)
	if not is_error_code(res):
		data.succeed(res, get_last_added_player())
		return data
		
	return data

func check_new_gamepad(ev):
	if not (ev is InputEventJoypadButton): return InputError.DEFAULT
	if ev.pressed: return InputError.DEFAULT
	if device_already_registered(ev.device): return InputError.DEVICE_ALREADY_REGISTERED
	
	return add_new_player(InputDevice.GAMEPAD, ev.device)

func check_new_keyboard(ev): 
	if not ev.is_action_released("add_keyboard_player"): return InputError.DEFAULT
	return add_new_player(InputDevice.KEYBOARD)

func check_remove_player(ev) -> InputManagerEvent:
	var data = InputManagerEvent.new()
	
	var res = check_remove_gamepad(ev)
	if not is_error_code(res): 
		data.succeed(res)
		return data
	
	res = check_remove_keyboard(ev)
	if not is_error_code(res): 
		data.succeed(res)
		return data
	
	return data

func is_error_code(val:int) -> bool:
	return val < -1

func check_remove_gamepad(ev):
	if not (ev is InputEventJoypadButton): return InputError.DEFAULT
	if ev.pressed: return InputError.DEFAULT
	if ev.button_index != 1: return InputError.DEFAULT
	
	var device_id : int = ev.device
	if not device_already_registered(device_id): return InputError.CANT_REMOVE_DEVICE
	
	var p_num = get_player_from_device(device_id)
	return remove_player(p_num)

func check_remove_keyboard(ev):
	if not ev.is_action_released("remove_keyboard_player"): return InputError.DEFAULT
	if get_num_keyboard_players() <= 0: return InputError.CANT_REMOVE_DEVICE
	
	var p_num = find_last_keyboard_player()
	return remove_player(p_num)

#
# Handle (un)registering input devices
#
func split_gamepad(id : int) -> Dictionary:
	if device_is_split(id): return { 'err': InputError.CANT_SPLIT_DEVICE }
	
	# update the current owner
	var cur_player_num = devices[str(id)][0]
	device_order[cur_player_num].splits = [0]

	# add new player for next one
	add_new_player(InputDevice.GAMEPAD, id, [1])
	var new_player : int = get_last_added_player()

	return {
		'p1': cur_player_num,
		'p2': new_player
	}

func split_gamepad_for_player(p_num : int) -> Dictionary:
	var device = device_order[p_num].device
	return split_gamepad(device)

func unsplit_gamepad(id : int) -> Dictionary:
	if not device_is_split(id): return { 'err': InputError.CANT_COMBINE_DEVICE }
	
	# remove last player completely
	var last_player_num = devices[str(id)][1]
	remove_player(last_player_num)

	# update remaining owner to full control
	var cur_player_num = devices[str(id)][0]
	device_order[cur_player_num].splits = [0,1]
	
	return {
		'p1': last_player_num,
		'p2': cur_player_num
	}

func unsplit_gamepad_for_player(p_num : int) -> Dictionary:
	var device = device_order[p_num].device
	return unsplit_gamepad(device)

func add_new_player(type:InputDevice, id : int = -1, custom_splits : Array = []) -> int:
	if max_devices_reached(): return InputError.MAX_DEVICES_REACHED
	if type == InputDevice.KEYBOARD and num_keyboard_players >= max_keyboard_devices: return InputError.MAX_DEVICES_REACHED
	
	# if a gamepad was already registered, and we're NOT asking to split, don't do anything
	if type == InputDevice.GAMEPAD:
		if device_already_registered(id) and not custom_splits.size() > 0:
			return InputError.DEVICE_ALREADY_REGISTERED
	
	# determine the right splits
	var split = [0,1]
	if type == InputDevice.KEYBOARD:
		split = [num_keyboard_players]
	else:
		if custom_splits.size() != 0:
			split = custom_splits
	
	# add player data
	var player_data = { 'device': id, 'splits': split }
	device_order.append(player_data)
	
	# link to device dictionary
	var player_num = device_order.size() - 1
	devices[str(id)].append(player_num)

	if type == InputDevice.KEYBOARD: num_keyboard_players += 1

	return id

# NOTE: we receive a PLAYER NUMBER, not device ID, as that doesn't make sense here
func remove_player(player_num : int = -1):
	if no_devices_registered(): return InputError.CANT_REMOVE_DEVICE
	
	# figure out our device id and type
	var device_id = device_order[player_num].device
	var split = get_split_status_for(player_num)
	var is_keyboard = (device_id < 0)

	if not device_already_registered(device_id): return InputError.CANT_REMOVE_DEVICE

	# remove the player completely
	device_order.remove_at(player_num)
	
	# remove our _entry_ from the device (otherwise we ruin splits if someone else shares the same device)
	devices[str(device_id)].erase(player_num)
	
	# move all player_nums AFTER the removed one downwards by 1
	# (otherwise all their links are wrong)
	for id in devices:
		for i in range(devices[id].size()):
			if devices[id][i] <= player_num: continue
			devices[id][i] -= 1
	
	# ensure KEYBOARD SPLITS are also moved down by 1
	# (if they are later than our removed split)
	if is_keyboard: 
		num_keyboard_players -= 1
		
		for obj in device_order:
			if obj.device != -1: continue
			if obj.splits[0] < split: continue
			obj.splits[0] -= 1

	return device_id

#
# Convert a specific action to polling the right set of keys
#

# checked from _input(), one-time event
func is_action_pressed(ev, action : String, player_num : int) -> bool:
	if player_doesnt_exist(player_num): return false
	
	var splits = device_order[player_num].splits
	var device = device_order[player_num].device

	for split in splits:
		var key = build_key(action, device, split)
		if ev.is_action_pressed(key): return true
	
	return false

# checked from _input(), one-time event
func is_action_released(ev, action : String, player_num : int) -> bool:
	if player_doesnt_exist(player_num): return false
	
	var splits = device_order[player_num].splits
	var device = device_order[player_num].device

	for split in splits:
		var key = build_key(action, device, split)
		if ev.is_action_released(key): return true
	
	return false

# checked in _process() or anywhere else (probs continuously)
func is_action_down(action : String, player_num : int) -> bool:
	if player_doesnt_exist(player_num): return false
	
	var splits = device_order[player_num].splits
	var device = device_order[player_num].device

	for split in splits:
		var key = build_key(action, device, split)
		if Input.is_action_pressed(key): return true
	
	return false

func get_action_strength(action : String, player_num : int) -> float:
	if player_doesnt_exist(player_num): return 0.0
	
	var splits = device_order[player_num].splits
	var device = device_order[player_num].device

	var aggregate : float = 0.0
	for split in splits:
		var key = build_key(action, device, split)
		aggregate += Input.get_action_strength(key)
	
	aggregate = clamp(aggregate, -1, 1)
	return aggregate

# Special function for polling an AXIS as if it were a button
func is_axis_action_released(action : String, player_num : int) -> bool:
	if player_doesnt_exist(player_num): return false
	
	var splits = device_order[player_num].splits
	var device = device_order[player_num].device

	var axis_strength : float = 0.0
	for split in splits:
		var key = build_key(action, device, split)
		axis_strength += Input.get_action_strength(key)
	
	var should_release : bool = false
	var dict_key = str(player_num)
	if last_axis_val.has(dict_key):
		should_release = (axis_strength <= AXIS_AS_BUTTON_THRESHOLD and last_axis_val[str(player_num)] >= AXIS_AS_BUTTON_THRESHOLD)
	
	last_axis_val[str(player_num)] = axis_strength
	return should_release

# Special function because I need it in every game
func get_move_vec(player_num : int) -> Vector2:
	var dirs = ["right", "left", "down", "up"]
	var h = get_action_strength(dirs[0], player_num) - get_action_strength(dirs[1], player_num)
	var v = get_action_strength(dirs[2], player_num) - get_action_strength(dirs[3], player_num)
	
	return Vector2(h,v).normalized()

#
# Helpers/Queries for ourselves and things using us
#
func get_last_added_player():
	return device_order.size() - 1

func find_last_keyboard_player():
	for i in range(device_order.size()-1,-1,-1):
		var data = device_order[i]
		if data.device == -1:
			return i
	
	return -1

func remove_last_keyboard_player():
	return remove_player(find_last_keyboard_player())

func get_keyboard_keys_for_player(player_num : int) -> Dictionary:
	if not is_keyboard_player(player_num): return {}
	var data = device_order[player_num]
	var dict : Dictionary = {}
	for i in range(input_order.size()):
		dict[input_order[i]] = keyboard_inputs[data.splits[0]][i]
	return dict
	
	# OTHERWISE, we'd have to re-check every key and what inputs it has, which is just not needed so far
	#var dict : Dictionary = {}
	#for action in input_order:
		#var key = build_key(action, data.device, data.splits[0])
		#dict[ev] = 
	#InputMap.action_get_events("")

func player_doesnt_exist(player_num : int) -> bool:
	return player_num >= device_order.size()

func device_is_split(id : int) -> bool:
	return devices[str(id)].size() > 1

func player_is_split(p_num : int) -> bool:
	var device = device_order[p_num].device
	return device_is_split(device)

func no_devices_registered() -> bool:
	return (get_player_count() <= 0)

func max_devices_reached() -> bool:
	return (get_player_count() >= max_devices)

func device_already_registered(id : int) -> bool:
	return devices.has(str(id)) and devices[str(id)].size() > 0

func get_player_count() -> int:
	return device_order.size()

func has_connected_device(player_num : int) -> bool:
	return player_num < device_order.size()

func get_device_id(player_num : int) -> int:
	return device_order[player_num].device

func get_player_from_device(device_id : int) -> int:
	for i in range(device_order.size()):
		if device_order[i].device == device_id:
			return i
	return -1

func is_keyboard_player(player_num : int) -> bool:
	return (get_device_id(player_num) < 0)

func get_num_keyboard_players() -> int:
	return num_keyboard_players

func get_split_status_for(player_num : int) -> int:
	return device_order[player_num].splits[0]
