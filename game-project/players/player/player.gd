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

func init(num:int, map_modifier:MapModifier):
	player_num = num
	
	input.activate(player_num)
	mover.activate(input, battery)
	lives.activate(player_num, map_modifier)
	interactor_hidden.activate(status, lives, mover, map_modifier)
	interactor_beacon.activate(status, lives, battery)
	status.activate(lives)
	goggles.activate(battery)
	battery.activate()
	visuals.activate(player_num, mover, goggles, status)
