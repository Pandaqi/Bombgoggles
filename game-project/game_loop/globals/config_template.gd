class_name ConfigTemplate extends Resource

#
# DEBUG
# 
@export var debug_skip_pregame := true
@export var debug_skip_postgame := false
@export var debug_instant_gameover := false
@export var debug_show_hidden_elements := true
@export var debug_cheap_ground_shaders := true

#
# MISC
#
@export var camera_edge_margin := Vector2(32.0, 32.0)
@export var countdown_num_seconds := 3

@export var player_colors : Array[Color] = [
	Color(255/255.0, 217/255.0, 119/255.0),
	Color(145/255.0, 255/255.0, 237/255.0),
	Color(255/255.0, 155/255.0, 248/255.0),
	Color(244/255.0, 255/255.0, 184/255.0)
]

#
# MAP
#
@export var map_size_base := Vector2(1280, 720)
@export var sprite_size_base := 256.0
@export var map_size_scalar := { "min": 3.25, "max": 4.0 }
@export var map_size_scalar_player_count := [0, 1.0, 1.0, 1.25, 1.5]
@export var map_def_spawn_dist_from_edge := 200.0

@export var min_dist_between_reminders := 350.0
@export var min_dist_between_hidden_elements := 200.0
@export var min_dist_between_beacons := 300.0
@export var min_dist_between_players := 225.0 # also to any hidden elements at spawn

@export var terrain_kill_players_in_holes := true 
@export var terrain_locks_goggles_of_same_type := true

#
# PROGRESSION
#
@export var prog_max_time := 150 # after this many seconds, we're at "max difficulty" and it's not raised further
@export var prog_element_bounds := { "min": 1.0, "max": 1.5 } # number of elements in map slightly ramps up the longer you play
@export var prog_interact_range_bounds := { "min": 1.0, "max": 1.66 }
@export var prog_speed_escalation_bounds := { "min": 1.0, "max": 1.5 }

@export var prog_element_bounds_player_count := [0.0, 1.0, 1.0, 1.25, 1.4]
@export var prog_battery_drain_rate := { "min": 1.0, "max": 1.45 }
@export var prog_trigger_value_bounds := { "min": 1.0, "max": 2.0 } # at end of game, all triggered hidden elements (without range) do double value

#
# HIDDEN ELEMENTS (general)
#
@export var hidden_element_tick := 1.0
@export var hidden_element_max_dist := 1500.0 # beyond this, their slot value is "0"

@export var hidden_element_invert_prob := 0.0
@export var hidden_element_require_one_invert_each := false
@export var hidden_element_invert_all := false

@export var hidden_element_overlap_range := 66 # how close you need to be to trigger it
@export var hidden_element_ranges := [375, 785, 1150] # how big the blast is on small, medium and largest slot

@export var bounds_per_type_base := 3 # everything else is scaled according to this

#
# LIVES
#
@export var lives_starting_num := 3
@export var lives_max := 3

#
# BOMBS
#
@export var bombs_come_in_pairs := false

#
# SPEED
# 
@export var speed_default := 450.0
@export var speed_bounds := { "min": 150.0, "max": 750.0 }
@export var speed_change_per_trigger := 75

#
# TREASURE
#
@export var treasure_needed_to_win := 5

#
# BATTERY
#
@export var battery_drain_rate := 0.1 # per second; full battery is 1.0
@export var battery_speed_reduction_if_empty := 0.4
@export var battery_change_per_trigger := 0.5

#
# BEACONS
#
@export var beacon_move_on_interact := true
@export var beacon_recharge_on_interact := true
@export var beacon_shows_direction := false # @TODO: Implement
@export var beacon_shows_battery := true
@export var beacon_interact_makes_haywire := true

#
# GOGGLES
#
@export var goggle_haywire_duration = { "min": 0.25, "max": 0.5 }
@export var goggle_accuracy_bounds = { "min": 0.75, "max": 1.0 }
@export var goggle_accuracy_loss_on_life_loss := true
@export var goggle_colors : Dictionary = {
	"red": Color(255/255.0, 130/255.0, 130/255.0),
	"green": Color(105/255.0, 255/255.0, 108/255.0),
	"blue": Color(188/255.0, 205/255.0, 255/255.0)
}
@export var goggle_battery_shows_battery_power := false
