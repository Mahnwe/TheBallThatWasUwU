extends CharacterBody2D

#@export
var speed = 300
var wall_pushback = 1400

#@export
var gravity = 30

#@export
var jump_force = -680

const VELOCITY_Y_MAX = 600
var dash_speed = 800

var can_dash
var have_dash_ability
var dash_cooldown_timer = Timer.new()

var can_double_jump
var number_of_jumps
var jump_buffer
var player_try_buffer_jump

var is_in_water

var stats_config= ConfigFile.new()
var stats_file = stats_config.load("res://Ressources/PropertieFile/stats.cfg")

var config = ConfigFile.new()
# Load data from a file.
var config_file = config.load("res://Ressources/PropertieFile/properties.cfg")

func _ready():
	number_of_jumps = 0
	$WaterSploch.hide()
	is_in_water = false
	can_dash = false
	can_double_jump = false
	dash_cooldown_timer.one_shot = true
	self.add_child(dash_cooldown_timer)
	if(config.get_value("levels", "is_level_two_finished")):
		can_dash = true
		have_dash_ability = true
	if(config.get_value("levels", "is_level_three_finished")):
		can_double_jump = true

func _physics_process(_delta):
	change_sound_pitch_in_water()
	check_for_player_movement()
	if is_on_floor():
		check_if_player_is_on_floor()
	if !is_on_floor():
		check_if_player_is_not_on_floor()
	check_if_player_is_on_wall()
	if Input.is_action_just_pressed("dash"):
		_dash()
	if !is_on_floor() and Input.is_action_just_pressed("jump") and !can_double_jump and number_of_jumps >= 1:
		player_try_buffer_jump = true
		get_tree().create_timer(0.1).timeout.connect(_on_jump_buffer_timer_timeout)
		
		
func jump():
	var random = RandomNumberGenerator.new()
	random.randomize()
	if random.randf() >= 0.50:
		$JumpSound.play()
	else:
		$JumpSound2.play()
	var number_of_jumps_in_stats = stats_config.get_value("Stats", "jump_number")
	stats_config.set_value("Stats", "jump_number", number_of_jumps_in_stats+1)
	stats_config.save("res://Ressources/PropertieFile/stats.cfg")
	velocity.y = jump_force
	number_of_jumps += 1
	if velocity.x < 0:
		$AnimatedSprite2D.animation = "jump"
		$AnimatedSprite2D.flip_h = true
		$Raycast.scale.x = 1
		$AnimatedSprite2D.play()
	if velocity.x > 0:
		$AnimatedSprite2D.animation = "jump"
		$AnimatedSprite2D.flip_h = false
		$Raycast.scale.x = -1
		$AnimatedSprite2D.play()
	if velocity.x == 0:
		$AnimatedSprite2D.animation = "jump"
		$AnimatedSprite2D.flip_h = false
		$Raycast.scale.x = 1
		$AnimatedSprite2D.play()
	
func _dash():
	var horizontal_direction = Input.get_axis("move_left","move_right")
	if can_dash and have_dash_ability and horizontal_direction != 0 and dash_cooldown_timer.time_left == 0:
		$DashSound.play()
		var number_of_dashes = stats_config.get_value("Stats", "dash_number")
		stats_config.set_value("Stats", "dash_number", number_of_dashes+1)
		stats_config.save("res://Ressources/PropertieFile/stats.cfg")
		if velocity.x > 0 and Input.is_action_just_pressed("dash"):
			$AnimatedSprite2D.animation = "dash"
			$AnimatedSprite2D.flip_h = false
			$Raycast.scale.x = 1
			speed = dash_speed
			velocity.x += speed
			move_and_slide()
			can_dash = false
			$DashDurationTimer.start()
			$AnimatedSprite2D.play()
			dash_cooldown_timer.start(0.5)
		if velocity.x < 0 and Input.is_action_just_pressed("dash"):
			$AnimatedSprite2D.animation = "dash"
			$AnimatedSprite2D.flip_h = true
			$Raycast.scale.x = -1
			speed = dash_speed
			velocity.x -= speed
			move_and_slide()
			can_dash = false
			$DashDurationTimer.start()
			$AnimatedSprite2D.play()
			dash_cooldown_timer.start(0.5)
	
	
func check_if_player_is_not_on_floor():
	if !is_on_floor():
		if Input.is_action_just_pressed("jump") and !can_double_jump and number_of_jumps < 1:
			jump()
		if Input.is_action_just_pressed("jump") and can_double_jump and number_of_jumps <= 1:
			jump()
		velocity.y += gravity
		await $AnimatedSprite2D.animation_finished
		if velocity.x < 0:
			$AnimatedSprite2D.animation = "stay_in_air"
			$AnimatedSprite2D.flip_h = true
			$Raycast.scale.x = -1
			$AnimatedSprite2D.play()
		elif velocity.x > 0:
			$AnimatedSprite2D.animation = "stay_in_air"
			$AnimatedSprite2D.flip_h = false
			$Raycast.scale.x = 1
			$AnimatedSprite2D.play()
		if velocity.y > VELOCITY_Y_MAX:
			velocity.y = VELOCITY_Y_MAX
	
func check_if_player_is_on_floor():
	if is_on_floor():
		can_dash = true
		number_of_jumps = 0
		if velocity.x == 0:
			$AnimatedSprite2D.animation = "idle"
			$AnimatedSprite2D.play()
		if velocity.x != 0:
			if velocity.x < 0:
				$AnimatedSprite2D.animation = "walk"
				$AnimatedSprite2D.flip_h = true
				$Raycast.scale.x = -1
				$AnimatedSprite2D.play()
			elif velocity.x > 0:
				$AnimatedSprite2D.animation = "walk"
				$AnimatedSprite2D.flip_h = false
				$Raycast.scale.x = 1
				$AnimatedSprite2D.play()
	if is_on_floor() and Input.is_action_pressed("jump") or Input.is_action_just_pressed("jump"):
		jump()
		
func _input(event):
	if event.is_action_released("jump"):
		if velocity.y < 0.0:
			velocity.y *= 0.6
			
func check_if_player_is_on_wall():
		# Wall-jump
	if !is_on_floor():
		check_animation_if_on_wall()
		var wall_normal = get_wall_normal()
		if colliding_wall() and Input.is_action_just_pressed("jump"):
			$JumpSound.play()
			number_of_jumps += 1
			velocity += Vector2(wall_pushback * wall_normal.x, jump_force-100)
			move_and_slide()
			$AnimatedSprite2D.animation = "jump"
			$AnimatedSprite2D.play()
			await $AnimatedSprite2D.animation_finished
			
func check_for_player_movement():
	# Horizontal movements
	# 	return -1 if left, +1 if right, 0 if both or neither
	var horizontal_direction = Input.get_axis("move_left","move_right")
	velocity.x =  speed * horizontal_direction
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
		$Raycast.scale.x = -1
	if velocity.x > 0:
		$AnimatedSprite2D.flip_h = false
		$Raycast.scale.x = 1
	move_and_slide()
	
			
func check_animation_if_on_wall():
		if colliding_wall():
			number_of_jumps = 0
			can_dash = true
			velocity.y = 0
			velocity.y = gravity+90
			$AnimatedSprite2D.animation = "stay_in_air"
			
func colliding_wall():
	return $Raycast.is_colliding()
	
func _on_jump_buffer_timer_timeout():
	if is_on_floor() and player_try_buffer_jump:
		can_dash = true
		number_of_jumps = 0
		jump()
		player_try_buffer_jump = false
	if !is_on_floor() and player_try_buffer_jump:
		pass
		
func change_sound_pitch_in_water():
	if is_in_water:
		$JumpSound.pitch_scale = 0.7
		$JumpSound2.pitch_scale = 0.7
		$DashSound.pitch_scale = 0.8
	else:
		$JumpSound.pitch_scale = 1.0
		$JumpSound2.pitch_scale = 1.0
		$DashSound.pitch_scale = 1.0
		
func start_sploch_animation():
	$WaterSploch.show()
	$WaterSploch.play()
	await $WaterSploch.animation_finished
	$WaterSploch.hide()


func _on_dash_duration_timer_timeout():
	speed = 300
