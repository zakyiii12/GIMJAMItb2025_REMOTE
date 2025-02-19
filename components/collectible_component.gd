class_name Collectible
extends Area2D

signal collected

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		collect(body)

func collect(player : CharacterBody2D):
	collected.emit()
	collision_shape_2d.set_deferred("disabled", true)
	animated_sprite_2d.visible = false
	queue_free()
