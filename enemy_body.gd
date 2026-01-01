extends CharacterBody2D

enum State {
	IDLE = 1,
	PATROL = 2,
	ATTACK = 3,
	MOVE = 4
}

var current_state = State.IDLE

var speed = 300.0
var jump_speed = -400.0
var face = "right"

var can_fire = true

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var Raycast: RayCast2D = $RayCastEnemy
@onready var BulletScene = preload("res://enemy_bullet.tscn")


func _physics_process(delta):
	apply_gravity(delta)
	
	match current_state:
		State.IDLE:
			state_idle()
		State.MOVE:
			state_move()
		State.ATTACK:
			state_attack()


# --------------------
# STATES
# --------------------

func state_idle():
	if Raycast.is_colliding() == true:
		current_state = State.ATTACK


func state_move():
	match face:
		"right":
			velocity.x = 1 * speed
		"left":
			velocity.x = -1 * speed
	
	move_and_slide()
	velocity.x = 0
	current_state = State.IDLE

func state_attack():
	if can_fire == true:
		can_fire = false
		firebullet()
		current_state = State.MOVE

# --------------------
# ACTIONS
# --------------------

func firebullet():
	var bullet = BulletScene.instantiate()
	bullet.global_position = global_position
	#bullet.velocity = Vector2(100, 100)
	
	if face == "right":
		bullet.velocity = Vector2(500, 0)
		
	if face == "left":
		bullet.velocity = Vector2(-500, 0)
		
	if face == "up":
		bullet.velocity = Vector2(0, -500)

	if face == "down":
		bullet.velocity = Vector2(0, 500)
	
	get_tree().current_scene.add_child(bullet)


# --------------------
# HELPERS
# --------------------

func apply_gravity(delta):
	velocity.y += gravity * delta


# --------------------
# TIMERS / SIGNALS
# --------------------

func _on_timer_timeout() -> void:
	can_fire = true


func _on_state_timeout() -> void:
	if current_state == State.IDLE:
		pass
		
	if current_state == State.ATTACK:
		current_state = State.IDLE
