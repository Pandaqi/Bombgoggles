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

#
# PROGRESSION
#
@export var prog_max_time := 150 # after this many seconds, we're at "max difficulty" and it's not raised further
@export var prog_element_bounds := { "min": 1.0, "max": 1.5 } # number of elements in map slightly ramps up the longer you play
@export var prog_interact_range_bounds := { "min": 1.0, "max": 1.66 }

#
# HIDDEN ELEMENTS (general)
#
@export var hidden_element_max_dist := 750.0 # beyond this, their slot value is "0"

@export var hidden_element_invert_prob := 0.0
@export var hidden_element_require_one_invert_each := false
@export var hidden_element_invert_all := false

@export var hidden_element_overlap_range := 20 # how close you need to be to trigger it
@export var hidden_element_ranges := [100, 300, 600] # how big the blast is on small, medium and largest slot

@export var bounds_per_type_base := 3 # everything else is scaled according to this

#
# LIVES
#
@export var lives_starting_num := 3
@export var lives_max := 9

#
# BOMBS
#
@export var bombs_come_in_pairs := false

#
# SPEED
# 
@export var speed_default := 50.0
@export var speed_bounds := { "min": 10.0, "max": 100.0 }
@export var speed_change_per_trigger := 2.5
