extends AnimatedSprite2D

var parent_name
@export var speed = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	parent_name = get_parent()
	self.play()
	
func _process(delta):
	_patrol(delta)
	
func _patrol(delta):
	if parent_name.get_name() == "PathFollow2D":
		parent_name.progress += speed * delta
