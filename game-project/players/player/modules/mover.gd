class_name ModuleMover extends Node2D

@export var config : ConfigTemplate
@export var prog_data : ProgressionData
@onready var entity : Player = get_parent()
@onready var particles : CPUParticles2D = $CPUParticles2D
@onready var audio_player : AudioStreamPlayer2D = $AudioStreamPlayer2D
@export var map_data : MapData
@export var speed : float = 0

var speed_factor_terrain := 1.0

signal moved(vec:Vector2)
signal stopped()

var battery : ModuleBattery
var lives : ModuleLives
var goggles : ModuleGoggles
var active := false

func activate(l:ModuleLives, input:ModuleInput, b:ModuleBattery, bot:ModuleBot, g:ModuleGoggles) -> void:
	lives = l
	battery = b
	goggles = g
	active = true
	change_speed(config.speed_default)
	input.movement_vector_update.connect(on_movement)
	bot.movement_vector_update.connect(on_movement)
	map_data.terrain_changed.connect(on_terrain_changed)

func change_speed(ds:float) -> float:
	var old_speed := speed
	speed = clamp(speed + ds, config.speed_bounds.min, config.speed_bounds.max)
	
	if abs(old_speed - speed) > 0.03:
		var txt := "+ Speed!" if ds >= 0 else "- Speed!"
		GSignalBus.feedback.emit(entity.get_feedback_position(), txt)
		audio_player.pitch_scale = randf_range(0.9, 1.1)
		audio_player.play()
	
	return speed

# @NOTE: this is an expensive call, which is why we only do it when absolutely needed
func on_terrain_changed() -> void:
	var pos := entity.global_position
	var is_hole := map_data.is_hole_at(pos) 
	speed_factor_terrain = config.terrain_holes_speed_slowdown if is_hole else 1.0
	
	if config.terrain_holes_go_haywire and is_hole:
		goggles.go_haywire()
	
	if config.terrain_holes_kill_players and is_hole:
		GSignalBus.feedback.emit(entity.get_feedback_position(), "That's a hole!")
		lives.drain()

func get_final_speed() -> float:
	var speed_factor_battery := battery.get_speed_factor()
	var speed_factor_prog := prog_data.interpolate(config.prog_speed_escalation_bounds)
	var speed_decrease_bot := config.bot_speed_factor if entity.is_bot() else 1.0
	return speed * speed_factor_battery * speed_factor_prog * speed_factor_terrain * speed_decrease_bot

func on_movement(vec:Vector2, dt:float) -> void:
	if not active: return
	
	if vec.length() <= 0.03: 
		particles.set_emitting(false)
		stopped.emit()
		return
	
	var final_move_vec := vec * get_final_speed() * dt
	var new_pos := entity.get_position() + final_move_vec
	if map_data.is_out_of_bounds(new_pos): return
	entity.set_position(new_pos)
	moved.emit(final_move_vec)
	particles.set_emitting(true)
	
	on_terrain_changed()
	interact_with_new_position(new_pos)

func interact_with_new_position(_new_pos:Vector2):
	if entity.status.dead: return
	pass

func yeet() -> void:
	active = false
	
	var cur_pos = entity.position
	var tw = get_tree().create_tween()
	tw.tween_property(entity, "position", cur_pos + Vector2.UP*2000, 1.0)
	tw.tween_property(entity, "position", cur_pos, 0.5)
	tw.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
