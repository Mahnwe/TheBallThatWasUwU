extends AnimatedSprite2D

var parent_name
@export var speed = 150
# Called when the node enters the scene tree for the first time.
func _ready():
	self.self_modulate.a = 0.9
	parent_name = get_parent()
	self.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_patrol(delta)
	
	
func _patrol(delta):
	if parent_name.get_name() == "PathFollow2D":
		parent_name.progress += speed * delta
	var parent_progress = get_parent()
	if parent_progress.progress_ratio >= 0.00 and parent_progress.progress_ratio < 0.001:
		parent_progress.rotates = false
		self.flip_v = false
		self.get_child(0).flip_v = false
		parent_progress.rotates = true
	if parent_progress.progress_ratio >= 0.500 and parent_progress.progress_ratio < 0.501:
		parent_progress.rotates = false
		self.flip_v = true
		self.get_child(0).flip_v = true
		parent_progress.rotates = true
