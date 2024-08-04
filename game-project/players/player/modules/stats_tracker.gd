class_name ModuleStatsTracker extends Node

var freqs : Dictionary = {}
var elems : Array[HiddenElement] = []

func activate(i:ModuleInteractorHidden) -> void:
	i.interacted.connect(on_interacted)

func count_hidden_elements() -> int:
	return elems.size()

func on_interacted(elem:HiddenElement) -> void:
	elems.append(elem)
	
	var elem_name = HiddenElement.HiddenElementType.keys()[elem.type]
	if not (elem_name in freqs): freqs[elem_name] = 0
	freqs[elem_name] += 1

func get_details_list_as_string() -> String:
	var str : String = ""
	for elem in freqs:
		str += freqs[elem] + " " + elem + "s, "
	return str
		
