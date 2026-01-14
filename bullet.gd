extends Node2D

@export var velocity = Vector2(500, 0)
@export var direction = 'right'

@onready var sprite = $Bullet

func _ready() -> void:
	if direction == 'right':
		sprite.flip_h = false
	elif direction == 'left':
		sprite.flip_h = true
	elif direction == 'up':
		sprite.rotation_degrees = -90
	elif direction == 'down':
		sprite.rotation_degrees = 90

func _physics_process(delta):
	position += velocity * delta
