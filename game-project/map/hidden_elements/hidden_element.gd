class_name HiddenElement extends Node2D

# @TODO: should this move to a better place? Such as ElementDictionary resource?
enum HiddenElementType
{
	BOMB,
	SPEED,
	LIFE,
	TRAP
}

var type : HiddenElementType

func set_type(tp:HiddenElementType):
	type = tp
	# @TODO: update sprite to display this, for debugging

func is_type(t:HiddenElementType) -> bool:
	return type == t

func kill() -> void:
	pass # @TODO => also don't forget to properly update hidden_elements in MapData
