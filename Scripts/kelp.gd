extends Node2D

@export
var is_flip = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_flip:
		$Sprite2D.flip_h = true
	$Sprite2D.self_modulate.a = 0.7
	$Sprite2D.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
