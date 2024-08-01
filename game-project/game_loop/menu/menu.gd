extends Control

func _ready():
	if OS.get_name() != "Web":
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)

func _on_play_pressed() -> void:
	get_tree().change_scene_to_packed(preload("res://game_loop/input_select.tscn"))

func _on_quit_pressed() -> void:
	get_tree().quit()
