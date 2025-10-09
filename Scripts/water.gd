extends AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	self.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_area_2d_body_shape_exited(_body_rid, body, body_shape_index, _local_shape_index):
	if body.name == "Player" and body_shape_index == 1:
		body.is_in_water = false
		self.self_modulate.a = 1.0
		body.speed = 400
		body.wall_slide = body.gravity+70
		body.gravity = 30
		body.jump_force = -690
		body.wall_pushback = 500
		body.dash_speed = 800
		body.velocity_y_max = 600
		body.z_index = 2


func _on_area_2d_body_shape_entered(_body_rid, body, body_shape_index, _local_shape_index):
	if body.name == "Player" and !body.is_in_water and body_shape_index == 1:
		trigger_water_sound_and_animation(body)
		body.is_in_water = true
		self.self_modulate.a = 0.5
		body.speed = 200
		body.wall_slide = body.gravity+30
		body.velocity.x = body.velocity.x/2
		body.velocity.y = body.velocity.y/2
		body.gravity = 5
		body.jump_force = -250
		body.wall_pushback = 300
		body.dash_speed = 400
		body.velocity_y_max = 300
		body.z_index = 0
		
func trigger_water_sound_and_animation(body):
	if $WaterSound.finished:
		$WaterSound.play()
	body.start_sploch_animation()
