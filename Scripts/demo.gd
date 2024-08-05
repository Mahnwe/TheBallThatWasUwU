extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	demo_label_flashing()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func demo_label_flashing():
	self.show()
	while(true):
		self.hide()
		await get_tree().create_timer(0.8).timeout;
		self.show()
		await get_tree().create_timer(0.8).timeout;
