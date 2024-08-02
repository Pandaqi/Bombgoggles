class_name ModuleInteractorHidden extends Node

@export var config : ConfigTemplate
@export var map_data : MapData
@export var elem_dict : ElementDictionary
@export var prog_data : ProgressionData
@export var players_data : PlayersData
@onready var entity : Player = get_parent()
@export var explosion_scene : PackedScene

var lives:ModuleLives
var mover:ModuleMover
var map_modifier:MapModifier
var active := false

var excluded_nodes : Array = []

func activate(s:ModuleStatus, l:ModuleLives, m:ModuleMover, mm:MapModifier):
	s.died.connect(on_died)
	lives = l
	mover = m
	map_modifier = mm
	active = true

func on_died() -> void:
	active = false

func _process(_dt:float) -> void:
	if not active: return
	check_if_overlaps_anything()

func check_if_overlaps_anything() -> void:
	var hidden_overlaps = map_data.query_overlaps(entity.get_position(), { "hidden_elements": true })
	for node in hidden_overlaps:
		interact_with_hidden(node)

func interact_with_hidden(node:HiddenElement) -> void:
	if excluded_nodes.has(node): return
	
	var is_inverted := elem_dict.is_inverted(node.type)
	var num := -1 if is_inverted else 1
	var range_affected = elem_dict.get_element_range(node.type)
	range_affected *= prog_data.interpolate(config.prog_interact_range_bounds)
	
	var did_something := true
	
	if node.is_type(HiddenElement.HiddenElementType.BOMB):
		explode(node, is_inverted, range_affected)
	
	elif node.is_type(HiddenElement.HiddenElementType.SPEED):
		var speed_change := config.speed_change_per_trigger
		var old_speed := mover.speed
		var new_speed := mover.change_speed(num * speed_change)
		if abs(old_speed - new_speed) <= 0.03:
			GSignalBus.feedback.emit(node.get_position(), "Already at max!")
			did_something = false
	
	elif node.is_type(HiddenElement.HiddenElementType.LIFE):
		var old_lives := lives.lives
		var new_lives := lives.change_lives(num)
		if abs(old_lives - new_lives) <= 0.03:
			GSignalBus.feedback.emit(node.get_position(), "Already at max!")
			did_something = false
	
	elif node.is_type(HiddenElement.HiddenElementType.TRAP):
		spring_trap(node, is_inverted, range_affected)
	
	if did_something:
		node.kill()
	else:
		excluded_nodes.append(node)

func explode(node:HiddenElement, is_inverted:bool, range_affected:float) -> void:
	var include : Array = [entity] if is_inverted else players_data.players
	var exclude : Array = players_data.players if is_inverted else [entity]
	
	var players_affected = map_data.query_overlaps(node.get_position(), { "include": include, "exclude": exclude, "range": range_affected })
	for player in players_affected:
		player.lives.change_lives(-1)
	
	var e = explosion_scene.instantiate()
	e.set_position(node.get_position())
	map_modifier.add_to_layer("top", e)
	e.activate(range_affected)
	
	GSignalBus.feedback.emit(node.get_position(), "Bomb!")

func spring_trap(node:HiddenElement, is_inverted:bool, range_affected:float):
	var include : Array = [entity] if is_inverted else players_data.players
	var exclude : Array = players_data.players if is_inverted else [entity]
	
	var players_affected = map_data.query_overlaps(node.get_position(), { "include": include, "exclude": exclude, "range": range_affected })
	for player in players_affected:
		player.lives.drain()
	
	# @TODO: also instantiate some animation or something => for each player affected, send a signal to visuals to play something?

func _on_timer_timeout() -> void:
	excluded_nodes = []
