class_name PlayersModifier extends Node

@export var players_data : PlayersData
@export var map_data : MapData
@export var player_scene : PackedScene

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
	var start_pos : Vector2 = map_data.query_position({ "avoid": players_data.players, "range": 150 })
	p.set_position(start_pos)
	p.init(player_num, mm)
	players_data.add_player(p)
	map_modifier.add_to_layer("entities", p)
	
	p.status.died.connect(on_player_died)

func on_player_died() -> void:
	var players_alive := players_data.get_players_alive()
	if players_alive.size() > 1: return
	
	GSignalBus.game_over.emit(players_alive.front())

func kill_all() -> void:
	for p in players_data.players:
		p.lives.drain()
