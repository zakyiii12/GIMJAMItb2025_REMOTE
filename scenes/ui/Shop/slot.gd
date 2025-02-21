extends VBoxContainer

signal selected_weapon(slot_resource : WeaponResource)

var slot_resource : WeaponResource
var mouseEntered : bool

@onready var slot_img: TextureRect = %SlotImg
@onready var slot_label: Label = %SlotLabel
@onready var cost: Label = $Cost
@onready var coin: int
var has_bought : bool

func _ready() -> void:
	slot_img.texture = slot_resource.weapon_sprite
	slot_label.text = slot_resource.weapon_name

func _on_mouse_entered() -> void:
	if !has_bought:
		mouseEntered = true

func _on_mouse_exited() -> void:
	mouseEntered = false

func _input(event):
	if event.is_action_pressed("shoot"):
		if mouseEntered:
			if EventManager.coin_collected < coin:
				print("not enough money")
				return
			selected_weapon.emit(slot_resource)
			EventManager.coin_collected -= coin
			self.modulate.a = 0.7
			has_bought = true
