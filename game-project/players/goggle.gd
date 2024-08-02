class_name Goggle extends Node2D

@onready var prog : TextureProgressBar = $TextureProgressBar
@onready var type_sprite : Sprite2D = $ElementType

func set_color(c:Color):
	modulate = c

func set_frame(frame:int) -> void:
	type_sprite.set_frame(frame)

func update(val:float) -> void:
	prog.value = (1.0 - val) * 100.0
