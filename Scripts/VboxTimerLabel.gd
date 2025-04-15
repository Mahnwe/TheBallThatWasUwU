extends VBoxContainer

# Called when the node enters the scene tree for the first time.
func instantiate(file_data):
	self.get_child(0).text = _format_seconds(file_data[0])
	self.get_child(1).text = _format_seconds(file_data[1])
	self.get_child(2).text = _format_seconds(file_data[2])
	self.get_child(3).text = _format_seconds(file_data[3])
	self.get_child(4).text = _format_seconds(file_data[4])

func _format_seconds(time : float) -> String:
	var minutes := time / 60
	var seconds := fmod(time, 60)
	var milliseconds := fmod(time, 1) * 1000

	return "%02d:%02d:%03d" % [minutes, seconds, milliseconds]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
