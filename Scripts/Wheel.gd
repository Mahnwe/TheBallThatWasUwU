extends StaticBody2D

@export var degrees_per_second = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Sprite2D.rotate((delta / 10) * deg_to_rad(degrees_per_second))
