extends AnimatedSprite2D

@export var collision_scale_x = 1
@export var collision_scale_y = 1

func _ready():
	$Area2D/CollisionShape2D.scale = Vector2(collision_scale_x, collision_scale_y)
	
func _process(_delta):
	pass


func _on_area_2d_body_entered(body):
	if body.name == "Player":
		self.animation = "awake"
		self.play()


func _on_area_2d_body_exited(body):
	if body.name == "Player":
		self.animation = "sleep"
		self.play()
