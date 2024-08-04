extends Node2D

@onready var particles : CPUParticles2D = $CPUParticles2D
@onready var audio_player : AudioStreamPlayer2D = $AudioStreamPlayer2D

func activate(radius:float) -> void:
	particles.emission_sphere_radius = radius
	particles.set_emitting(true)
	
	audio_player.pitch_scale = randf_range(0.9, 1.1)
	audio_player.play()
	
	await get_tree().create_timer(particles.lifetime-0.1).timeout
	particles.set_emitting(false)
	
	await audio_player.finished
	queue_free()
