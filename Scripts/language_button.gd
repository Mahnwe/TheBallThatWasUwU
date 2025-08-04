extends Button

var properties_config = ConfigFile.new()

# Load data from a file.
var properties_file = properties_config.load("res://Ressources/PropertieFile/properties.cfg")

var actual_select_language

func _ready():
	change_language_flag(properties_config.get_value("Languages", "is_english"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func _on_focus_entered():
	if self.focus_mode == FOCUS_ALL:
		self.grab_focus()

func _on_focus_exited():
	self.release_focus()

func _on_mouse_entered():
	if self.focus_mode == FOCUS_ALL:
		self.grab_focus()


func _on_mouse_exited():
	self.release_focus()
	
func change_language_flag(is_english):
	if is_english:
		actual_select_language = true
		$French.hide()
		$English.show()
	else:
		actual_select_language = false
		$English.hide()
		$French.show()
