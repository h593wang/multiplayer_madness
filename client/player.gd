class_name Player extends CharacterBody2D

@export var gun_scene: PackedScene
@export var gun_rotation: float
@export var gun_scale: Vector2
@export var gun_position: Vector2
@export var gun_zindex: int

@export var player_animation: String

var speed = 500
var gun: Node2D
var is_left_hand = false
var gun_one_handed = true

var is_controlled: bool

func _enter_tree():
	$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())
	
# Called when the node enters the scene tree for the first time.
func _ready():
	is_controlled = Globals.is_client_controlled(str(name).to_int())
	
	if is_controlled:
		$Camera2D.make_current()
	motion_mode = MOTION_MODE_FLOATING
	$AnimatedSprite2D.play("idle_down")
	$AnimatedSprite2D.z_index = z_index
	gun = gun_scene.instantiate() as Node2D
	gun_position = $AnimatedSprite2D/RightHand.position
	gun_scale = Vector2(1,1)
	gun.name = name
	gun.is_controlled = is_controlled
	add_child(gun)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$RichTextLabel.text = str(position)
	gun.rotation = gun_rotation
	gun.scale = gun_scale
	gun.position = gun_position
	gun.z_index = gun_zindex
	
	if $AnimatedSprite2D.animation != player_animation:
		$AnimatedSprite2D.play(player_animation)
	
	if !is_controlled:
		return
		
	var direction = get_mouse_position_rotation()
	
	if not is_left_hand and (direction > 2 * PI/3 or direction < -2 * PI/3):
		# switch to left hand
		is_left_hand = true
		gun_scale = Vector2(-1,1)
		gun_position = $AnimatedSprite2D/LeftHand.position
	elif is_left_hand and (direction > -PI/3 and direction < 1 * PI/3):
		# switch to right hand
		is_left_hand = false
		gun_scale = Vector2(1,1)
		gun_position = $AnimatedSprite2D/RightHand.position
	
	gun_rotation = get_gun_rotation(is_left_hand)
	gun_zindex = z_index+1
	
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("d"):
		velocity.x += 1
	if Input.is_action_pressed("a"):
		velocity.x -= 1
	if Input.is_action_pressed("s"):
		velocity.y += 1
	if Input.is_action_pressed("w"):
		velocity.y -= 1

	var moving = false
	if velocity.length() > 0:
		moving = true
		velocity = velocity.normalized() * speed
	
	# Setting moving animation
	if direction > PI/4 and direction <= 3 * PI/4:
		if moving:
			player_animation = "walk_down"
		else:
			player_animation = "idle_down"
	elif direction > -PI/4 and direction <= PI/4:
		if moving:
			player_animation = "walk_right"
		else:
			player_animation = "idle_right"
	elif direction > -3 * PI/4 and direction <= -PI/4:
		gun_zindex = z_index-1
		if moving:
			player_animation = "walk_up"
		else:
			player_animation = "idle_up"
	else:
		if moving:
			player_animation = "walk_left"
		else:
			player_animation = "idle_left"
		
	set_velocity(velocity)
	move_and_slide()

	
func get_mouse_position_rotation() -> float:
	return (get_global_mouse_position() - global_position).normalized().angle()


func get_gun_rotation(is_flipped) -> float:
	var opposite = gun.opposite
	var hypotnuse = get_global_mouse_position().distance_to(gun.global_position)
	var base_rotation = (get_global_mouse_position() - gun.global_position).normalized().angle()
	if is_flipped:
		return base_rotation - asin(opposite/hypotnuse) + PI
	return base_rotation + asin(opposite/hypotnuse)
