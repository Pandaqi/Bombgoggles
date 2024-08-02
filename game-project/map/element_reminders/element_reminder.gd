class_name ElementReminder extends Node

var type : HiddenElement.HiddenElementType

@export var elem_dict : ElementDictionary
@onready var element_icon : Sprite2D = $Sprite2D/Goggle/ElementIcon
@onready var goggle : Sprite2D = $Sprite2D/Goggle
@onready var label : Label = $Sprite2D/Label

func set_type(tp:HiddenElement.HiddenElementType) -> void:
	type = tp
	
	var data : HiddenElementData = elem_dict.get_data_for_type(type)
	element_icon.set_frame(data.frame)
	goggle.modulate = elem_dict.get_color_for_type(type)
	label.set_text(data.desc)
