class_name PushObject
extends Node

@export var push_force = 10.0
@export var min_push_force = 5.0
@export var Player : CharacterBody2D

func _physics_process(delta: float) -> void:
	for i in Player.get_slide_collision_count():
		var c = Player.get_slide_collision(i)
		if c.get_collider() is RigidBody2D:
			var push_force = (push_force * Player.velocity.length() / 100) + min_push_force
			c.get_collider().apply_central_impulse(-c.get_normal() * push_force)
