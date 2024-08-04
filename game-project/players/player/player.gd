class_name Player extends Node2D

var player_num := -1

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

func init(num:int, map_modifier:MapModifier):
	player_num = num
	
	beacon_manager.activate(player_num, lives, treasure_tracker, battery, map_modifier)
	
	input.activate(player_num)
	mover.activate(lives, input, battery)
	lives.activate()
	interactor_hidden.activate(status, lives, mover, treasure_tracker, battery, map_modifier)
	interactor_beacon.activate(status, beacon_manager, battery)
	status.activate(lives, treasure_tracker)
	goggles.activate(battery, lives)
	battery.activate()
	visuals.activate(player_num, mover, goggles, status, battery)
	stats_tracker.activate(interactor_hidden)
