class_name PlayersModifier extends Node

@export var players_data : PlayersData
@export var map_data : MapData
@export var player_scene : PackedScene
@export var config : ConfigTemplate

var map_modifier : MapModifier

# @NOTE: we must do this before ANYTHING else, otherwise player count checks (which progression heavily depends on) can be incorrect
func init() -> void:
	GInput.create_debugging_players()
	players_data.reset()
	players_data.single_player = GInput.get_player_count() <= 1

func activate(mm:MapModifier) -> void:
	map_modifier = mm
	place_players(mm)
	create_ai_opponent_if_needed(mm)

func create_ai_opponent_if_needed(mm:MapModifier) -> void:
	if not players_data.single_player: return
	place_player(GInput.get_player_count(), mm)

func place_players(mm:MapModifier) -> void:
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
	
	# @NOTE: in case everyone has died EXACTLY at the same time, 
	# the first one to call this function simply gets the victory
	var winning_player : Player = p
	if players_alive.size() > 0:
		winning_player = players_alive.front()
	
	GSignalBus.game_over.emit(winning_player)

func kill_all() -> void:
	for p in players_data.players:
		p.lives.drain()
