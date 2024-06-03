extends StaticBody2D

signal spike_hit
var parent_name
@export var speed = 300
# Called when the node enters the scene tree for the first time.
func _ready():
	parent_name = get_parent()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_patrol(delta)

func _on_spike_area_body_entered(body):
	if body.name == "Player":
		spike_hit.emit()
		
func _patrol(delta):
	if parent_name.get_name() == "PathFollow2D":
		parent_name.progress += speed * delta
