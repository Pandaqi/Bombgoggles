class_name ModuleInteractorHidden extends Node

@export var config : ConfigTemplate
@export var map_data : MapData
@export var elem_dict : ElementDictionary
@export var prog_data : ProgressionData
@onready var players_data : PlayersData
@onready var entity : Player = get_parent()

var lives:ModuleLives
var mover:ModuleMover

func activate(l:ModuleLives, m:ModuleMover):
	lives = l
	mover = m

func _process(_dt:float) -> void:
	check_if_overlaps_anything()

func check_if_overlaps_anything() -> void:
	var hidden_overlaps = map_data.query_overlaps(entity.get_position(), { "hidden_elements": true })
	for node in hidden_overlaps:
		interact_with_hidden(node)

func interact_with_hidden(node:HiddenElement) -> void:
	
	var is_inverted := elem_dict.is_inverted(node.type)
	var num := -1 if is_inverted else 1
	var range_affected = elem_dict.get_element_range(node.type)
	range_affected *= prog_data.interpolate(config.prog_interact_range_bounds)
	
	if node.is_type(HiddenElement.HiddenElementType.BOMB):
		explode(node, is_inverted, range_affected)
	
	elif node.is_type(HiddenElement.HiddenElementType.SPEED):
		var speed_change := config.speed_change_per_trigger
		mover.change_speed(num * speed_change)
	
	elif node.is_type(HiddenElement.HiddenElementType.LIFE):
		lives.change_lives(num)
	
	elif node.is_type(HiddenElement.HiddenElementType.TRAP):
		spring_trap(node, is_inverted, range_affected)
	
	node.kill()

func explode(node:HiddenElement, is_inverted:bool, range_affected:float) -> void:
	var include := [entity] if is_inverted else players_data.players
	var exclude := players_data.players if is_inverted else [entity]
	
	var players_affected = map_data.query_overlaps(node.get_position(), { "include": include, "exclude": exclude, "range": range_affected })
	for player in players_affected:
		player.lives.change_lives(-1)
	
	# @TODO: also instantiate a bomb scene with particles, sound effect, anything else

func spring_trap(node:HiddenElement, is_inverted:bool, range_affected:float):
	var include := [entity] if is_inverted else players_data.players
	var exclude := players_data.players if is_inverted else [entity]
	
	var players_affected = map_data.query_overlaps(node.get_position(), { "include": include, "exclude": exclude, "range": range_affected })
	for player in players_affected:
		player.lives.drain()
	
	# @TODO: also instantiate some animation or something => for each player affected, send a signal to visuals to play something?
