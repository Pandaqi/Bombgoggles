class_name PlayersData extends Resource

var players : Array[Player] = []

func reset() -> void:
	players = []

func count() -> int:
	return players.size()

func add_player(p:Player) -> void:
	players.append(p)

func remove_player(p:Player) -> void:
	players.erase(p)

func get_players_alive() -> Array[Player]:
	var arr : Array[Player] = []
	for player in players:
		if player.status.dead: continue
		arr.append(player)
	return arr
