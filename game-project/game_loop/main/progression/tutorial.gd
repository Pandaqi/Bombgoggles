class_name Tutorial extends Control

@onready var anim_player : AnimationPlayer = $AnimationPlayer
@export var prog_data : ProgressionData

var active := false

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
	
	set_visible(true)
	anim_player.stop(false)
	anim_player.play("tutorial_popup")
	
	await anim_player.animation_finished
	active = true
