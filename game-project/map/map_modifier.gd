class_name MapModifier extends Node2D

@export var config : ConfigTemplate
@export var map_data : MapData
@export var elem_dict : ElementDictionary
@export var ground_layer_scene : PackedScene

@onready var spawner : MapElementsSpawner = $MapElementsSpawner

@export var element_reminder_scene : PackedScene

# @TODO: this might become its own subclass "MapLayers" or something, but not needed now
@onready var layers : Dictionary = {
	"floor": $MapLayers/Floor,
	"entities": $MapLayers/Entities,
	"top": $MapLayers/Top
}

func activate() -> void:
	map_data.reset()
	determine_base_size()
	create_ground_layers()
	place_element_reminders()
	spawner.activate()

func determine_base_size() -> void:
	# @TODO: scale with player count?
	var size := config.map_size_base * randf_range(config.map_size_scalar.min, config.map_size_scalar.max)
	map_data.bounds = Rect2(0, 0, size.x, size.y)

func create_ground_layers() -> void:
	var num_floors := 4 # TOP layer + the 3 colors
	for i in range(num_floors):
		var layer_num = num_floors - 1 - i # @NOTE: must be inverted because the LAST node will be shown on TOP and must be number 0
		var f = ground_layer_scene.instantiate()
		add_to_layer("floor", f)
		f.init(layer_num, map_data.bounds.size)
		
		map_data.add_ground_layer(f)

func erase_ground_layer_at(pos:Vector2, range:float) -> void:
	var children_rev = layers.floor.get_children()
	children_rev.reverse()
	for child in children_rev:
		var fallthrough = child.is_already_hole_at(pos)
		child.register_hole(pos, range)
		if not fallthrough: break

func place_element_reminders():
	for type in elem_dict.types:
		var r = element_reminder_scene.instantiate()
		var new_pos = map_data.query_position({ "avoid": map_data.element_reminders, "range": config.min_dist_between_reminders, "avoid_edge": true })
		r.set_position(new_pos)
		add_to_layer("entities", r)
		r.set_type(type)
		map_data.add_element_reminder(r)

func add_to_layer(layer_name:String, entity:Node) -> void:
	layers[layer_name].add_child(entity)
