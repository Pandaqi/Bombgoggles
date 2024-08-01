extends Camera2D

const MOVE_SPEED := 8.0
const ZOOM_SPEED := 8.0

@export var map_data : MapData
@export var config : ConfigTemplate

func _process(dt:float):
	fit_bounds_in_view(dt)

func fit_bounds_in_view(dt:float):
	var map_bounds : Rect2 = map_data.bounds
	if not map_bounds: return
	
	var target_position := map_bounds.get_center()
	
	var vp_size := get_viewport_rect().size - 2*config.camera_edge_margin
	var map_size := map_bounds.size
	var ratios := vp_size / map_size
	
	var target_zoom : Vector2 = min(ratios.x, ratios.y) * Vector2.ONE
	
	var move_factor := MOVE_SPEED*dt
	var zoom_factor := ZOOM_SPEED*dt
	set_position(get_position().lerp(target_position, move_factor))
	set_zoom(get_zoom().lerp(target_zoom, zoom_factor))
