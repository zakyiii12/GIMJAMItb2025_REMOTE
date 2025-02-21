extends CharacterBody2D

#Data
var bullets_amount : int = 30

@export var movement_data : MovementData
@export var stats : Stats

#Refrences
@onready var animator : AnimatedSprite2D = $AnimatedSprite2D
@onready var guns_animator : AnimationPlayer = $ShootingAnimationPlayer
@onready var hit_animator : AnimationPlayer = $HitAnimationPlayer
@onready var hand : Node2D = $Hand
@onready var pistol : Sprite2D = %Pistol
@onready var pistol_bullet_marker : Marker2D = $Hand/Pivot/Pistol/PistolBulletMarker
@onready var health_bar: Control = $HealthBar

@export var camera : Camera2D

#Load Scenes
@onready var muzzle_load : PackedScene = preload("res://scenes/particles/muzzle.tscn")
@onready var bullet_load : PackedScene = preload("res://scenes/bullets/bullet.tscn")
@onready var death_particle_load : PackedScene = preload("res://scenes/particles/player_death_particle.tscn")


@export var weapon_manager: WeaponManager
@export var starting_weapon: WeaponResource
@onready var bullet_ui: Control = $BulletUI



func _ready():
	if not weapon_manager:
		push_error("Weapon manager not assigned in inspector")
		return
		
	if not starting_weapon:
		push_error("Starting weapon not assigned in inspector")
		return
	
	stats.health = stats.max_health
	weapon_manager.weapon_changed.connect(_on_weapon_changed)
	
	EventManager.bullets_amount = bullets_amount
	EventManager.update_bullet_ui.emit()
	weapon_manager.switch_weapon(starting_weapon)

func _physics_process(delta):
	var input_vector = Input.get_axis("left_p2","right_p2")
	

	if Input.is_action_just_pressed("reload") and !weapon_manager.is_reloading:
		weapon_manager.current_weapon.max_ammo -= weapon_manager.current_weapon.magazine_size - weapon_manager.current_ammo
		EventManager.max_bullets_amount = weapon_manager.current_weapon.max_ammo
		weapon_manager.start_reload()

	move_and_slide()
	animate(input_vector)

func _unhandled_input(event: InputEvent) -> void:
	print("shoot")
	if event.is_action_pressed("shoot") and weapon_manager._can_shoot():
		guns_animator.play("Shoot")
		shoot()

func apply_friction(delta):
	velocity.x = move_toward(velocity.x, 0, movement_data.friction * delta)

func knockback(vector):
	velocity = velocity.move_toward(vector * movement_data.knockback_force, movement_data.acceleration)

func jump():
	velocity.y = -movement_data.jump_strength
	AudioManager.play_sound(AudioManager.JUMP)

func _on_weapon_changed(new_weapon: WeaponResource) -> void:
	pistol.texture = new_weapon.weapon_sprite

func shoot():
	var current_weapon = weapon_manager.current_weapon
	
	# Update ammo
	weapon_manager.current_ammo -= 1
	EventManager.bullets_amount = weapon_manager.current_ammo
	EventManager.update_bullet_ui.emit()
	
	# Weapon animation
	guns_animator.play("Shoot")
	
	# Calculate shot direction
	var mouse_position: Vector2 = (get_global_mouse_position() - global_position).normalized()
	
	# Apply accuracy spread
	var spread = (1.0 - current_weapon.accuracy) * 0.1
	var final_direction = mouse_position.rotated(randf_range(-spread, spread))
	
	# Spawn effects
	var muzzle = current_weapon.muzzle_flash_scene.instantiate()
	pistol_bullet_marker.add_child(muzzle)
	
	# Spawn bullet
	var bullet = current_weapon.bullet_scene.instantiate()
	bullet.global_position = pistol_bullet_marker.global_position
	bullet.target_vector = final_direction
	bullet.rotation = final_direction.angle()
	bullet.speed = current_weapon.bullet_speed
	get_tree().current_scene.add_child(bullet)
	bullet.hitbox.damage = current_weapon.damage
	
	# Camera shake
	camera.custom_shake(current_weapon.camera_shake_intensity)
	
	# Play sound
	AudioManager.play_sound(current_weapon.shoot_sound)
	
	# Start fire rate timer
	weapon_manager.can_shoot = false
	weapon_manager.shoot_timer.start(current_weapon.fire_rate)

func small_shake():
	health_bar.visible = false
	camera.small_shake()

func animate(input_vector):
	var mouse_position : Vector2 = (get_global_mouse_position() - global_position).normalized()

	hand.rotation = mouse_position.angle()
	if hand.scale.y == 1 and mouse_position.x < 0:
		hand.scale.y = -1
	elif hand.scale.y == -1 and mouse_position.x > 0:
		hand.scale.y = 1
	
	if is_on_floor():
		if input_vector != 0:
			animator.play("Run")
		else:
			animator.play("Idle")
	else:
		if velocity.y > 0:
				animator.play("Fall")
		else:
				animator.play("Jump")

func _on_hurtbox_area_entered(area):
	if area.is_in_group("Object"):
		return
	hit_animator.play("Hit")
	health_bar.visible = true
	EventManager.update_health_ui.emit()
	if stats.health <= 0:
		die()
	else:
		AudioManager.play_sound(AudioManager.HURT)
		EventManager.frame_freeze.emit()

func die():
	AudioManager.play_sound(AudioManager.DEATH)
	var death_particle = death_particle_load.instantiate()
	death_particle.global_position = global_position
	get_tree().current_scene.add_child(death_particle)
	EventManager.player_died.emit()
	queue_free()


func _on_pistol_animation_finished() -> void:
	pistol.play("idle")
