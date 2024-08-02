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

func init(num:int, map_modifier:MapModifier):
	player_num = num
	
	input.activate(player_num)
	mover.activate(lives, input, battery)
	lives.activate(player_num, treasure_tracker, map_modifier)
	interactor_hidden.activate(status, lives, mover, treasure_tracker, map_modifier)
	interactor_beacon.activate(status, lives, battery)
	status.activate(lives, treasure_tracker)
	goggles.activate(battery)
	battery.activate()
	visuals.activate(player_num, mover, goggles, status)
