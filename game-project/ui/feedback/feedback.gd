extends Node2D

var feedback_scene := preload("res://ui/feedback/feedback_scene.tscn")

func _ready() -> void:
	GSignalBus.feedback.connect(on_feedback_given)

func on_feedback_given(pos:Vector2, txt:String):
	var f = feedback_scene.instantiate()
	f.set_position(pos)
	add_child(f)
	f.set_text(txt)

func _on_progression_new_level() -> void:
	var nodes = get_tree().get_nodes_in_group("Feedback")
	for node in nodes: 
		node.queue_free()
