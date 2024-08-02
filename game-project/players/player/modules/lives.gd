class_name ModuleLives extends Node2D

var lives := 0
var connected_beacon : PlayerBeacon
var player_num := -1
var treasure_tracker : ModuleTreasureTracker
@export var beacon_scene : PackedScene

@export var config : ConfigTemplate
@export var map_data : MapData

@onready var entity : Player = get_parent()
@onready var audio_player : AudioStreamPlayer2D = $AudioStreamPlayer2D

signal lives_depleted()

func activate(n:int, t:ModuleTreasureTracker, mm:MapModifier) -> void:
	player_num = n
	treasure_tracker = t
	treasure_tracker.treasure_changed.connect(on_treasure_changed)
	create_beacon(mm)
	change_lives(config.lives_starting_num)

func drain() -> void:
	change_lives(-lives)

func change_lives(dl:int) -> int:
	var old_lives := lives
	lives = clamp(lives + dl, 0, config.lives_max)
	connected_beacon.update_lives(lives)
	
	if lives != old_lives:
		var txt := "+ Life!" if dl >= 0 else "- Life!"
		GSignalBus.feedback.emit(entity.get_position(), txt)
		audio_player.pitch_scale = randf_range(0.9, 1.1)
		audio_player.play()
	
	if lives <= 0:
		lives_depleted.emit()
	
	return lives

func create_beacon(mm:MapModifier):
	var b : PlayerBeacon = beacon_scene.instantiate()
	b.set_position(get_valid_beacon_pos())

	connected_beacon = b
	mm.add_to_layer("entities", b)
	
	b.set_player_num(player_num)

func get_valid_beacon_pos() -> Vector2:
	return map_data.query_position({ "avoid": map_data.get_all_static_objects(), "range": config.min_dist_between_beacons, "avoid_edge": true })

func reposition_beacon() -> void:
	connected_beacon.set_position(get_valid_beacon_pos())

func on_treasure_changed(new_tres:int) -> void:
	connected_beacon.update_treasure(new_tres)
