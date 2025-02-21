extends Control

@onready var coin_count: Label = $CoinCount

func _process(delta: float) -> void:
	coin_count.text = str(EventManager.coin_collected)
