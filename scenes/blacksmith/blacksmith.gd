extends Area2D

var player_in_area : bool = false
@export var Player : CharacterBody2D
@export var new_weapon : WeaponResource
var old_weapon : WeaponResource

func _process(delta: float) -> void:
	if player_in_area:
		if Input.is_action_just_pressed("interact"):
			old_weapon = Player.weapon_manager.current_weapon
			Player.weapon_manager.switch_weapon(new_weapon)
			new_weapon = old_weapon

func _on_body_entered(body: Node2D) -> void:
	print("enter")
	if body.is_in_group("Player"):
		player_in_area = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_in_area = false
