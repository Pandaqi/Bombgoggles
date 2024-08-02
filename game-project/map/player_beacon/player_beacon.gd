class_name PlayerBeacon extends Node

@export var config : ConfigTemplate
@export var life_sprite : PackedScene
@export var treasure_sprite : PackedScene
@onready var sprite : Sprite2D = $Sprite2D
@onready var lives_container : Node2D = $Lives
@onready var treasure_container : Node2D = $Treasures
@onready var player_icon : Sprite2D = $PlayerIcon

var life_sprite_size := 0.2 * 256.0
var life_sprites = []

var treasure_sprite_size := 0.16 * 256.0
var treasure_sprites = []

func set_player_num(n:int) -> void:
	player_icon.set_frame(4 + n)
	sprite.modulate = config.player_colors[n]

func revisualize(val:int, arr:Array, scene:PackedScene, cont:Node2D, sprite_size:float) -> void:
	while arr.size() < val:
		var new_sprite = scene.instantiate()
		arr.append(new_sprite)
		cont.add_child(new_sprite)
	
	var offset_per_sprite := Vector2.RIGHT * sprite_size
	var global_offset := -0.5 * (val - 1) * offset_per_sprite
	for i in range(arr.size()):
		var should_show = i < val
		var sprite = arr[i]
		sprite.set_visible(should_show)
		sprite.set_position(global_offset + i * offset_per_sprite)

func update_lives(l:int) -> void:
	revisualize(l, life_sprites, life_sprite, lives_container, life_sprite_size)

func update_treasure(t:int) -> void:
	revisualize(t, treasure_sprites, treasure_sprite, treasure_container, treasure_sprite_size)
