class_name ElementReminder extends Node

var type : HiddenElement.HiddenElementType

@export var elem_dict : ElementDictionary
@onready var element_icon : Sprite2D = $Sprite2D/Goggle/ElementIcon
@onready var goggle : Sprite2D = $Sprite2D/Goggle
@onready var label : Label = $Sprite2D/Label

func set_type(tp:HiddenElement.HiddenElementType) -> void:
	type = tp
	
	var data : HiddenElementData = elem_dict.get_data_for_type(type)
	goggle.set_visible(false)

	if not data.hide_icon:
		goggle.set_visible(true)
		element_icon.set_frame(data.frame)
		goggle.modulate = elem_dict.get_color_for_type(type)
	
	var desc := data.desc
	var invert := elem_dict.is_inverted(tp)
	if invert and data.desc_inv: desc = data.desc_inv
	label.set_text(desc)
