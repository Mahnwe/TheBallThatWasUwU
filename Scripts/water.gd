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
		print(body.z_index)
		body.z_index = 0


func _on_area_2d_body_exited(body):
	if body.name == "Player":
		self.self_modulate.a = 0.8
		self.self_modulate.a = 1.0
		print(body.z_index)
		body.z_index = 2
