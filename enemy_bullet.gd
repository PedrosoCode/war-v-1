extends Node2D

@export var velocity = Vector2(500, 0)

func _physics_process(delta):
	position += velocity * delta
