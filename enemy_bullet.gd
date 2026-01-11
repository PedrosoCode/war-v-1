extends Node2D

@export var velocity = Vector2(500, 0)
@export var direction = 'right'

@onready var sprite = $Bullet

func _ready() -> void:
	if direction == 'right':
		sprite.flip_h = false
	else:
		sprite.flip_h = true

func _physics_process(delta):
	position += velocity * delta
