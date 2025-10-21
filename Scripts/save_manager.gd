extends Node

var properties_data
var stats_data

var default_properties_data
var default_stats_data

var properties_config = ConfigFile.new()
var properties_file

var stats_config = ConfigFile.new()
var stats_file

func _ready():
	create_config_saves_directory()
	create_properties_save()
	create_stats_save()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func create_config_saves_directory():
	if !DirAccess.dir_exists_absolute("user://ConfigSaves"):
		DirAccess.make_dir_absolute("user://ConfigSaves")
		
func get_properties_value(group_name, variable):
	return properties_config.get_value(group_name, variable)
	
func get_stats_value(group_name, variable):
	return stats_config.get_value(group_name, variable)
	
func save_properties_value(group_name, variable, value):
	properties_config.set_value(group_name, variable, value)
	properties_config.save("user://ConfigSaves/properties.cfg")
	
func save_stats_value(group_name, variable, value):
	stats_config.set_value(group_name, variable, value)
	stats_config.save("user://ConfigSaves/stats.cfg")
		
func create_properties_save():
	if !FileAccess.file_exists("user://ConfigSaves/properties.cfg"):
		var config = ConfigFile.new()

		# Store game values.
		config.set_value("Languages", "is_english", true)
		config.set_value("Launch", "is_first_launch", true)
		config.set_value("levels", "is_level_one_finished", false)
		config.set_value("levels", "is_level_two_finished", false)
		config.set_value("levels", "is_level_three_finished", false)
		config.set_value("levels", "is_level_four_finished", false)
		config.set_value("levels", "is_level_five_finished", false)
		config.set_value("levels", "is_level_six_finished", false)
		config.set_value("levels", "is_level_seven_finished", false)
		config.set_value("medals", "level_one_medal", 0)
		config.set_value("medals", "level_two_medal", 0)
		config.set_value("medals", "level_three_medal", 0)
		config.set_value("medals", "level_four_medal", 0)
		config.set_value("medals", "level_five_medal", 0)
		config.set_value("medals", "level_six_medal", 0)
		config.set_value("medals", "level_seven_medal", 0)
		config.set_value("Chests", "level_one_chest", false)
		config.set_value("Chests", "level_two_chest", false)
		config.set_value("Chests", "level_three_chest", false)
		config.set_value("Chests", "level_four_chest", false)
		config.set_value("Chests", "level_five_chest", false)
		config.set_value("Chests", "level_six_chest", false)
		config.set_value("Chests", "chestNumber", 0)
		config.set_value("WindowMod", "is_fullscreen", true)
		config.set_value("musicVolume", "musicVolumeSet", -10)
		config.set_value("musicVolume", "is_music_mute", false)
		config.set_value("effectVolume", "effectVolumeSet", -20)
		config.set_value("effectVolume", "is_effect_mute", false)
		config.set_value("musicSliderValue", "sliderMusicValue", 3.0)
		config.set_value("effectSliderValue", "sliderEffectValue", 2.0)

		# Save it to a file.
		config.save("user://ConfigSaves/properties.cfg")
	else:
		properties_file = properties_config.load("user://ConfigSaves/properties.cfg")
	
func create_stats_save():
	if !FileAccess.file_exists("user://ConfigSaves/stats.cfg"):
		var config = ConfigFile.new()

		# Store stats values.
		config.set_value("Stats", "jump_number", 0)
		config.set_value("Stats", "dash_number", 0)
		config.set_value("Stats", "death_number", 0)
		config.set_value("Stats", "spike_death_number", 0)
		config.set_value("Stats", "cannon_death_number", 0)
		config.set_value("Stats", "coral_death_number", 0)
		config.set_value("Stats", "acid_death_number", 0)
		config.set_value("Stats", "laser_death_number", 0)
		config.set_value("Stats", "finished_level_number", 0)
		config.set_value("Stats", "level_one_finished_number", 0)
		config.set_value("Stats", "level_two_finished_number", 0)
		config.set_value("Stats", "level_three_finished_number", 0)
		config.set_value("Stats", "level_four_finished_number", 0)
		config.set_value("Stats", "level_five_finished_number", 0)
		config.set_value("Stats", "level_six_finished_number", 0)
		config.set_value("Stats", "level_seven_finished_number", 0)
		config.set_value("Stats", "medal_number", 0)
		config.set_value("Stats", "bronze_medal_number", 0)
		config.set_value("Stats", "silver_medal_number", 0)
		config.set_value("Stats", "gold_medal_number", 0)
		config.set_value("Stats", "dev_medal_number", 0)
		config.set_value("Stats", "time_played", 0.0)

		# Save it to a file.
		config.save("user://ConfigSaves/stats.cfg")
	else:
		stats_file = stats_config.load("user://ConfigSaves/stats.cfg")
