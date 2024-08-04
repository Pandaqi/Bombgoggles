class_name ModuleMover extends Node2D

@export var config : ConfigTemplate
@export var prog_data : ProgressionData
@onready var entity : Player = get_parent()
@onready var particles : CPUParticles2D = $CPUParticles2D
@onready var audio_player : AudioStreamPlayer2D = $AudioStreamPlayer2D
@export var map_data : MapData
@export var speed : float = 0

signal moved(vec:Vector2)
signal stopped()

var battery : ModuleBattery
var lives : ModuleLives
var active := false

func activate(l:ModuleLives, input:ModuleInput, b:ModuleBattery) -> void:
	lives = l
	battery = b
	active = true
	change_speed(config.speed_default)
	input.movement_vector_update.connect(on_movement)

func change_speed(ds:float) -> int:
	var old_speed := speed
	speed = clamp(speed + ds, config.speed_bounds.min, config.speed_bounds.max)
	
	if abs(old_speed - speed) > 0.03:
		var txt := "+ Speed!" if ds >= 0 else "- Speed!"
		GSignalBus.feedback.emit(entity.get_position(), txt)
		audio_player.pitch_scale = randf_range(0.9, 1.1)
		audio_player.play()
	
	return speed

func get_current_speed():
	var speed_factor_battery := battery.get_speed_factor()
	var speed_factor_prog := prog_data.interpolate(config.prog_speed_escalation_bounds)
	return speed * speed_factor_battery * speed_factor_prog

func on_movement(vec:Vector2, dt:float) -> void:
	if not active: return
	
	if vec.length() <= 0.03: 
		particles.set_emitting(false)
		stopped.emit()
		return
	
	var final_move_vec := vec * speed * dt
	var new_pos := entity.get_position() + final_move_vec
	if map_data.is_out_of_bounds(new_pos): return
	entity.set_position(new_pos)
	moved.emit(final_move_vec)
	particles.set_emitting(true)
	
	interact_with_new_cell(new_pos)

func interact_with_new_cell(new_pos:Vector2):
	if entity.status.dead: return
	
	if map_data.is_hole_at(new_pos) and config.terrain_kill_players_in_holes:
		GSignalBus.feedback.emit(new_pos, "That's a hole!")
		lives.drain()

func yeet() -> void:
	active = false
	
	var cur_pos = entity.position
	var tw = get_tree().create_tween()
	tw.tween_property(entity, "position", cur_pos + Vector2.DOWN*2000, 1.0)
	tw.tween_property(entity, "position", cur_pos, 0.5)
