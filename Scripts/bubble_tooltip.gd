extends Sprite2D

@export var bubble_message = ""
# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = bubble_message

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
