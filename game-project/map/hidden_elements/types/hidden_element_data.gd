class_name HiddenElementData extends Resource

@export var min_num := 1.0 # these are for spawning on the map; they are scaled dynamically
@export var max_num := 1.0
@export var min_num_abs := -1.0 # if set (not -1), these are hard absolute limits that aren't changed in any way
@export var max_num_abs := -1.0
@export var frame := 0 # the frame in the spritesheet to display
@export var desc := "" # the description displayed on the reminder
@export var desc_inv := "" # the description displayed if inverted 
@export var hide_icon := false
@export var range_scale := 1.0
