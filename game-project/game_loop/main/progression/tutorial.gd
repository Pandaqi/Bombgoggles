class_name Tutorial extends Control

@onready var anim_player : AnimationPlayer = $AnimationPlayer
@onready var texture_rect : TextureRect = $MarginContainer/TextureRect
@export var prog_data : ProgressionData
@export var players_data : PlayersData

var active := false

@export var multiplayer_texture : Texture
@export var singleplayer_texture : Texture

signal dismissed()

func _input(ev):
	if not active: return
	if ev.is_action_released("game_over_restart"):
		dismiss()

func dismiss():
	set_visible(false)
	active = false
	dismissed.emit()

func display() -> void:
	var still_need_tutorial := prog_data.num_plays <= prog_data.num_plays_before_tutorial_disappears
	if not still_need_tutorial:
		await get_tree().process_frame
		dismiss()
		return
	
	texture_rect.texture = singleplayer_texture if players_data.single_player else multiplayer_texture
	
	set_visible(true)
	anim_player.stop(false)
	anim_player.play("tutorial_popup")
	
	await anim_player.animation_finished
	active = true
