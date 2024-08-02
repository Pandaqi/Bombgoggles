class_name ConfigTemplate extends Resource

#
# DEBUG
# 
@export var debug_skip_pregame := true
@export var debug_skip_postgame := false
@export var debug_instant_gameover := false
@export var debug_show_hidden_elements := true

#
# MISC
#
@export var camera_edge_margin := Vector2(32.0, 32.0)
@export var countdown_num_seconds := 3
@export var goggle_colors : Dictionary = {
	"red": Color(255/255.0, 130/255.0, 130/255.0),
	"green": Color(105/255.0, 255/255.0, 108/255.0),
	"blue": Color(188/255.0, 205/255.0, 255/255.0)
}
@export var player_colors : Array[Color] = [
	Color(255/255.0, 217/255.0, 119/255.0),
	Color(145/255.0, 255/255.0, 237/255.0),
	Color(255/255.0, 155/255.0, 248/255.0),
	Color(244/255.0, 255/255.0, 184/255.0)
]

#
# MAP
#
var map_size_base := Vector2(1280, 720)
var sprite_size_base := 256.0
var map_size_scalar := { "min": 3.5, "max": 4.25 }

var min_dist_between_reminders := 350.0
var min_dist_between_hidden_elements := 200.0
var min_dist_between_beacons := 300.0
var min_dist_between_players := 350.0

#
# PROGRESSION
#
@export var prog_max_time := 150 # after this many seconds, we're at "max difficulty" and it's not raised further
@export var prog_element_bounds := { "min": 1.0, "max": 1.5 } # number of elements in map slightly ramps up the longer you play
@export var prog_interact_range_bounds := { "min": 1.0, "max": 1.66 }
@export var prog_speed_escalation_bounds := { "min": 1.0, "max": 1.5 }

#
# HIDDEN ELEMENTS (general)
#
@export var hidden_element_tick := 1.0
@export var hidden_element_max_dist := 1500.0 # beyond this, their slot value is "0"

@export var hidden_element_invert_prob := 0.0
@export var hidden_element_require_one_invert_each := false
@export var hidden_element_invert_all := false

@export var hidden_element_overlap_range := 66 # how close you need to be to trigger it
@export var hidden_element_ranges := [250, 650, 1200] # how big the blast is on small, medium and largest slot

@export var bounds_per_type_base := 3 # everything else is scaled according to this

#
# LIVES
#
@export var lives_starting_num := 3
@export var lives_max := 3

#
# BOMBS
#
@export var bombs_come_in_pairs := false # @TODO: Implement

#
# SPEED
# 
@export var speed_default := 450.0
@export var speed_bounds := { "min": 150.0, "max": 750.0 }
@export var speed_change_per_trigger := 75

#
# BEACONS
#
@export var beacon_move_on_interact := true
@export var beacon_recharge_on_interact := true
@export var beacon_shows_direction := false # @TODO: Implement
