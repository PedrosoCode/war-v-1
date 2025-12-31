extends Node2D

@export var hp = 2


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullet"):
		hp -= area.damage
		area.get_parent().queue_free()

		if hp <= 0:
			queue_free() # aqui depois você pode trocar por explosão
