class_name PlayersData extends Resource

var players : Array[Player] = []
var single_player := false

func reset() -> void:
	single_player = false
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

func get_closest_dist_to(pos:Vector2, exclude : Array[Player] = []) -> float:
	var closest_dist := INF
	for p in players:
		if exclude.has(p): continue
		closest_dist = min(closest_dist, p.global_position.distance_to(pos))
	return closest_dist
