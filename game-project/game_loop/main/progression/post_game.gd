class_name PostGame extends CanvasLayer

#if OS.is_debug_build() and config.debug_skip_postgame:
	#CALL FUNCTION TO RESTART
	#return

@export var prog_data : ProgressionData

@onready var anim_player : AnimationPlayer = $AnimationPlayer
@onready var texture_winner : TextureRect = $Control/MarginContainer/MarginContainer/HBoxContainer/VBoxContainer2/HBoxContainer/WinnerTexture
@onready var label_stats : Label = $Control/MarginContainer/MarginContainer/HBoxContainer/VBoxContainer2/Stats

var active := false

func _ready():
	set_visible(false)

func activate():
	# @QOL: a bit longer to see what actually happened and why the game should end
	await get_tree().create_timer(1.0).timeout
	
	set_visible(true)
	
	var winning_player : Player = prog_data.winning_player
	
	var a: AtlasTexture = texture_winner.texture
	a.region = Rect2(winning_player.player_num * 256, 0, 256, 256)
	
	var stats_tracker = winning_player.stats_tracker
	var stats : String = "They found " + str(stats_tracker.count_hidden_elements()) + " hidden elements: " + stats_tracker.get_details_list_as_string()
	label_stats.set_text(stats)
	
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
	get_tree().change_scene_to_file("res://game_loop/input_select/input_select.tscn")
