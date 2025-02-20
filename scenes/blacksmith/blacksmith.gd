extends Area2D

var player_in_area : bool = false
@export var Player : CharacterBody2D
@export var shop : Control

func _process(delta: float) -> void:
	if player_in_area:
		if Input.is_action_just_pressed("interact"):
			get_tree().paused = true
			shop.visible = true

func _on_body_entered(body: Node2D) -> void:
	print("enter")
	if body.is_in_group("Player"):
		player_in_area = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_in_area = false
