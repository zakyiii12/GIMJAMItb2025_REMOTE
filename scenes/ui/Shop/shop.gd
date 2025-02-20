extends Control


@export var Player : CharacterBody2D
@onready var slot_container: HBoxContainer = $Panel/SlotContainer
@onready var item = preload("res://scenes/ui/Shop/slot.tscn")
var slotSize = 2

var weapons = {
	0: {
		"Name": "Revolver",
		"ResourceWeapon": preload("res://data/weapon_types/revolver.tres")
	},
	1: {
		"Name": "Ak 47",
		"ResourceWeapon": preload("res://data/weapon_types/ak47.tres")
	}
}

func _ready() -> void:
	for i in slotSize:
		var item_temp = item.instantiate()
		item_temp.slot_resource = weapons[i]["ResourceWeapon"]
		item_temp.selected_weapon.connect(_on_weapon_selected)
		slot_container.add_child(item_temp)

func _on_close_pressed() -> void:
	close_shop()

func close_shop():
	visible = false
	await get_tree().create_timer(0.2).timeout
	get_tree().paused = false

func _on_weapon_selected(slot_resource : WeaponResource):
	Player.weapon_manager.switch_weapon(slot_resource)
	close_shop()
