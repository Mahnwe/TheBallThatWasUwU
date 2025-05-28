extends Sprite2D

var is_level_done
var check_level

var properties_config = ConfigFile.new()
# Load data from a file.
var properties_file = properties_config.load("res://Ressources/PropertieFile/properties.cfg")

var bronze_texture = load("res://Arts/MedalSprite/BronzeMedal.png")
var silver_texture = load("res://Arts/MedalSprite/SilverMedal.png")
var gold_texture = load("res://Arts/MedalSprite/GoldMedal.png")
var dev_texture = load("res://Arts/MedalSprite/DevMedal.png")
var nomedal_texture = load("res://Arts/CloudButtonSprite/Validate.png")

func _ready():
	is_level_done = false
	check_level_done()
	
func _process(_delta):
	pass
	
func check_level_done():
	if (self.get_parent().name == "Level1Button"):
		check_level = properties_config.get_value("levels", "is_level_one_finished")
		if check_level:
			is_level_done = true
			var check_medal = properties_config.get_value("medals", "level_one_medal")
			if check_medal == 1:
				self.texture = bronze_texture
			if check_medal == 2:
				self.texture = silver_texture
			if check_medal == 3:
				self.texture = gold_texture
			if check_medal == 4:
				self.texture = dev_texture
	if (self.get_parent().name == "Level2Button"):
		check_level = properties_config.get_value("levels", "is_level_two_finished")
		if check_level:
			is_level_done = true
			var check_medal = properties_config.get_value("medals", "level_two_medal")
			if check_medal == 1:
				self.texture = bronze_texture
			if check_medal == 2:
				self.texture = silver_texture
			if check_medal == 3:
				self.texture = gold_texture
			if check_medal == 4:
				self.texture = dev_texture
	if (self.get_parent().name == "Level3Button"):
		check_level = properties_config.get_value("levels", "is_level_three_finished")
		if check_level:
			is_level_done = true
			var check_medal = properties_config.get_value("medals", "level_three_medal")
			if check_medal == 1:
				self.texture = bronze_texture
			if check_medal == 2:
				self.texture = silver_texture
			if check_medal == 3:
				self.texture = gold_texture
			if check_medal == 4:
				self.texture = dev_texture
	if (self.get_parent().name == "Level4Button"):
		check_level = properties_config.get_value("levels", "is_level_four_finished")
		if check_level:
			is_level_done = true
			var check_medal = properties_config.get_value("medals", "level_four_medal")
			if check_medal == 1:
				self.texture = bronze_texture
			if check_medal == 2:
				self.texture = silver_texture
			if check_medal == 3:
				self.texture = gold_texture
			if check_medal == 4:
				self.texture = dev_texture
	if (self.get_parent().name == "Level5Button"):
		check_level = properties_config.get_value("levels", "is_level_five_finished")
		if check_level:
			is_level_done = true
			var check_medal = properties_config.get_value("medals", "level_five_medal")
			if check_medal == 1:
				self.texture = bronze_texture
			if check_medal == 2:
				self.texture = silver_texture
			if check_medal == 3:
				self.texture = gold_texture
			if check_medal == 4:
				self.texture = dev_texture
	if (self.get_parent().name == "Level6Button"):
		check_level = properties_config.get_value("levels", "is_level_six_finished")
		if check_level:
			is_level_done = true
			var check_medal = properties_config.get_value("medals", "level_six_medal")
			if check_medal == 1:
				self.texture = bronze_texture
			if check_medal == 2:
				self.texture = silver_texture
			if check_medal == 3:
				self.texture = gold_texture
			if check_medal == 4:
				self.texture = dev_texture
	if (self.get_parent().name == "Level7Button"):
		check_level = properties_config.get_value("levels", "is_level_seven_finished")
		if check_level:
			is_level_done = true
			var check_medal = properties_config.get_value("medals", "level_seven_medal")
			if check_medal == 1:
				self.texture = bronze_texture
			if check_medal == 2:
				self.texture = silver_texture
			if check_medal == 3:
				self.texture = gold_texture
			if check_medal == 4:
				self.texture = dev_texture
