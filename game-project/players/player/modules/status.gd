class_name ModuleStatus extends Node

var dead := false

signal died(p:Player)
signal won(p:Player)

@onready var entity : Player = get_parent()
@export var config : ConfigTemplate

func activate(lives:ModuleLives, t:ModuleTreasureTracker):
	t.treasure_changed.connect(on_treasure_changed)
	lives.lives_depleted.connect(on_died)

func on_treasure_changed(val:int) -> void:
	if val < config.treasure_needed_to_win: return
	won.emit(entity)

func on_died() -> void:
	dead = true
	died.emit(entity)
