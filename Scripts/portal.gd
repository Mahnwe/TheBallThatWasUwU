extends Area2D

var degrees_per_second = 360.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotate_portal(delta)
	
func rotate_portal(delta):
	$Sprite2D.rotate((delta / 100) * deg_to_rad(degrees_per_second))
