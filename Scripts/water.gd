extends AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	self.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_area_2d_body_entered(body):
	if body.name == "Player":
		body.start_sploch_animation()
		body.is_in_water = true
		self.self_modulate.a = 0.5
		body.speed = 200
		body.velocity.x = body.velocity.x/2
		body.velocity.y = body.velocity.y/2
		body.gravity = 5
		body.jump_force = -250
		body.wall_pushback = 300
		body.dash_speed = 400
		body.velocity_y_max = 300
		body.z_index = 0


func _on_area_2d_body_exited(body):
	if body.name == "Player":
		body.is_in_water = false
		self.self_modulate.a = 1.0
		body.speed = 400
		body.gravity = 30
		body.jump_force = -690
		body.wall_pushback = 500
		body.dash_speed = 800
		body.velocity_y_max = 600
		body.z_index = 2
