extends Node

#Music

#Sounds
const DEATH : AudioStreamWAV = preload("res://audio/Sounds/Death.wav")
const HURT : AudioStreamWAV = preload("res://audio/Sounds/Hurt.wav")
const JUMP : AudioStreamWAV = preload("res://audio/Sounds/Jump.wav")
const SHOOT : AudioStreamWAV = preload("res://audio/Sounds/revolver_sfx.wav")
const BULLET : AudioStreamWAV = preload("res://audio/Sounds/Bullet.wav")
const MENU_CLICK : AudioStreamWAV = preload("res://audio/Sounds/Menu Click.wav")
const MENU_HOVER : AudioStreamWAV = preload("res://audio/Sounds/Menu Hover.wav")
const SPLASH_CLICK : AudioStreamWAV = preload("res://audio/Sounds/Splash Click.wav")
const SPLASH_GLITCH : AudioStreamWAV = preload("res://audio/Sounds/Splash Glitch.wav")

#Refrences
@onready var music_players = $Music.get_children()
@onready var sound_players = $Sounds.get_children()

func play_music(music):
	for player in music_players:
		if not player.playing:
			player.stream = music
			player.play()
			break

func play_sound(sound):
	for player in sound_players:
		if not player.playing:
			player.stream = sound
			player.play()
			break
