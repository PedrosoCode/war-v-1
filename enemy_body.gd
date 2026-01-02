extends CharacterBody2D

enum State {
	IDLE,
	ATTACK,
	MOVE
}

var current_state = State.IDLE

var hp = 2
var speed = 200.0
var face = "right"
var can_fire = true
var is_moving = false

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var BulletScene = preload("res://enemy_bullet.tscn")
@onready var Raycast: RayCast2D = $RayCastEnemy
@onready var moveTimer: Timer = $move_timer

@onready var player = get_tree().get_first_node_in_group("player")


func _physics_process(delta):
	apply_gravity(delta)
	update_face_to_player()
	
	match current_state:
		State.IDLE:
			state_idle()
		State.ATTACK:
			state_attack()
		State.MOVE:
			state_move()


# --------------------
# FACE
# --------------------

func update_face_to_player():
	if player == null:
		return
		
	if player.global_position.x > global_position.x:
		face = "right"
		Raycast.rotation_degrees = -90
	else:
		face = "left"
		Raycast.rotation_degrees = 90



# --------------------
# STATES
# --------------------

func state_idle():
	if Raycast.is_colliding():
		current_state = State.ATTACK
	else:
		current_state = State.MOVE


func state_attack():
	if can_fire:
		can_fire = false
		firebullet()
		current_state = State.MOVE


func state_move():
	match face:
		"right":
			velocity.x = speed
		"left":
			velocity.x = -speed
			
	moveTimer.wait_time = 2
	
	move_and_slide()
	current_state = State.IDLE


# --------------------
# ACTIONS
# --------------------

func firebullet():
	var bullet = BulletScene.instantiate()
	bullet.global_position = global_position
	
	if face == "right":
		bullet.velocity = Vector2(500, 0)
	else:
		bullet.velocity = Vector2(-500, 0)
	
	get_tree().current_scene.add_child(bullet)


# --------------------
# HELPERS
# --------------------

func apply_gravity(delta):
	velocity.y += gravity * delta


# --------------------
# TIMERS
# --------------------

func _on_timer_timeout() -> void:
	can_fire = true


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullet"):
		hp -= area.damage
		area.get_parent().queue_free()

		if hp <= 0:
			queue_free()  


func _on_move_timer_timeout() -> void:
	velocity.x = 0 
