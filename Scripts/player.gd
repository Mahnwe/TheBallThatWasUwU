extends CharacterBody2D

#@export
var speed = 300
var wall_pushback = 600

#@export
var gravity = 30

#@export
var jump_force = -660

const VELOCITY_Y_MAX = 600
const dash_speed = 1200

var can_dash
var have_dash_ability
var is_camera_dezoom

var can_double_jump
var number_of_jumps

func _ready():
	is_camera_dezoom = 0

func _physics_process(_delta):
	handle_cam_dezoom()
	check_for_player_movement()
	check_if_player_is_on_floor()
	player_press_jump_on_floor()
	check_if_player_is_not_on_floor()
	check_if_player_is_on_wall()
	_dash()
	
func handle_cam_dezoom():
	if Input.is_action_just_pressed("camera_dezoom") and is_camera_dezoom == 0:
		$Camera2D.zoom = Vector2(1.0, 1.0)
		is_camera_dezoom = 1
	elif Input.is_action_just_pressed("camera_dezoom") and is_camera_dezoom == 1:
		$Camera2D.zoom = Vector2(0.7, 0.7)
		is_camera_dezoom = 2
	elif Input.is_action_just_pressed("camera_dezoom") and is_camera_dezoom == 2:
		$Camera2D.zoom = Vector2(1.4, 1.4)
		is_camera_dezoom = 0
	
func _dash():
	if can_dash and have_dash_ability:
		if velocity.x > 0 and Input.is_action_just_pressed("dash"):
			$AnimatedSprite2D.animation = "dash"
			$AnimatedSprite2D.flip_h = false
			velocity.x += dash_speed
			can_dash = false
			move_and_slide()
			$AnimatedSprite2D.play()
		if velocity.x < 0 and Input.is_action_just_pressed("dash"):
			$AnimatedSprite2D.animation = "dash"
			$AnimatedSprite2D.flip_h = true
			velocity.x -= dash_speed
			can_dash = false
			move_and_slide()
			$AnimatedSprite2D.play()
	
	
func check_if_player_is_not_on_floor():
	if !is_on_floor():
		if Input.is_action_just_pressed("jump") and can_double_jump and number_of_jumps <= 1:
			velocity.y = jump_force
			number_of_jumps += 1
			if velocity.x < 0:
				$AnimatedSprite2D.animation = "jump"
				$AnimatedSprite2D.flip_h = true
				$AnimatedSprite2D.play()
			if velocity.x > 0:
				$AnimatedSprite2D.animation = "jump"
				$AnimatedSprite2D.flip_h = false
				$AnimatedSprite2D.play()
			if velocity.x == 0:
				$AnimatedSprite2D.animation = "jump"
				$AnimatedSprite2D.flip_h = false
				$AnimatedSprite2D.play()
		velocity.y += gravity
		await $AnimatedSprite2D.animation_finished
		if velocity.x < 0:
			$AnimatedSprite2D.animation = "stay_in_air"
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play()
		elif velocity.x > 0:
			$AnimatedSprite2D.animation = "stay_in_air"
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play()
		if velocity.y > VELOCITY_Y_MAX:
			velocity.y = VELOCITY_Y_MAX
	
func check_if_player_is_on_floor():
	if is_on_floor():
		can_dash = true
		number_of_jumps = 0
		if velocity.x == 0:
			$AnimatedSprite2D.stop()
			$AnimatedSprite2D.animation = "stay"
			$AnimatedSprite2D.play()
		if velocity.x != 0:
			if velocity.x < 0:
				$AnimatedSprite2D.animation = "walk"
				$AnimatedSprite2D.flip_h = true
				$AnimatedSprite2D.play()
			elif velocity.x > 0:
				$AnimatedSprite2D.animation = "walk"
				$AnimatedSprite2D.flip_h = false
				$AnimatedSprite2D.play()

						
func player_press_jump_on_floor():
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force
		number_of_jumps += 1
		if velocity.x < 0:
			$AnimatedSprite2D.animation = "jump"
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play()
		if velocity.x > 0:
			$AnimatedSprite2D.animation = "jump"
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play()
		if velocity.x == 0:
			$AnimatedSprite2D.animation = "jump"
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play()
		
func _input(event):
	if event.is_action_released("jump"):
		if velocity.y < 0.0:
			velocity.y *= 0.7
			
func check_if_player_is_on_wall():
		# Wall-jump
	if is_on_wall():
		check_animation_if_on_wall()
		var wall_normal = get_wall_normal()
		if collinding_right_wall() and Input.is_action_just_pressed("jump"):
			var wall_jump_force_to_left = Vector2(speed * 2.5 * wall_normal.x, jump_force)
			velocity = wall_jump_force_to_left
			move_and_slide()
			$AnimatedSprite2D.animation = "jump"
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play()
			await $AnimatedSprite2D.animation_finished
		if colliding_left_wall() and Input.is_action_just_pressed("jump"):
			var wall_jump_force_to_right = Vector2(speed * 2.5 *  wall_normal.x, jump_force)
			velocity = wall_jump_force_to_right
			move_and_slide()
			$AnimatedSprite2D.animation = "jump"
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play()
			await $AnimatedSprite2D.animation_finished
			
func check_for_player_movement():
	# Horizontal movements
	# 	return -1 if left, +1 if right, 0 if both or neither
	var horizontal_direction = Input.get_axis("move_left","move_right")
	velocity.x = speed * horizontal_direction
	move_and_slide()
	
			
func check_animation_if_on_wall():
	if collinding_right_wall() and Input.is_action_pressed("move_right"):
		number_of_jumps = 0
		velocity.y = gravity+75
		can_dash = true
		$AnimatedSprite2D.animation = "stay"
		$AnimatedSprite2D.flip_h = true
	if colliding_left_wall() and Input.is_action_pressed("move_left"):
		number_of_jumps = 0
		velocity.y = gravity+75
		can_dash = true
		$AnimatedSprite2D.animation = "stay"
		$AnimatedSprite2D.flip_h = false
		
func colliding_left_wall():
	return $RaycastLeft.is_colliding()

func collinding_right_wall():
	return $RaycastRight.is_colliding()
