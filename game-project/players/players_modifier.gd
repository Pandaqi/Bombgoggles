class_name PlayersModifier extends Node

@export var players_data : PlayersData
@export var map_data : MapData
@export var player_scene : PackedScene
@export var config : ConfigTemplate

var map_modifier : MapModifier

func activate(mm:MapModifier) -> void:
	map_modifier = mm
	GInput.create_debugging_players()
	place_players(mm)

func place_players(mm:MapModifier) -> void:
	players_data.reset()
	for i in range(GInput.get_player_count()):
		place_player(i, mm)

func place_player(player_num:int, mm:MapModifier) -> void:
	var p : Player = player_scene.instantiate()
	
	var avoid = players_data.players.duplicate(false) + map_data.hidden_elements.duplicate(false)
	var start_pos : Vector2 = map_data.query_position({ "avoid": avoid, "range": config.min_dist_between_players, "avoid_edge": true })
	p.set_position(start_pos)
	players_data.add_player(p)
	map_modifier.add_to_layer("entities", p)
	
	p.init(player_num, mm)
	p.status.died.connect(on_player_died)
	p.status.won.connect(on_player_won)

func on_player_won(p:Player) -> void:
	GSignalBus.game_over.emit(p)

func on_player_died(p:Player) -> void:
	var players_alive := players_data.get_players_alive()
	if players_alive.size() > 1: return
	
	var winning_player = players_alive.front()
	
	# @NOTE: in case everyone has died EXACTLY at the same time, 
	# the first one to call this function simply gets the victory
	if players_alive.size() <= 0:
		winning_player = p
	
	GSignalBus.game_over.emit(winning_player)

func kill_all() -> void:
	for p in players_data.players:
		p.lives.drain()
