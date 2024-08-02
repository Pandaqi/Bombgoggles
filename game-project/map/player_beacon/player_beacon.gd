class_name PlayerBeacon extends Node

@export var config : ConfigTemplate
@export var life_sprite : PackedScene
@onready var sprite : Sprite2D = $Sprite2D
@onready var lives_container : Node2D = $Lives
@onready var player_icon : Sprite2D = $PlayerIcon

var life_sprite_size := 0.2 * 256.0
var life_sprites = []

func set_player_num(n:int) -> void:
	player_icon.set_frame(4 + n)
	sprite.modulate = config.player_colors[n]

func update_lives(l:int) -> void:
	while life_sprites.size() < l:
		var new_sprite = life_sprite.instantiate()
		life_sprites.append(new_sprite)
		lives_container.add_child(new_sprite)
	
	var offset_per_sprite := Vector2.RIGHT * life_sprite_size
	var global_offset := -0.5 * (l - 1) * offset_per_sprite
	for i in range(life_sprites.size()):
		var should_show = i < l
		var sprite = life_sprites[i]
		sprite.set_visible(should_show)
		sprite.set_position(global_offset + i * offset_per_sprite)
		
