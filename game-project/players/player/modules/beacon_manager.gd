class_name ModuleBeaconManager extends Node

@export var beacon_scene : PackedScene
@export var map_data : MapData
@export var config : ConfigTemplate

var connected_beacon : PlayerBeacon
var player_num : int = -1

func activate(n:int, l:ModuleLives, t:ModuleTreasureTracker, b:ModuleBattery, mm:MapModifier) -> void:
	player_num = n
	
	l.lives_changed.connect(on_lives_changed)
	t.treasure_changed.connect(on_treasure_changed)
	b.battery_changed.connect(on_battery_changed)
	create_beacon(mm)

# @NOTE: there was once a plan for multiple beacons, but it's juts a single one in the end
func get_all_beacons() -> Array[PlayerBeacon]:
	return [connected_beacon]

func create_beacon(mm:MapModifier) -> void:
	var b : PlayerBeacon = beacon_scene.instantiate()
	b.set_position(get_valid_beacon_pos())

	connected_beacon = b
	mm.add_to_layer("entities", b)
	
	b.set_player_num(player_num)

func on_lives_changed(new_lives:int) -> void:
	connected_beacon.update_lives(new_lives)

func on_treasure_changed(new_tres:int) -> void:
	connected_beacon.update_treasure(new_tres)

func on_battery_changed(new_bat:int) -> void:
	connected_beacon.update_battery(new_bat)

func reposition_beacon() -> void:
	connected_beacon.set_position(get_valid_beacon_pos())

func get_valid_beacon_pos() -> Vector2:
	return map_data.query_position({ "avoid": map_data.get_all_static_objects(), "range": config.min_dist_between_beacons, "avoid_edge": true })
