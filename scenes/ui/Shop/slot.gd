extends VBoxContainer

signal selected_weapon(slot_resource : WeaponResource)

var slot_resource : WeaponResource
var mouseEntered : bool

@onready var slot_img: TextureRect = %SlotImg
@onready var slot_label: Label = %SlotLabel


func _ready() -> void:
	slot_img.texture = slot_resource.weapon_sprite
	slot_label.text = slot_resource.weapon_name

func _on_mouse_entered() -> void:
	mouseEntered = true

func _on_mouse_exited() -> void:
	mouseEntered = false

func _input(event):
	if event.is_action_pressed("shoot"):
		if mouseEntered:
			selected_weapon.emit(slot_resource)
