class_name Player extends Node2D

var player_num := -1

@onready var mover : ModuleMover = $Mover
@onready var input : ModuleInput = $Input
@onready var lives : ModuleLives = $Lives
@onready var interactor_hidden : ModuleInteractorHidden = $InteractorHidden
@onready var status : ModuleStatus = $Status

func init(num:int, map_modifier:MapModifier):
	player_num = num
	
	input.activate(player_num)
	mover.activate(input)
	lives.activate(map_modifier)
	interactor_hidden.activate(lives, mover)
	status.activate(lives)
