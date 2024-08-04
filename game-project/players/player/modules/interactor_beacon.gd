class_name ModuleInteractorBeacon extends Node

@export var config : ConfigTemplate
@export var map_data : MapData
@export var players_data : PlayersData
@onready var entity : Player = get_parent()

var lives:ModuleLives
var battery:ModuleBattery
var beacon_manager : ModuleBeaconManager
var active := false

func activate(s:ModuleStatus, bm:ModuleBeaconManager, b:ModuleBattery):
	s.died.connect(on_died)
	beacon_manager = bm
	battery = b
	active = true

func on_died(p:Player) -> void:
	active = false

func _process(_dt:float) -> void:
	if not active: return
	check_if_overlaps_beacon()

func check_if_overlaps_beacon() -> void:
	var elems = map_data.query_overlaps(entity.get_position(), { "include": beacon_manager.get_all_beacons() })
	for node in elems:
		interact_with_beacon(node)

func interact_with_beacon(node:PlayerBeacon) -> void:
	if config.beacon_interact_makes_haywire:
		for player in players_data.players:
			if player == entity: continue
			player.goggles.go_haywire()
	
	if config.beacon_move_on_interact:
		beacon_manager.reposition()
	
	if config.beacon_recharge_on_interact:
		battery.recharge()
