class_name Inventory
extends ItemList

@export var inventory_size : int = 2
@export var blank_icon : Texture2D
@export var shop : Control
@export var Player : CharacterBody2D
var sprite = preload("res://data/weapon_sprites/revolver.tres")
var item : Dictionary = {}

func _ready() -> void:
	for i in inventory_size:
		add_item("", blank_icon)
		var weapon = WeaponDictionary.weapons[i]["ResourceWeapon"]
		item[weapon] = i
		set_item_icon(i, weapon.weapon_sprite)
		set_item_disabled(i, true)
	
	set_item_disabled(0, false)
	shop.bought_weapon.connect(_on_weapon_bought)

func _on_weapon_bought(new_weapon : WeaponResource) -> void:
	var item_idx = item[new_weapon]
	set_item_disabled(item_idx, false)

func get_key_from_value(target_value):
	for key in item.keys():
		if item[key] == target_value:
			return key  # Return the first matching key
	return null  # Return null if not found

func _on_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	var selected_weapon = get_key_from_value(index)
	Player.weapon_manager.switch_weapon(selected_weapon)

func _on_inventory_open_btn_pressed() -> void:
	get_tree().paused = true
	self.visible = true
	
func _on_close_inv_btn_pressed() -> void:
	self.visible = false
	await get_tree().create_timer(0.2).timeout
	get_tree().paused = false
