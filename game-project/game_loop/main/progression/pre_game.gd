class_name PreGame extends CanvasLayer

signal finished()

@export var config : ConfigTemplate
@onready var countdown : Countdown = $Countdown
@onready var tutorial : Tutorial = $Tutorial

func activate():
	if OS.is_debug_build() and config.debug_skip_pregame:
		await get_tree().process_frame
		finished.emit()
		return
	
	get_tree().paused = true

	tutorial.display()
	await tutorial.dismissed
	
	countdown.appear()
	await countdown.is_done
	
	finished.emit()
