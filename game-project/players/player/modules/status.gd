class_name ModuleStatus extends Node

var dead := false

signal died()

func activate(lives:ModuleLives):
	lives.lives_depleted.connect(on_died)

func on_died() -> void:
	print("Player Died", self)
	dead = true
	died.emit()
	pass
