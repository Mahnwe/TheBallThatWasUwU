extends StaticBody2D

@export var flip_h_setup = false
@export var flip_v_setup = false

func _ready():
	$Sprite2D.flip_h = flip_h_setup
	$Sprite2D.flip_v = flip_v_setup
	
	
func _process(_delta):
	pass
