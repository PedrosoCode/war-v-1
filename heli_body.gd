extends CharacterBody2D

enum state {
	IDLE, 		
	ATTACK,
	MOVE,       #MOVER SEM ATACAR
	REPOSITION  #REPOSICIOAR PARA ATACAR
}

var current_state = state.IDLE

var hp = 15
var speed = 200.0
var face = "right"
var can_fire = true
var is_moving = false

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var BulletScene = preload("res://enemy_bullet.tscn")
@onready var Raycast: RayCast2D = $RayCastEnemy
@onready var moveTimer: Timer = $move_timer

@onready var animate = $heli_animate
@onready var call_method : AnimationPlayer = $AnimationPlayer

@onready var player = get_tree().get_first_node_in_group("player")

func _physics_process(delta):

	#update_face_to_player()
	
	match current_state:
		state.IDLE:
			pass
			#state_idle()
		state.ATTACK:
			pass
			#state_attack()
		state.MOVE:
			pass
			#state_move()
		state.REPOSITION:
			pass
			#state_patrol()

func update_face_to_player():
	if player == null:
		return
		
	if player.global_position.x > global_position.x:
		face = "right"
		Raycast.rotation_degrees = -90
		animate.flip_h = false
	else:
		face = "left"
		Raycast.rotation_degrees = 90
		animate.flip_h = true

func firebullet():
	var bullet = BulletScene.instantiate()
	bullet.global_position = global_position
	
	if face == "right":
		bullet.direction = "right"
		bullet.velocity = Vector2(500, 0)
	else:
		bullet.direction = "left"
		bullet.velocity = Vector2(-500, 0)
	
	get_tree().current_scene.add_child(bullet)
	
