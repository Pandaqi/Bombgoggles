class_name ModuleInteractorBeacon extends Node

@export var config : ConfigTemplate
@export var map_data : MapData
@onready var entity : Player = get_parent()

var lives:ModuleLives
var battery:ModuleBattery
var active := false

func activate(s:ModuleStatus, l:ModuleLives, b:ModuleBattery):
	s.died.connect(on_died)
	lives = l
	battery = b
	active = true

func on_died() -> void:
	active = false

func _process(_dt:float) -> void:
	if not active: return
	check_if_overlaps_beacon()

func check_if_overlaps_beacon() -> void:
	var elems = map_data.query_overlaps(entity.get_position(), { "include": [lives.connected_beacon] })
	for node in elems:
		interact_with_beacon(node)

func interact_with_beacon(node:PlayerBeacon) -> void:
	if config.beacon_move_on_interact:
		lives.reposition_beacon()
	
	if config.beacon_recharge_on_interact:
		battery.recharge()
