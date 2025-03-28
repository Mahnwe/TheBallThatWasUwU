extends Node2D

@export var flip_value = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	if flip_value != 0:
		$Sprite2D.flip_h = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
