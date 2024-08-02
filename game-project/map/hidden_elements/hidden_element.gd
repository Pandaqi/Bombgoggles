class_name HiddenElement extends Node2D

# @TODO: should this move to a better place? Such as ElementDictionary resource?
enum HiddenElementType
{
	BOMB,
	SPEED,
	LIFE,
	TRAP,
	BATTERY,
	TREASURE
}

@export var elem_dict : ElementDictionary

var type : HiddenElementType
@onready var sprite : Sprite2D = $Sprite2D

signal died()

func set_type(tp:HiddenElementType):
	type = tp
	sprite.set_frame(elem_dict.get_data_for_type(type).frame)
	modulate = elem_dict.get_color_for_type(type)

func is_type(t:HiddenElementType) -> bool:
	return type == t

func kill() -> void:
	self.queue_free()
	died.emit()
