extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_area_2d_body_entered(body):
	if body.name == "Player":
		self.self_modulate.a = 0.8
		self.self_modulate.a = 0.5
		body.gravity = 5
		body.jump_force = -250
		body.dash_speed = 1000
		body.z_index = 0


func _on_area_2d_body_exited(body):
	if body.name == "Player":
		self.self_modulate.a = 0.8
		self.self_modulate.a = 1.0
		body.gravity = 30
		body.jump_force = -670
		body.dash_speed = 2000
		body.z_index = 2
