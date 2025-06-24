extends Control


var stats_config= ConfigFile.new()
var stats_file = stats_config.load("res://Ressources/PropertieFile/stats.cfg")

var properties_config = ConfigFile.new()

# Load data from a file.
var properties_file = properties_config.load("res://Ressources/PropertieFile/properties.cfg")

var translate_file

# Called when the node enters the scene tree for the first time.
func _ready():
	translate_text()
	set_up_stats_with_file()
	$QuitButton.grab_focus()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("restart_save"):
		self.hide()
	
	
func set_up_stats_with_file():
	$HSplitContainer/VBoxContainer/HSplitContainer/JumpNumber.text = str(stats_config.get_value("Stats", "jump_number"))
	$HSplitContainer/VBoxContainer/HSplitContainer2/DashNumber.text = str(stats_config.get_value("Stats", "dash_number"))
	$HSplitContainer/VBoxContainer/HSplitContainer9/DeathNumber.text = str(stats_config.get_value("Stats", "death_number"))
	$HSplitContainer/VBoxContainer/HSplitContainer3/DeathSpikeNumber.text = str(stats_config.get_value("Stats", "spike_death_number"))
	$HSplitContainer/VBoxContainer/HSplitContainer4/DeathCannonNumber.text = str(stats_config.get_value("Stats", "cannon_death_number"))
	$HSplitContainer/VBoxContainer/HSplitContainer5/DeathCoralNumber.text = str(stats_config.get_value("Stats", "coral_death_number"))
	$HSplitContainer/VBoxContainer/HSplitContainer6/DeathAcidNumber.text = str(stats_config.get_value("Stats", "acid_death_number"))
	$HSplitContainer/VBoxContainer/HSplitContainer7/DeathLaserNumber.text = str(stats_config.get_value("Stats", "laser_death_number"))
	$HSplitContainer/VBoxContainer/HSplitContainer8/ChestNumber.text = str(properties_config.get_value("Chests", "chestNumber"))
	$HSplitContainer/VBoxContainer3/HSplitContainer/LevelNumber.text = str(stats_config.get_value("Stats", "finished_level_number"))
	$HSplitContainer/VBoxContainer3/HSplitContainer2/Level1Number.text = str(stats_config.get_value("Stats", "level_one_finished_number"))
	$HSplitContainer/VBoxContainer3/HSplitContainer3/Level2Number.text = str(stats_config.get_value("Stats", "level_two_finished_number"))
	$HSplitContainer/VBoxContainer3/HSplitContainer4/Level3Number.text = str(stats_config.get_value("Stats", "level_three_finished_number"))
	$HSplitContainer/VBoxContainer3/HSplitContainer5/Level4Number.text = str(stats_config.get_value("Stats", "level_four_finished_number"))
	$HSplitContainer/VBoxContainer3/HSplitContainer6/Level5Number.text = str(stats_config.get_value("Stats", "level_five_finished_number"))
	$HSplitContainer/VBoxContainer3/HSplitContainer7/Level6Number.text = str(stats_config.get_value("Stats", "level_six_finished_number"))
	$HSplitContainer/VBoxContainer3/HSplitContainer8/Level7Number.text = str(stats_config.get_value("Stats", "level_seven_finished_number"))
	$VBoxContainer2/HSplitContainer/MedalNumber.text = str(stats_config.get_value("Stats", "medal_number"))
	$VBoxContainer2/HSplitContainer2/BronzeMedalNumber.text = str(stats_config.get_value("Stats", "bronze_medal_number"))
	$VBoxContainer2/HSplitContainer3/SilverMedalNumber.text = str(stats_config.get_value("Stats", "silver_medal_number"))
	$VBoxContainer2/HSplitContainer4/GoldMedalNumber.text = str(stats_config.get_value("Stats", "gold_medal_number"))
	$VBoxContainer2/HSplitContainer5/DevMedalNumber.text = str(stats_config.get_value("Stats", "dev_medal_number"))


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
		$VBoxContainer2.position.x = 1300.0
	else:
		translate_file = translate_config.load("res://Ressources/TranslateFiles/Fr_Translate.cfg")
		$VBoxContainer2.position.x = 1239.0
		
	$HSplitContainer/VBoxContainer/HSplitContainer/JumpsLabel.text = translate_config.get_value("TranslationStats", "Jumps")
	$HSplitContainer/VBoxContainer/HSplitContainer2/DashLabel.text = translate_config.get_value("TranslationStats", "Dash")
	$HSplitContainer/VBoxContainer/HSplitContainer9/DeathsLabel.text = translate_config.get_value("TranslationStats", "Deaths")
	$HSplitContainer/VBoxContainer/HSplitContainer3/DeathSpike.text = translate_config.get_value("TranslationStats", "SpikeDeath")
	$HSplitContainer/VBoxContainer/HSplitContainer4/CannonDeath.text = translate_config.get_value("TranslationStats", "CannonDeath")
	$HSplitContainer/VBoxContainer/HSplitContainer5/CoralDeath.text = translate_config.get_value("TranslationStats", "CoralDeath")
	$HSplitContainer/VBoxContainer/HSplitContainer6/AcidDeath.text = translate_config.get_value("TranslationStats", "AcidDeath")
	$HSplitContainer/VBoxContainer/HSplitContainer7/LaserDeath.text = translate_config.get_value("TranslationStats", "LaserDeath")
	$HSplitContainer/VBoxContainer/HSplitContainer8/ChestsLabel.text = translate_config.get_value("TranslationStats", "Chests")
		
	$HSplitContainer/VBoxContainer3/HSplitContainer/LevelFinishedLabel.text = translate_config.get_value("TranslationStats", "LevelFinished")
	$HSplitContainer/VBoxContainer3/HSplitContainer2/Level1FinishedLabel.text = translate_config.get_value("TranslationStats", "Level1Finished")
	$HSplitContainer/VBoxContainer3/HSplitContainer3/Level2FinishedLabel.text = translate_config.get_value("TranslationStats", "Level2Finished")
	$HSplitContainer/VBoxContainer3/HSplitContainer4/Level3FinishedLabel.text = translate_config.get_value("TranslationStats", "Level3Finished")
	$HSplitContainer/VBoxContainer3/HSplitContainer5/Level4FinishedLabel.text = translate_config.get_value("TranslationStats", "Level4Finished")
	$HSplitContainer/VBoxContainer3/HSplitContainer6/Level5FinishedLabel.text = translate_config.get_value("TranslationStats", "Level5Finished")
	$HSplitContainer/VBoxContainer3/HSplitContainer7/Level6FinishedLabel.text = translate_config.get_value("TranslationStats", "Level6Finished")
	$HSplitContainer/VBoxContainer3/HSplitContainer8/Level7FinishedLabel.text = translate_config.get_value("TranslationStats", "Level7Finished")
	$VBoxContainer2/HSplitContainer/MedalNumberLabel.text = translate_config.get_value("TranslationStats", "NumberOfMedal")
	$VBoxContainer2/HSplitContainer2/BronzeMedalLabel.text = translate_config.get_value("TranslationStats", "NumberOfBronzeMedal")
	$VBoxContainer2/HSplitContainer3/SilverMedalLabel.text = translate_config.get_value("TranslationStats", "NumberOfSilverMedal")
	$VBoxContainer2/HSplitContainer4/GoldMedalLabel.text = translate_config.get_value("TranslationStats", "NumberOfGoldMedal")
	$VBoxContainer2/HSplitContainer5/DevMedalLabel.text = translate_config.get_value("TranslationStats", "NumberOfDevMedal")
	
