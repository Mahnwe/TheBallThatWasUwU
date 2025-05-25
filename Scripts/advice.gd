extends Node2D

# Load data from a file.
var config = ConfigFile.new()
var config_file = config.load("res://Ressources/PropertieFile/properties.cfg")

var translate_file

func _ready():
	translate_text()
	
func _process(_delta):
	if self.visible and $Timer.wait_time == 0.0:
		$Timer.start()


func _on_timer_timeout():
	self.hide()


func _on_visibility_changed():
	$Timer.start()
	
func translate_text():
	var translate_config = ConfigFile.new()
	if config.get_value("Languages", "is_english"):
		translate_file = translate_config.load("res://Ressources/TranslateFiles/Eng_Translate.cfg")
	else:
		translate_file = translate_config.load("res://Ressources/TranslateFiles/Fr_Translate.cfg")
		
	$Sprite2D/BubbleTooltip.get_child(0).text = translate_config.get_value("TranslationAdvice", "AbilitiesAdvice")
