class_name ModuleMover extends Node

@export var config : ConfigTemplate
@onready var entity : Player = get_parent()
@export var map_data : MapData
@export var speed : float = 50.0

func activate(input:ModuleInput):
	input.movement_vector_update.connect(on_movement)

func change_speed(ds:float) -> void:
	speed = clamp(speed + ds, config.speed_bounds.min, config.speed_bounds.max)

func on_movement(vec:Vector2, dt:float) -> void:
	var new_pos = entity.get_position() + vec * speed * dt
	if map_data.is_out_of_bounds(new_pos): return
	entity.set_position(new_pos)
