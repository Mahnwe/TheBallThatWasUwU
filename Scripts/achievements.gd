extends Control

var stats_config= ConfigFile.new()
var stats_file = stats_config.load("res://Ressources/PropertieFile/stats.cfg")

var properties_config = ConfigFile.new()

# Load data from a file.
var properties_file = properties_config.load("res://Ressources/PropertieFile/properties.cfg")

var translate_file


func _ready():
	translate_text(properties_config.get_value("Languages", "is_english"))
	$QuitButton.grab_focus()
	
	
func _process(_delta):
	if Input.is_action_just_pressed("restart_save"):
		self.hide()
		
func _on_quit_button_pressed():
	self.hide()
	
func _on_quit_button_gui_input(event):
	if $QuitButton.has_focus() and event is InputEventKey or event is InputEventJoypadButton:
		if event.is_action_pressed("ui_left"):
			accept_event() # prevent the normal focus-stuff from happening
			$QuitButton.grab_focus()
		elif event.is_action_pressed("ui_up"):
			accept_event()
			$QuitButton.grab_focus()
		elif event.is_action_pressed("ui_down") or event.is_action_pressed("ui_right"):
			accept_event() # prevent the normal focus-stuff from happening
			$QuitButton.grab_focus()
			
func translate_text(is_english):
	var translate_config = ConfigFile.new()
	if is_english:
		translate_file = translate_config.load("res://Ressources/TranslateFiles/Eng_Translate.cfg")
		$Title.add_theme_font_size_override("font_size", 120)
		$Title.position = Vector2(656, 121)
	else:
		translate_file = translate_config.load("res://Ressources/TranslateFiles/Fr_Translate.cfg")
		$Title.add_theme_font_size_override("font_size", 140)
		$Title.position = Vector2(770, 111)
		
	$Title.text = translate_config.get_value("TranslationAchievements", "TitleAchievements")
