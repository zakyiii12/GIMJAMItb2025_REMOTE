extends Area2D

func _on_area_entered(area):
	if area.is_in_group("Object"):
		return
	if owner.is_in_group("Enemy"):
		if not area.is_in_group("Enemy"):
			owner.stats.health -= area.damage
	else:
		owner.stats.health -= area.damage
	
	if owner.is_in_group("Player"):
		owner.knockback(area.knockback_vector)
