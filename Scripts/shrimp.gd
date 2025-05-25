extends AnimatedSprite2D

var speed = 50

func _ready():
	self.self_modulate.a = 0.7
	self.play()
	
func _process(delta):
	move_shrimp(delta)
	invert_sprite_when_colliding()
	
	
func move_shrimp(delta):
	if self.flip_h:
		self.position.x -= speed * delta
	else:
		self.position.x += speed * delta
	
	
func invert_sprite_when_colliding():
	if colliding_wall():
		if self.flip_h:
			self.flip_h = false
			$RayCast2D.scale.y = 0.56
		elif !self.flip_h:
			self.flip_h = true
			$RayCast2D.scale.y = -0.56
		
func colliding_wall():
	return $RayCast2D.is_colliding()
