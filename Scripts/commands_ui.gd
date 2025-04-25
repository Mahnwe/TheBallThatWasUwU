extends Control

var player_have_dash

var properties_config = ConfigFile.new()
# Load data from a file.
var properties_file = properties_config.load("res://Ressources/PropertieFile/properties.cfg")
var translate_file


# Called when the node enters the scene tree for the first time.
func _ready():
	if (properties_config.get_value("levels", "is_level_two_finished")):
		player_have_dash = true
	translate_text()
	$Dash.hide()
	$Keyboard1/DashK1.hide()
	$Keyboard2/DashK2.hide()
	$Controller/DashC.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if player_have_dash:
		$Dash.show()
		$Keyboard1/DashK1.show()
		$Keyboard2/DashK2.show()
		$Controller/DashC.show()
		
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
