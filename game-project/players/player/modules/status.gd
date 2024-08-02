class_name ModuleStatus extends Node

var dead := false

signal died(p:Player)

func activate(lives:ModuleLives):
	lives.lives_depleted.connect(on_died)

func on_died() -> void:
	dead = true
	died.emit(self)
