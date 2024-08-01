class_name ModuleLives extends Node

var lives := 0
var connected_beacon : PlayerBeacon
var beacon_scene # @TODO

@export var config : ConfigTemplate
@export var map_data : MapData

signal lives_depleted()

func activate(mm:MapModifier) -> void:
	change_lives(config.lives_starting_num)
	create_beacon(mm)

func drain() -> void:
	change_lives(-lives)

func change_lives(dl:int) -> void:
	lives = clamp(lives + dl, 0, config.lives_max)
	
	if lives <= 0:
		lives_depleted.emit()

func create_beacon(mm:MapModifier):
	var b : PlayerBeacon = beacon_scene.instantiate()
	
	var avoid = map_data.get_all_static_objects()
	var pos := map_data.query_position({ "avoid": avoid, "range": 150 })
	b.set_position(pos)
	
	connected_beacon = b
	mm.add_to_layer("entities", b)
