extends Control

@export var Player : CharacterBody2D
@onready var player_weapon: TextureRect = %PlayerWeapon

func _ready() -> void:
	player_weapon.texture = Player.weapon_manager.current_weapon.weapon_sprite
	Player.weapon_manager.weapon_changed.connect(_on_weapon_changed)

func _on_weapon_changed(new_weapon : WeaponResource):
	player_weapon.texture = new_weapon.weapon_sprite
