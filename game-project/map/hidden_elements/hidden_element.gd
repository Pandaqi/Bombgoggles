class_name HiddenElement extends Node2D

enum HiddenElementType
{
	BOMB,
	SPEED,
	LIFE,
	TRAP,
	BATTERY,
	TREASURE,
	BATTERYEXPLAINER,
	TERRAINEXPLAINER,
	NONE
}

@export var elem_dict : ElementDictionary

var type : HiddenElementType
var paired_node : HiddenElement
@onready var sprite : Sprite2D = $Sprite2D
@onready var anim_player : AnimationPlayer = $AnimationPlayer

signal died()

func set_type(tp:HiddenElementType) -> void:
	type = tp
	sprite.set_frame(elem_dict.get_data_for_type(type).frame)
	modulate = elem_dict.get_color_for_type(type)

func is_desirable() -> bool:
	return not elem_dict.is_inverted(type)

func is_type(t:HiddenElementType) -> bool:
	return type == t

func set_paired_node(n:HiddenElement) -> void:
	paired_node = n

func kill() -> void:
	died.emit()
	set_visible(true)
	anim_player.play("die")
	await anim_player.animation_finished
	self.queue_free()
	
