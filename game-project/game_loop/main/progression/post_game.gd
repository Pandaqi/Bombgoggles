class_name PostGame extends CanvasLayer

#if OS.is_debug_build() and config.debug_skip_postgame:
	#CALL FUNCTION TO RESTART
	#return

@export var prog_data : ProgressionData

@onready var anim_player : AnimationPlayer = $AnimationPlayer
@onready var label_heading : Label = $Control/MarginContainer/MarginContainer/VBoxContainer/Heading
@onready var label_body : RichTextLabel = $Control/MarginContainer/MarginContainer/VBoxContainer/VBoxContainer/Result
@onready var continue_button : Button = $Control/MarginContainer/MarginContainer/VBoxContainer/CenterContainer/HBoxContainer/Continue

var active := false

func _ready():
	set_visible(false)

func activate():
	set_visible(true)
	
	# @TODO: The winner is in prog_data.winning_player
	
	# @TODO: set proper results/text/whatever
	#label_heading.set_text(txt_heading)
	#label_body.set_text("[center]" + txt_body + "[/center]") 
	
	anim_player.play("go_appear")
	await anim_player.animation_finished
	active = true

func disappear():
	active = false
	anim_player.play_backwards("go_appear")
	await anim_player.animation_finished
	set_visible(false)

func _input(ev):
	if not active: return
	if ev.is_action_released("game_over_restart"):
		on_continue_pressed()
		return
	
	if ev.is_action_released("game_over_back"):
		on_back_pressed()
		return

func on_continue_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

func on_back_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_packed(preload("res://game_loop/input_select/input_select.tscn"))
