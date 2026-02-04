extends CharacterBody2D

enum State {
	IDLE,
	ATTACK,
	MOVE,
	PATROL,
}

var current_state = State.IDLE

var hp = 12
var speed = 200.0
var face = "right"
var can_fire = true
var can_move = true

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var player = get_tree().get_first_node_in_group("player")
@onready var BulletScene = preload("res://enemy_bullet.tscn")
@onready var MoveTimer: Timer = $TankMoveTimer
@onready var FireTimer: Timer = $TankFIreTimer
@onready var RayCast: RayCast2D = $TankRayCast
@onready var Animate: AnimatedSprite2D = $tankAnimate

func _ready():
	Animate.animation_finished.connect(_on_animation_finished)

func _physics_process(delta):
	apply_gravity(delta)
	
	match current_state:
		State.IDLE:
			state_idle()
		State.ATTACK:
			state_attack()
		State.PATROL:
			state_patrol()
				
	move_and_slide()
	
func apply_gravity(delta):
	velocity.y += gravity * delta
	
func state_idle():
	Animate.play("idle")
	if RayCast.is_colliding() == true:
		update_face_to_player()
		current_state = State.ATTACK
	else:
		current_state = State.PATROL
	
func state_attack():
	if can_fire:
		Animate.play("shoot")
		can_fire = false
		FireTimer.start()
	else:
		if Animate.animation != "shoot":
			Animate.play("idle")

func state_patrol():
	if RayCast.is_colliding():
		current_state = State.ATTACK

func update_face_to_player():
	if player == null:
		return
		
	if player.global_position.x > global_position.x:
		face = "right"
		RayCast.rotation_degrees = -90
		Animate.flip_h = false
	else:
		face = "left"
		RayCast.rotation_degrees = 90
		Animate.flip_h = true

func _on_animation_finished():
	if Animate.animation == "shoot":
		current_state = State.IDLE
		Animate.play("idle")

func _on_tank_hit_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullet"):
		hp -= area.damage
		area.get_parent().queue_free()
		current_state = State.ATTACK

		if hp <= 0:
			queue_free() 


func _on_tank_move_timer_timeout() -> void:
	can_move = false


func _on_tank_f_ire_timer_timeout() -> void:
	can_fire = true
