extends Sprite2D

var is_chest_valid
var check_chest

func _ready():
	is_chest_valid = false
	check_chests()
	
func _process(_delta):
	pass
	
func check_chests():
	if (self.get_parent().name == "Level1Button"):
		check_chest = $SaveManager.get_properties_value("Chests", "level_one_chest")
		if check_chest:
			is_chest_valid = true
	if (self.get_parent().name == "Level2Button"):
		check_chest = $SaveManager.get_properties_value("Chests", "level_two_chest")
		if check_chest:
			is_chest_valid = true
	if (self.get_parent().name == "Level3Button"):
		check_chest = $SaveManager.get_properties_value("Chests", "level_three_chest")
		if check_chest:
			is_chest_valid = true
	if (self.get_parent().name == "Level4Button"):
		check_chest = $SaveManager.get_properties_value("Chests", "level_four_chest")
		if check_chest:
			is_chest_valid = true
	if (self.get_parent().name == "Level5Button"):
		check_chest = $SaveManager.get_properties_value("Chests", "level_five_chest")
		if check_chest:
			is_chest_valid = true
	if (self.get_parent().name == "Level6Button"):
		check_chest = $SaveManager.get_properties_value("Chests", "level_six_chest")
		if check_chest:
			is_chest_valid = true
