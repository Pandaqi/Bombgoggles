class_name ModuleInput extends Node

@export var player_num : int = -1

signal movement_vector_update(vec, dt)

func activate(num:int):
	player_num = num

func is_connected_to_player() -> bool:
	return player_num >= 0 and player_num < GInput.get_player_count()

func _physics_process(dt:float) -> void:
	if not is_connected_to_player(): return
	update_movement_vector(dt)

func update_movement_vector(dt:float) -> void:
	var move_vec = GInput.get_move_vec(player_num)
	movement_vector_update.emit(move_vec, dt)
