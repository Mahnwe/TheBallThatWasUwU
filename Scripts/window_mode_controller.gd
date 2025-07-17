extends Button

var properties_config = ConfigFile.new()
var translate_config = ConfigFile.new()

# Load data from a file.
var properties_file = properties_config.load("res://Ressources/PropertieFile/properties.cfg")

var translate_file

var fullscreen_label
var windowed_label

func _ready():
	translate_text()
	if properties_config.get_value("WindowMod", "is_fullscreen"):
		$Label.text = fullscreen_label
	else:
		$Label.text = windowed_label
	self.flat = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func translate_text():
	if properties_config.get_value("Languages", "is_english"):
		translate_file = translate_config.load("res://Ressources/TranslateFiles/Eng_Translate.cfg")
	else:
		translate_file = translate_config.load("res://Ressources/TranslateFiles/Fr_Translate.cfg")
	fullscreen_label = translate_config.get_value("TranslationWindowMod", "Fullscreen")
	windowed_label = translate_config.get_value("TranslationWindowMod", "Windowed")


func _on_focus_entered():
	self.flat = false
	$Label.visible = true


func _on_focus_exited():
	$Label.visible = false
	self.flat = true

func _on_mouse_entered():
	self.grab_focus()
	self.flat = false
	$Label.visible = true


func _on_mouse_exited():
	self.release_focus()
	$Label.visible = false
	self.flat = true
