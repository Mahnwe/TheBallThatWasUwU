extends Node2D

var config = ConfigFile.new()
# Load data from a file.
var config_file = config.load("res://Ressources/PropertieFile/properties.cfg")

var translate_file

var level_number=0
var properties_key
var is_trigger
signal chest_triggered

# Called when the node enters the scene tree for the first time.
func _ready():
	is_trigger = false
	translate_text()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func set_level_number(number_from_level):
	level_number = number_from_level
	set_properties_key()
	print(level_number)
	
func set_properties_key():
	if level_number == 1:
		properties_key = "level_one_chest"
		print("level 1 chest saved")
	if level_number == 2:
		properties_key = "level_two_chest"
		print("level 2 chest saved")
	if level_number == 3:
		properties_key = "level_three_chest"
		print("level 3 chest saved")
	if level_number == 4:
		properties_key = "level_four_chest"
	if level_number == 5:
		properties_key = "level_five_chest"
	if level_number == 6:
		properties_key = "level_six_chest"


func _on_area_2d_body_entered(body):
	if body.name == "Player" and !is_trigger:
		print("Enter trigger")
		is_trigger = true
		$Label.show()
		chest_triggered.emit()
		for n in 6:
			self.hide()
			await get_tree().create_timer(0.2).timeout;
			self.show()
			await get_tree().create_timer(0.2).timeout;
		queue_free()
	
func chest_already_picked():
	queue_free()
	
func translate_text():
	var translate_config = ConfigFile.new()
	if config.get_value("Languages", "is_english"):
		translate_file = translate_config.load("res://Ressources/TranslateFiles/Eng_Translate.cfg")
	else:
		translate_file = translate_config.load("res://Ressources/TranslateFiles/Fr_Translate.cfg")
	$Label.text = translate_config.get_value("TranslationChest", "ChestLabel")
