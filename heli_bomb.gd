extends RigidBody2D

@onready var animate = $AnimatedSprite2D

@export var force := 550.0
@export var angle := 45.0
var lifespan := 4
var time_alive := 0.0

func _ready() -> void:
	animate.play("drop")

func _process(delta: float) -> void:
	time_alive += delta

	if time_alive >= lifespan:
		queue_free()
