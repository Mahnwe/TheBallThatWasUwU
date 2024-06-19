extends StaticBody2D
signal set_up_sign_label

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_up_labels():
	set_up_sign_label.emit()
