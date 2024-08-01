extends CenterContainer

@onready var sprite : Sprite2D = $Control/Node2D/Sprite2D
var player_num:int = -1

const ARROW_KEY_ROTATIONS : Dictionary = {
	"Left": PI,
	"Up": 1.5*PI,
	"Down": 0.5*PI,
	"Right": 0
}

@onready var labels : Dictionary = {
	"right": $Control/Node2D/LabelRight,
	"down": $Control/Node2D/LabelBottom,
	"left": $Control/Node2D/LabelLeft,
	"up": $Control/Node2D/LabelTop
}

func set_player_num(p_num:int):
	player_num = p_num
	
	var is_keyboard := GInput.is_keyboard_player(player_num)
	
	var frame := 9
	if is_keyboard: frame = 8
	sprite.set_frame(frame)
	
	for key in labels:
		labels[key].set_visible(is_keyboard)
	
	if is_keyboard:
		var keys_raw = GInput.get_keyboard_keys_for_player(player_num)
		for key in keys_raw:
			if not (key in labels): continue
			
			var key_conv := OS.get_keycode_string(keys_raw[key])
			#var label_rot := 0
			var label : Label = labels[key]
			if ["Left", "Right", "Up", "Down"].has(key_conv):
				# for some fucking reason this doesn't set rotation correctly, so we just do the opposite:
				# all keys are rotated for arrow keys by default, and if they're not, we just set them to 0
				#label_rot = ARROW_KEY_ROTATIONS[key_conv]
				key_conv = ">"
			else:
				label.set_rotation(0)
				
			label.set_text(key_conv)
			
		
	
	
