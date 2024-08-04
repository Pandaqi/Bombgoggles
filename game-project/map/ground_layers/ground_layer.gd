class_name GroundLayer extends Sprite2D

var hole_centers : Array[Vector2] = []
var hole_radii : Array[float] = []
var layer_num : int
var type : HiddenElement.HiddenElementType

@export var config : ConfigTemplate
@export var elem_dict : ElementDictionary

const TOP_LAYER := Color(91/255.0, 203/255.0, 63/255.0)
const MAX_SIZE := 20

signal terrain_changed()

func init(num:int, size:Vector2) -> void:
	layer_num = num
	
	var color := TOP_LAYER
	type = HiddenElement.HiddenElementType.NONE
	
	if num == 0:
		var noise_tex : NoiseTexture2D = material.get_shader_parameter("noise")
		noise_tex.noise.seed = randi() % 1000
	
	if num > 0:
		type = elem_dict.types[num-1]
		color = elem_dict.get_color_for_type(type)
	
	material = material.duplicate(false)
	
	var cheap_shaders := OS.is_debug_build() and config.debug_cheap_ground_shaders
	var floor_scale := (1.0/128.0) * size
	set_scale(floor_scale)
	if not cheap_shaders: 
		material.shader = material.shader.duplicate(false)
	material.set_shader_parameter("size_real", size)
	material.set_shader_parameter("color", color)
	
	

func is_already_hole_at(pos:Vector2) -> bool:
	for i in range(hole_centers.size()):
		var dist := pos.distance_to(hole_centers[i])
		var max_range := hole_radii[i]
		if dist <= max_range:
			return true
	return false

func register_hole(pos:Vector2, radius:float) -> void:
	# @NOTE: the shader requires a fixed size, so we must ensure our holes list never exceeds this
	# Players probably won't notice and the max shouldn't be reached too often
	if hole_centers.size() >= MAX_SIZE:
		hole_centers.pop_front()
		hole_radii.pop_front()
	
	hole_centers.append(pos)
	hole_radii.append(radius)
	material.set_shader_parameter("hole_centers", hole_centers)
	material.set_shader_parameter("hole_radii", hole_radii)
	
	terrain_changed.emit()
