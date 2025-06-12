extends Control

var properties_config = ConfigFile.new()

# Load data from a file.
var properties_file = properties_config.load("res://Ressources/PropertieFile/properties.cfg")

var translate_file

func _ready():
	translate_text()
	$QuitButton.grab_focus()

# Called every frame. 'delta' is the elapsed time since the previous frame.
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
			
func translate_text():
	var translate_config = ConfigFile.new()
	if properties_config.get_value("Languages", "is_english"):
		translate_file = translate_config.load("res://Ressources/TranslateFiles/Eng_Translate.cfg")
	else:
		translate_file = translate_config.load("res://Ressources/TranslateFiles/Fr_Translate.cfg")
		
	$HSplitContainer/VBoxContainer/VSplitContainer/DevCredit.text = translate_config.get_value("TranslationCredits", "DevCredit")
	$HSplitContainer/VBoxContainer/VSplitContainer3/MusicsCredit.text = translate_config.get_value("TranslationCredits", "SoundCredit")
	$HSplitContainer/VBoxContainer2/VSplitContainer3/AnimationCredit.text = translate_config.get_value("TranslationCredits", "AnimationCredit")
	$HSplitContainer/VBoxContainer2/VSplitContainer2/HelpCredit.text = translate_config.get_value("TranslationCredits", "HelpCredit")
