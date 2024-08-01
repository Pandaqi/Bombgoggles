extends Node2D

@onready var anim_player : AnimationPlayer = $AnimationPlayer
@onready var label : Label = $Container/Label

func _ready():
	anim_player.play("feedback_float")
	await anim_player.animation_finished
	queue_free()

func set_text(txt:String):
	label.set_text(txt)
