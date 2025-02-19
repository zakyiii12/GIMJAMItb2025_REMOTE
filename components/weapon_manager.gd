extends Node
class_name WeaponManager

signal weapon_changed(new_weapon: WeaponResource)

var current_weapon: WeaponResource
var current_ammo: int
var can_shoot: bool = true
var is_reloading: bool = false

@onready var shoot_timer: Timer = $ShootTimer
@onready var reload_timer: Timer = $ReloadTimer

func _ready():
	shoot_timer = Timer.new()
	reload_timer = Timer.new()
	add_child(shoot_timer)
	add_child(reload_timer)
	
	shoot_timer.one_shot = true
	reload_timer.one_shot = true
	
	shoot_timer.timeout.connect(_on_can_shoot_timer_timeout)
	reload_timer.timeout.connect(_on_reload_timer_timeout)

func switch_weapon(new_weapon: WeaponResource) -> void:
	if current_weapon == new_weapon:
		return
		
	current_weapon = new_weapon
	current_ammo = new_weapon.magazine_size
	EventManager.bullets_amount = current_ammo
	EventManager.max_bullets_amount = new_weapon.max_ammo
	EventManager.update_bullet_ui.emit()
	weapon_changed.emit(current_weapon)

func _can_shoot() -> bool:
	return can_shoot and current_ammo > 0 and not is_reloading

func start_reload() -> void:
	if is_reloading or current_ammo == current_weapon.magazine_size:
		return
	
	is_reloading = true
	reload_timer.start(current_weapon.reload_time)

func _on_can_shoot_timer_timeout() -> void:
	can_shoot = true

func _on_reload_timer_timeout() -> void:
	is_reloading = false
	current_ammo = current_weapon.magazine_size
	EventManager.bullets_amount = current_ammo
	EventManager.update_bullet_ui.emit()
