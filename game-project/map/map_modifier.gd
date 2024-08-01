class_name MapModifier extends Node2D

@export var map_data : MapData
@export var elem_dict : ElementDictionary

@onready var floor_sprite : Sprite2D = $MapLayers/Floor
@onready var spawner : MapElementsSpawner = $MapElementsSpawner

@export var element_reminder_scene : PackedScene

# @TODO: this might become its own subclass "MapLayers" or something, but not needed now
@onready var layers : Dictionary = {
	"floor": $MapLayers/Floor,
	"entities": $MapLayers/Entities
}

func activate() -> void:
	determine_base_size()
	place_element_reminders()
	spawner.activate()

func determine_base_size() -> void:
	var size := Vector2(1280, 720) # @TODO: randomize, set somewhere, whatever
	map_data.bounds = Rect2(0, 0, size.x, size.y)
	
	var floor_scale := (1.0/128.0) * size
	floor_sprite.set_scale(floor_scale)

func place_element_reminders():
	for type in elem_dict.types:
		var r = element_reminder_scene.instantiate()
		var new_pos = map_data.query_position({ "avoid": map_data.element_reminders, "range": 150.0 })
		r.set_position(new_pos)
		add_to_layer("entities", r)
		r.set_type(type)
		map_data.add_element_reminder(r)

func add_to_layer(layer_name:String, entity:Node) -> void:
	layers[layer_name].add_child(entity)
