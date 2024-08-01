extends Node2D

@onready var map_modifier : MapModifier = $MapModifier
@onready var players_modifier : PlayersModifier = $PlayersModifier
@onready var elem_dict_modifier : ElementDictionaryModifier = $ElementDictionaryModifier
@onready var progression : Progression = $Progression
@onready var pre_game : PreGame = $PreGame
@onready var post_game : PostGame = $PostGame

func _ready() -> void:
	progression.activate()
	elem_dict_modifier.activate()
	map_modifier.activate()
	players_modifier.activate(map_modifier)
	
	pre_game.activate()
	await pre_game.finished
	
	progression.start_level(players_modifier)
	await progression.level_finished
	
	post_game.activate()
