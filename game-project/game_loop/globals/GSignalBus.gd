extends Node

# this acts as a global signal bus, ONLY for the most crucial/large messages
# (everything else should be more private/tightly connected)
# @TODO: this might be completely unnecessary in the end, if we do signals via shared resources anyway
signal game_over(winning_player:Player)
signal feedback(pos:Vector2, txt:String)

func _ready():
	var a = AudioStreamPlayer.new()
	add_child(a)
	a.volume_db = -18
	a.stream = preload("res://game_loop/globals/theme_song.mp3")
	a.set_process_mode(Node.PROCESS_MODE_ALWAYS)
	a.play()
