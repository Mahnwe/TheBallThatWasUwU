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
	$JumpNumber.text = str(stats_config.get_value("Stats", "jump_number"))
	$DashNumber.text = str(stats_config.get_value("Stats", "dash_number"))
	$DeathNumber.text = str(stats_config.get_value("Stats", "death_number"))
	$DeathSpikeNumber.text = str(stats_config.get_value("Stats", "spike_death_number"))
	$DeathCannonNumber.text = str(stats_config.get_value("Stats", "cannon_death_number"))
	$DeathCoralNumber.text = str(stats_config.get_value("Stats", "coral_death_number"))
	$DeathAcidNumber.text = str(stats_config.get_value("Stats", "acid_death_number"))
	$DeathLaserNumber.text = str(stats_config.get_value("Stats", "laser_death_number"))
	$ChestNumber.text = str(properties_config.get_value("Chests", "chestNumber"))
	$LevelNumber.text = str(stats_config.get_value("Stats", "finished_level_number"))
	$Level1Number.text = str(stats_config.get_value("Stats", "level_one_finished_number"))
	$Level2Number.text = str(stats_config.get_value("Stats", "level_two_finished_number"))
	$Level3Number.text = str(stats_config.get_value("Stats", "level_three_finished_number"))
	$Level4Number.text = str(stats_config.get_value("Stats", "level_four_finished_number"))
	$Level5Number.text = str(stats_config.get_value("Stats", "level_five_finished_number"))
	$Level6Number.text = str(stats_config.get_value("Stats", "level_six_finished_number"))
	$Level7Number.text = str(stats_config.get_value("Stats", "level_seven_finished_number"))


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
		$VBoxContainer/JumpsLabel.text = translate_config.get_value("TranslationStats", "Jumps")
		$VBoxContainer/DashLabel.text = translate_config.get_value("TranslationStats", "Dash")
		$VBoxContainer/DeathsLabel.text = translate_config.get_value("TranslationStats", "Deaths")
		$VBoxContainer/DeathSpike.text = translate_config.get_value("TranslationStats", "SpikeDeath")
		$VBoxContainer/CannonDeath.text = translate_config.get_value("TranslationStats", "CannonDeath")
		$VBoxContainer/CoralDeath.text = translate_config.get_value("TranslationStats", "CoralDeath")
		$VBoxContainer/AcidDeath.text = translate_config.get_value("TranslationStats", "AcidDeath")
		$VBoxContainer/LaserDeath.text = translate_config.get_value("TranslationStats", "LaserDeath")
		$VBoxContainer/ChestsLabel.text = translate_config.get_value("TranslationStats", "Chests")
		
		$VBoxContainer3/LevelFinishedLabel.text = translate_config.get_value("TranslationStats", "LevelFinished")
		$VBoxContainer3/Label4.text = translate_config.get_value("TranslationStats", "Level1Finished")
		$VBoxContainer3/Label5.text = translate_config.get_value("TranslationStats", "Level2Finished")
		$VBoxContainer3/Label6.text = translate_config.get_value("TranslationStats", "Level3Finished")
		$VBoxContainer3/Label.text = translate_config.get_value("TranslationStats", "Level4Finished")
		$VBoxContainer3/Label2.text = translate_config.get_value("TranslationStats", "Level5Finished")
		$VBoxContainer3/Label3.text = translate_config.get_value("TranslationStats", "Level6Finished")
		$VBoxContainer3/Label7.text = translate_config.get_value("TranslationStats", "Level7Finished")
	
