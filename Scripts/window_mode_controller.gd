extends Button
var translate_config = ConfigFile.new()

var translate_file

var fullscreen_label
var windowed_label

func _ready():
	translate_text($SaveManager.get_properties_value("Languages", "is_english"))
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
	if $SaveManager.get_properties_value("WindowMod", "is_fullscreen"):
		$Label.text = fullscreen_label
	else:
		$Label.text = windowed_label


func _on_focus_entered():
	if self.focus_mode == FOCUS_ALL:
		self.grab_focus()
		$Label.visible = true

func _on_focus_exited():
	self.release_focus()
	$Label.visible = false

func _on_mouse_entered():
	if self.focus_mode == FOCUS_ALL:
		self.grab_focus()
		$Label.visible = true


func _on_mouse_exited():
	self.release_focus()
	$Label.visible = false
