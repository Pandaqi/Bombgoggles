class_name PlayerSelect extends Control

@onready var player_id : Label = $MarginContainer/VBoxContainer/PlayerID
@onready var instruction : Label = $MarginContainer/VBoxContainer/Instruction
@onready var ready_label : Label = $MarginContainer/VBoxContainer/Ready
@onready var bg = $NinePatchRect
@onready var player_visual = $MarginContainer/VBoxContainer/PlayerVisual
@onready var player_visual_texture = $MarginContainer/VBoxContainer/PlayerVisual/TextureRect
@onready var input_hint = $MarginContainer/VBoxContainer/InputHint
@onready var anim_player : AnimationPlayer = $AnimationPlayer

var active := true
var player_num := -1
var is_ready := false
var player_spritesheet := preload("res://players/players.webp")

signal readied_up()

func init(num:int):
	player_num = num
	player_id.set_text("Player " + str(num + 1))
	
	ready_label.set_visible(false)
	
	var region = Rect2(num * 256, 0, 256, 256)
	var a = AtlasTexture.new()
	a.atlas = player_spritesheet
	a.region = region
	player_visual_texture.texture = a
	
	deactivate()

func activate():
	if active: return
	active = true
	
	instruction.set_text("Input any movement to ready up.")
	instruction.set("theme_override_colors/font_color", Color(0,0,0))
	instruction.set_visible(true)
	
	input_hint.set_visible(true)
	input_hint.set_player_num(player_num)
	
	bg.modulate.a = 1.0
	player_visual.modulate.a = 1.0

func deactivate(show_instruction:bool = false):
	instruction.set_text("Press ENTER for keyboard player, or ANY button for gamepad.")
	instruction.set("theme_override_colors/font_color", Color(1,1,1))
	instruction.set_visible(show_instruction)
	input_hint.set_visible(false)
	
	if not active: return
	bg.modulate.a = 0.2
	player_visual.modulate.a = 0.2
	active = false
	ready_down()

func ready_down():
	if not is_ready: return
	is_ready = false
	ready_label.set_visible(false)
	anim_player.stop()

func ready_up():
	is_ready = true
	ready_label.set_visible(true)
	instruction.set_visible(false)
	readied_up.emit()
	anim_player.play("player_ready_wiggle")

func _input(_ev):
	if is_ready: return
	if GInput.get_move_vec(player_num).length() > 0.5:
		ready_up()
