class_name ConfigTemplate extends Resource

#
# DEBUG
# 
@export var debug_skip_pregame := false
@export var debug_skip_postgame := false
@export var debug_instant_gameover := false
@export var debug_show_hidden_elements := false
@export var debug_cheap_ground_shaders := false

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
@export var map_size_scalar := { "min": 3.0, "max": 3.25 }
@export var map_size_scalar_player_count := [0, 1.0, 1.0, 1.05, 1.1]
@export var map_def_spawn_dist_from_edge := 300.0

@export var min_dist_between_reminders := 375.0
@export var min_dist_between_hidden_elements := 275.0
@export var min_dist_between_beacons := 225.0 # also to hidden elements
@export var min_dist_between_players := 275.0 # also to any hidden elements at spawn

@export var terrain_holes_speed_slowdown := 0.85
@export var terrain_holes_go_haywire := true
@export var terrain_holes_kill_players := false
@export var terrain_deactivates_goggle_of_same_type := true
@export var terrain_deactivates_goggle_radius_decrease := 0.42 # if this rule is true, bomb radius must be severely decreased, otherwise the game is waaay too hard

#
# PROGRESSION
#
@export var prog_max_time := 150 # after this many seconds, we're at "max difficulty" and it's not raised further
@export var prog_element_bounds := { "min": 1.0, "max": 1.5 } # number of elements in map slightly ramps up the longer you play
@export var prog_element_bounds_player_count : Array[float] = [0.0, 1.0, 1.0, 1.25, 1.4]

@export var prog_interact_range_bounds := { "min": 1.0, "max": 1.45 }
@export var prog_speed_escalation_bounds := { "min": 1.0, "max": 1.66 }
@export var prog_battery_drain_rate := { "min": 1.0, "max": 1.45 }
@export var prog_trigger_value_bounds := { "min": 1.0, "max": 2.0 } # goal = at end of game, all triggered hidden elements (without range) do double value

@export var prog_num_plays_before_inversion := 2

#
# HIDDEN ELEMENTS (general)
#
@export var hidden_element_tick := 1.0
@export var hidden_element_max_dist := 1500.0 # beyond this, their slot value is "0"

@export var hidden_element_invert_prob := 0.5 # only used if we've passed `prog_num_plays_before_inversion`; 0.0 otherwise
@export var hidden_element_require_one_invert_each := false
@export var hidden_element_invert_all := false

@export var hidden_element_overlap_range := 66 # how close you need to be to trigger it
@export var hidden_element_ranges := [433, 875, 1350] # how big the blast is on small, medium and largest slot
@export var hidden_element_ranges_make_equal := 850.0 # if non-zero, it overrides the other ranges and just uses the same one for all

@export var bounds_per_type_base := 2 # everything else is scaled according to this

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
@export var speed_default := 575.0
@export var speed_bounds := { "min": 225.0, "max": 950.0 }
@export var speed_change_per_trigger := 75.0

#
# TREASURE
#
@export var treasure_needed_to_win := 5

#
# BATTERY
#
@export var battery_drain_rate := 0.065 # per second; full battery is 1.0
@export var battery_speed_reduction_if_empty := 0.985
@export var battery_change_per_trigger := 0.66
@export var battery_empty_loses_life := true

#
# BEACONS
#
@export var beacon_move_on_interact := true
@export var beacon_recharge_on_interact := true
@export var beacon_shows_direction := false # @TODO: Implement
@export var beacon_shows_battery := true
@export var beacon_interact_makes_haywire := true
@export var beacon_overlap_range := 96.0

#
# GOGGLES
#
@export var goggle_haywire_duration = { "min": 0.25, "max": 0.5 }
@export var goggle_accuracy_bounds = { "min": 0.9, "max": 1.0 }
@export var goggle_accuracy_loss_on_life_loss := true
@export var goggle_colors : Dictionary = {
	"red": Color(255/255.0, 130/255.0, 130/255.0),
	"green": Color(105/255.0, 255/255.0, 108/255.0),
	"blue": Color(188/255.0, 205/255.0, 255/255.0)
}
@export var goggle_battery_shows_battery_power := false

#
# BOT
# 
@export var bot_search_range := 650.0
@export var bot_random_walk_range := 350.0
@export var bot_battery_power_to_run_back := 0.2
@export var bot_is_immune_to_self_bombs := true
@export var bot_speed_factor := 0.875
