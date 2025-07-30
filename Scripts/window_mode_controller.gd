extends Button

var properties_config = ConfigFile.new()
var translate_config = ConfigFile.new()

# Load data from a file.
var properties_file = properties_config.load("res://Ressources/PropertieFile/properties.cfg")

var translate_file

var fullscreen_label
var windowed_label

func _ready():
	translate_text(properties_config.get_value("Languages", "is_english"))
	self.flat = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func translate_text(is_english):
	if is_english:
		translate_file = translate_config.load("res://Ressources/TranslateFiles/Eng_Translate.cfg")
	else:
		translate_file = translate_config.load("res://Ressources/TranslateFiles/Fr_Translate.cfg")
	fullscreen_label = translate_config.get_value("TranslationWindowMod", "Fullscreen")
	windowed_label = translate_config.get_value("TranslationWindowMod", "Windowed")
	setup_label()
	
func setup_label():
	if properties_config.get_value("WindowMod", "is_fullscreen"):
		$Label.text = fullscreen_label
	else:
		$Label.text = windowed_label


func _on_focus_entered():
	self.grab_focus()
	$Label.visible = true

func _on_focus_exited():
	self.release_focus()
	$Label.visible = false

func _on_mouse_entered():
	self.grab_focus()
	$Label.visible = true


func _on_mouse_exited():
	self.release_focus()
	$Label.visible = false
