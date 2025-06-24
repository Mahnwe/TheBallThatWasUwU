extends Control

var player_have_dash
var is_displaying = false
var properties_config = ConfigFile.new()
# Load data from a file.
var properties_file = properties_config.load("res://Ressources/PropertieFile/properties.cfg")
var translate_file
signal commands_closed

# Called when the node enters the scene tree for the first time.
func _ready():
	if (properties_config.get_value("levels", "is_level_two_finished")):
		player_have_dash = true
	translate_text()
	$Dash.hide()
	$Keyboard1/DashK1.hide()
	$Keyboard2/DashK2.hide()
	$Controller/DashC.hide()
	$CloseButton.focus_mode = FOCUS_NONE


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if is_displaying:
		if Input.is_action_just_pressed("close_commands") and $Timer.time_left == 0.0:
			close_commands()
		if Input.is_action_just_pressed("restart_save") and $Timer.time_left == 0.0:
			close_commands()
		if Input.is_action_just_pressed("menu_when_finish") and $Timer.time_left == 0.0:
			close_commands()
	if player_have_dash:
		$Dash.show()
		$Keyboard1/DashK1.show()
		$Keyboard2/DashK2.show()
		$Controller/DashC.show()
		
		
func _on_close_button_gui_input(event):
	if $CloseButton.has_focus() and event is InputEventKey or event is InputEventJoypadButton:
		if event.is_action_pressed("ui_left"):
			accept_event() # prevent the normal focus-stuff from happening
			$CloseButton.grab_focus()
		elif event.is_action_pressed("ui_up"):
			accept_event()
			$CloseButton.grab_focus()
		elif event.is_action_pressed("ui_down") or event.is_action_pressed("ui_right"):
			accept_event() # prevent the normal focus-stuff from happening
			$CloseButton.grab_focus() 


func _on_close_button_mouse_entered():
	if $CloseButton.is_hovered():
		$CloseButton.grab_focus()
		
func _on_close_button_pressed():
	close_commands()
	
func close_commands():
	$CloseButton.release_focus()
	is_displaying = false
	self.hide()
	commands_closed.emit()
		
func translate_text():
	var translate_config = ConfigFile.new()
	if properties_config.get_value("Languages", "is_english"):
		translate_file = translate_config.load("res://Ressources/TranslateFiles/Eng_Translate.cfg")
	else:
		translate_file = translate_config.load("res://Ressources/TranslateFiles/Fr_Translate.cfg")
		$Keyboard1.text = translate_config.get_value("TranslationCommands", "Righty")
		$Keyboard2.text = translate_config.get_value("TranslationCommands", "Lefty")
		$Controller.text = translate_config.get_value("TranslationCommands", "Controller")
		$Movements.text = translate_config.get_value("TranslationCommands", "Movements")
		$Jump.text = translate_config.get_value("TranslationCommands", "Jump")
		$RestartSave.text = translate_config.get_value("TranslationCommands", "RestartSave")
		$RestartLevel.text = translate_config.get_value("TranslationCommands", "RestartLevel")
		$Pause.text = translate_config.get_value("TranslationCommands", "Pause")
		$Dash.text = translate_config.get_value("TranslationCommands", "Dash")


func _on_visibility_changed():
	if self.visible:
		is_displaying = true
		$CloseButton.focus_mode = FOCUS_ALL
		$CloseButton.grab_focus()
		$Timer.start()
	else:
		is_displaying = false
