class_name Player extends Node2D

var player_num := -1
var is_a_bot := false

@onready var mover : ModuleMover = $Mover
@onready var input : ModuleInput = $Input
@onready var lives : ModuleLives = $Lives
@onready var interactor_hidden : ModuleInteractorHidden = $InteractorHidden
@onready var interactor_beacon : ModuleInteractorBeacon = $InteractorBeacon
@onready var status : ModuleStatus = $Status
@onready var visuals : ModuleVisuals = $Visuals
@onready var goggles : ModuleGoggles = $Goggles
@onready var battery : ModuleBattery = $Battery
@onready var treasure_tracker : ModuleTreasureTracker = $TreasureTracker
@onready var beacon_manager : ModuleBeaconManager = $BeaconManager
@onready var stats_tracker : ModuleStatsTracker = $StatsTracker
@onready var bot_module : ModuleBot = $Bot
@onready var feedback_pos : Node2D = $FeedbackPos

func init(num:int, map_modifier:MapModifier):
	player_num = num
	
	beacon_manager.activate(player_num, lives, treasure_tracker, battery, map_modifier)
	
	input.activate(player_num)
	mover.activate(lives, input, battery, bot_module, goggles)
	lives.activate()
	interactor_hidden.activate(status, lives, mover, treasure_tracker, battery, map_modifier)
	interactor_beacon.activate(status, beacon_manager, battery)
	status.activate(lives, treasure_tracker)
	goggles.activate(battery, lives)
	battery.activate(lives)
	visuals.activate(player_num, mover, goggles, status, battery)
	stats_tracker.activate(interactor_hidden)
	treasure_tracker.activate()
	
	if not input.is_connected_to_player():
		is_a_bot = true
		bot_module.activate(interactor_hidden, battery, beacon_manager)

func is_bot() -> bool:
	return is_a_bot

func get_feedback_position() -> Vector2:
	var rand_x := Vector2.RIGHT * (randf() - 0.5) * 164.0
	var rand_y := Vector2.UP * (randf() - 0.5) * 256.0
	return feedback_pos.global_position + rand_x + rand_y
