class_name InputManagerEvent

var failed := true # whether the event did something and succeeded or not
var device := 0 # the device that triggered the event
var num := -1 # player number

func is_success() -> bool:
	return not failed

func succeed(dev := 0, n := -1) -> void:
	failed = false
	device = dev
	num = n
