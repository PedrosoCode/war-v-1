extends RigidBody2D

@export var force := 550.0
@export var angle := 45.0
var launched := false
var lifespan := 2.5
var time_alive := 0.0

func _process(delta: float) -> void:
	time_alive += delta

	if time_alive >= lifespan:
		queue_free()

func launch(direction: Vector2):
	if launched:
		return
	launched = true

	var impulse := Vector2.ZERO

	if direction == Vector2.RIGHT:
		impulse = Vector2(1, -1)
	elif direction == Vector2.LEFT:
		impulse = Vector2(-1, -1)
	elif direction == Vector2.UP:
		impulse = Vector2(0, -1)
	elif direction == Vector2.DOWN:
		impulse = Vector2(0, 1)

	apply_impulse(impulse.normalized() * force)
