extends CharacterBody2D

#@export
var speed = 300

#@export
var gravity = 30

#@export
var jump_force = 660

const VELOCITY_Y_MAX = 800
const dash_speed = 1200

var can_dash
var have_dash_ability

var can_double_jump
var number_of_jumps

func _physics_process(_delta):
	check_if_player_is_on_floor()
	check_if_player_is_not_on_floor()
	check_if_player_is_on_wall()
	check_for_player_movement_and_animation()
	_dash()
	
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
		if Input.is_action_just_pressed("jump") and can_double_jump and number_of_jumps < 1:
			velocity.y = -jump_force
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
		number_of_jumps = 0
		can_dash = true
		if velocity.x != 0:
			if velocity.x < 0:
				$AnimatedSprite2D.animation = "walk"
				$AnimatedSprite2D.flip_h = true
				$AnimatedSprite2D.play()
			elif velocity.x > 0:
				$AnimatedSprite2D.animation = "walk"
				$AnimatedSprite2D.flip_h = false
				$AnimatedSprite2D.play()
		if Input.is_action_pressed("jump"):
			velocity.y = -jump_force
			number_of_jumps += 1
			if velocity.x < 0 and Input.is_action_just_pressed("jump"):
					$AnimatedSprite2D.animation = "jump"
					$AnimatedSprite2D.flip_h = true
					$AnimatedSprite2D.play()
			if velocity.x > 0 and Input.is_action_just_pressed("jump"):
					$AnimatedSprite2D.animation = "jump"
					$AnimatedSprite2D.flip_h = false
					$AnimatedSprite2D.play()
			if velocity.x == 0 and Input.is_action_just_pressed("jump"):
					$AnimatedSprite2D.animation = "jump"
					$AnimatedSprite2D.flip_h = false
					$AnimatedSprite2D.play()
			
func check_if_player_is_on_wall():
		# Wall-jump
	if is_on_wall():
		number_of_jumps = -1
		var wall_normal = get_wall_normal()
		can_dash = true
		check_animation_if_on_wall()
		if Input.is_action_pressed("jump"):
			number_of_jumps += 1
			if Input.is_action_pressed("move_left") and wall_normal == Vector2.LEFT :
				velocity.x = speed * wall_normal.x
				velocity.y = -jump_force
				$AnimatedSprite2D.animation = "jump"
				$AnimatedSprite2D.flip_h = true
				$AnimatedSprite2D.play()
			if Input.is_action_pressed("move_right") and wall_normal == Vector2.RIGHT :
				velocity.x = speed * wall_normal.x
				velocity.y = -jump_force
				$AnimatedSprite2D.animation = "jump"
				$AnimatedSprite2D.flip_h = false
				$AnimatedSprite2D.play()
			
func check_for_player_movement_and_animation():
	# Horizontal movements
	# 	return -1 if left, +1 if right, 0 if both or neither
	if is_on_floor():
		number_of_jumps = 0
		if velocity.x == 0 and velocity.y == 0:
			$AnimatedSprite2D.stop()
			$AnimatedSprite2D.animation = "stay"
			$AnimatedSprite2D.play()
	var horizontal_direction = Input.get_axis("move_left","move_right")
	velocity.x = speed * horizontal_direction
	move_and_slide()
	
			
func check_animation_if_on_wall():
	if collinding_right_wall():
		velocity.y = gravity+35
		can_dash = true
		$AnimatedSprite2D.animation = "stay"
		$AnimatedSprite2D.flip_h = true
	if colliding_left_wall():
		velocity.y = gravity+35
		can_dash = true
		$AnimatedSprite2D.animation = "stay"
		$AnimatedSprite2D.flip_h = false
		
func colliding_left_wall():
	return $RaycastLeft.is_colliding()

func collinding_right_wall():
	return $RaycastRight.is_colliding()
