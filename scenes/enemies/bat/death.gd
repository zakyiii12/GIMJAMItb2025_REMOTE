extends State

#Refrences
@export var black_death_particle : GPUParticles2D
@onready var timer : Timer = $Timer
@onready var coin_scene : PackedScene = preload("res://scenes/collectible/coin/coin.tscn")

func enter(_msg := {}):
	owner.emote.visible = false
	owner.collision.disabled = true
	owner.animator.visible = false
	black_death_particle.emitting = true
	timer.start()
	AudioManager.play_sound(AudioManager.DEATH)
	var coin = coin_scene.instantiate()
	coin.global_position = owner.global_position
	get_tree().get_root().add_child(coin)


func _on_timer_timeout():
	owner.queue_free()
