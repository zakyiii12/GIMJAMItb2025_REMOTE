class_name WeaponResource
extends Resource

enum Weapons {
	None,
	Revolver,
	AK47,
	Shotgun,
	Sniper
}

@export var weapon_type: Weapons
@export var damage: int = 10
@export var fire_rate: float = 0.5
@export var reload_time: float = 1.0
@export var magazine_size: int = 6
@export var max_ammo: int = 30
@export var accuracy: float = 0.95
@export var recoil: Vector2 = Vector2(5.0, 15.0)
@export var bullet_speed: float = 1000.0
@export var camera_shake_intensity: float = 0.3

# Scenes and visual resources
@export var weapon_sprite: AtlasTexture
@export var muzzle_flash_scene: PackedScene
@export var bullet_scene: PackedScene
@export var shell_scene: PackedScene
@export var shoot_sound: AudioStream
