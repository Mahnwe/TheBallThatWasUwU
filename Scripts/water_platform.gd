extends AnimatableBody2D

var parent_name
@export var speed = 150
# Called when the node enters the scene tree for the first time.
func _ready():
	parent_name = get_parent()
	$MeshInstance2D.self_modulate.a = 0.5


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_patrol(delta)
	
	
	
func _patrol(delta):
	if parent_name.get_name() == "PathFollow2D":
		parent_name.progress += speed * delta
		
