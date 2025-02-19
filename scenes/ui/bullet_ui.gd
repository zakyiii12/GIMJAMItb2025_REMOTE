extends Control

#Refrences
@onready var bullet_counter : Label = $Slot/Label
@onready var max_bullets: Label = $Slot/Label2

func _ready():
	EventManager.update_bullet_ui.connect(update_bullet_counter)

func update_bullet_counter():
	bullet_counter.text = str(EventManager.bullets_amount)
	max_bullets.text = "/" + str(EventManager.max_bullets_amount)
