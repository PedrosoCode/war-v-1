extends CharacterBody2D

var speed = 300.0
var jump_speed = -400.0
var face = "right"

# Get the gravity from the project settings so you can sync with rigid body nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var BulletScene = preload("res://bullet.tscn")
@onready var GrenadeScene = preload("res://grenade.tscn")



#func firebullet():
	#var bullet = BulletScene.instantiate()
	#bullet.position = position
	#get_parent().add_child(bullet)
	
func firebullet():
	var bullet = BulletScene.instantiate()
	bullet.global_position = global_position
	#bullet.velocity = Vector2(100, 100)
	
	if face == "right":
		bullet.direction = "right"
		bullet.velocity = Vector2(500, 0)
		
	if face == "left":
		bullet.direction = "left"
		bullet.velocity = Vector2(-500, 0)
		
	if face == "up":
		bullet.direction = "up"
		bullet.velocity = Vector2(0, -500)

	if face == "down":
		bullet.direction = "down"
		bullet.velocity = Vector2(0, 500)
	
	get_tree().current_scene.add_child(bullet)

func launch_grenade():
	var grenade = GrenadeScene.instantiate()
	grenade.global_position = global_position + Vector2(0, -30)

	var dir := Vector2.ZERO

	match face:
		"right": dir = Vector2.RIGHT
		"left":  dir = Vector2.LEFT
		"up":    dir = Vector2.UP

	get_tree().current_scene.add_child(grenade)
	grenade.launch(dir)


func _physics_process(delta):
	
	if Input.is_action_pressed("btn_right"):
		face = "right"
		
	if Input.is_action_pressed("btn_left"):
		face = "left"
		
	if Input.is_action_pressed("btn_up"):
		face = "up"
		
	if Input.is_action_pressed("btn_down") == true and is_on_floor() == false:
		face = "down"
		
	velocity.y += gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_speed

	# Get the input direction.
	var direction = Input.get_axis("btn_left", "btn_right")
	velocity.x = direction * speed
	
	if Input.is_action_just_pressed("fire"):
		firebullet()
		
	if Input.is_action_just_pressed("launch"):
		launch_grenade()


	move_and_slide()
