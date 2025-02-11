extends Area2D

var degrees_per_second = 360.0
@export var is_in_water = false
# Called when the node enters the scene tree for the first time.
func _ready():
	if is_in_water:
		$Sprite2D.self_modulate.a = 0.5


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotate_portal(delta)
	
func rotate_portal(delta):
	$Sprite2D.rotate((delta / 100) * deg_to_rad(degrees_per_second))
