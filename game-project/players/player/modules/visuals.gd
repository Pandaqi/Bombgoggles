class_name ModuleVisuals extends Node2D

@export var elem_dict : ElementDictionary
@onready var body : Sprite2D = $Body
@onready var anim_player : AnimationPlayer = $AnimationPlayer
@onready var goggles_container : Node2D = $Body/Goggles
@onready var goggles : Array[Goggle] = [
	$Body/Goggles/Goggle0,
	$Body/Goggles/Goggle1,
	$Body/Goggles/Goggle2
]

@export var grayscale_shader : ShaderMaterial

func activate(num:int, m:ModuleMover, g:ModuleGoggles, s:ModuleStatus, b:ModuleBattery) -> void:
	body.set_frame(num)
	m.moved.connect(on_moved)
	g.slots_updated.connect(on_slots_updated)
	s.died.connect(on_died)
	
	b.battery_empty.connect(on_battery_empty)
	b.battery_charging.connect(on_battery_charging)
	
	prepare_goggles()

func prepare_goggles() -> void:
	for i in range(goggles.size()):
		var goggle := goggles[i]
		var type := elem_dict.types[i]
		goggle.set_frame(elem_dict.get_data_for_type(type).frame)
		goggle.set_color(elem_dict.get_color_for_type(type))

func on_moved(vec:Vector2) -> void:
	body.flip_h = vec.x >= 0.0
	anim_player.play("move")

func on_slots_updated(list:Array[float]) -> void:
	for i in range(list.size()):
		goggles[i].update(list[i])

func on_died(_p:Player) -> void:
	goggles_container.set_visible(false)
	self.modulate.a = 0.25

func on_battery_empty() -> void:
	body.material = grayscale_shader

func on_battery_charging(_val:float) -> void:
	body.material = null
