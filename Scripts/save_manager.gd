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
	create_save_files()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func create_save_files():
	create_config_saves_directory()
	create_properties_save()
	create_rank_files()
	create_stats_save()
	
func create_config_saves_directory():
	if !DirAccess.dir_exists_absolute("user://Saves"):
		DirAccess.make_dir_absolute("user://Saves")
	if !DirAccess.dir_exists_absolute("user://Saves/GlobalSaves"):
		DirAccess.make_dir_absolute("user://Saves/GlobalSaves")
	if !DirAccess.dir_exists_absolute("user://Saves/StatsSaves"):
		DirAccess.make_dir_absolute("user://Saves/StatsSaves")
	if !DirAccess.dir_exists_absolute("user://Saves/RankSaves"):
		DirAccess.make_dir_absolute("user://Saves/RankSaves")
		
func get_properties_value(group_name, variable):
	return properties_config.get_value(group_name, variable)
	
func get_stats_value(group_name, variable):
	return stats_config.get_value(group_name, variable)
	
func save_properties_value(group_name, variable, value):
	properties_config.set_value(group_name, variable, value)
	properties_config.save("user://Saves/GlobalSaves/properties.cfg")
	
func save_stats_value(group_name, variable, value):
	stats_config.set_value(group_name, variable, value)
	stats_config.save("user://Saves/StatsSaves/stats.cfg")
		
func create_properties_save():
	if !FileAccess.file_exists("user://Saves/GlobalSaves/properties.cfg"):
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
		config.save("user://Saves/GlobalSaves/properties.cfg")
	else:
		properties_file = properties_config.load("user://Saves/GlobalSaves/properties.cfg")
	
func create_stats_save():
	if !FileAccess.file_exists("user://Saves/StatsSaves/stats.cfg"):
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
		config.save("user://Saves/StatsSaves/stats.cfg")
	else:
		stats_file = stats_config.load("user://Saves/StatsSaves/stats.cfg")
		
func create_rank_files():
	if !FileAccess.file_exists("user://Saves/RankSaves/timer_rank_data_level1.json"):
		var level_1_ranks: Array = [7.942,10.733,20.251,35.496,42.816,55.654]
		var level_1_file = FileAccess.open("user://Saves/RankSaves/timer_rank_data_level1.json", FileAccess.WRITE)
		level_1_file.store_line(JSON.stringify(level_1_ranks))
	
	if !FileAccess.file_exists("user://Saves/RankSaves/timer_rank_data_level2.json"):
		var level_2_ranks: Array = [17.315,22.312,32.567,45.177,63.008,74.145]
		var level_2_file = FileAccess.open("user://Saves/RankSaves/timer_rank_data_level2.json", FileAccess.WRITE)
		level_2_file.store_line(JSON.stringify(level_2_ranks))
	
	if !FileAccess.file_exists("user://Saves/RankSaves/timer_rank_data_level3.json"):
		var level_3_ranks: Array = [28.871,35.788,45.653,52.236,63.458,71.826]
		var level_3_file = FileAccess.open("user://Saves/RankSaves/timer_rank_data_level3.json", FileAccess.WRITE)
		level_3_file.store_line(JSON.stringify(level_3_ranks))
	
	if !FileAccess.file_exists("user://RankSaves/timer_rank_data_level4.json"):
		var level_4_ranks: Array = [17.568,24.420,31.653,39.236,48.458,57.826]
		var level_4_file = FileAccess.open("user://Saves/RankSaves/timer_rank_data_level4.json", FileAccess.WRITE)
		level_4_file.store_line(JSON.stringify(level_4_ranks))
	
	if !FileAccess.file_exists("user://Saves/RankSaves/timer_rank_data_level5.json"):
		var level_5_ranks: Array = [44.481,55.780,67.113,76.936,85.768,96.426]
		var level_5_file = FileAccess.open("user://Saves/RankSaves/timer_rank_data_level5.json", FileAccess.WRITE)
		level_5_file.store_line(JSON.stringify(level_5_ranks))
	
	if !FileAccess.file_exists("user://Saves/RankSaves/timer_rank_data_level6.json"):
		var level_6_ranks: Array = [44.616,52.781,59.583,62.113,74.806,85.936]
		var level_6_file = FileAccess.open("user://Saves/RankSaves/timer_rank_data_level6.json", FileAccess.WRITE)
		level_6_file.store_line(JSON.stringify(level_6_ranks))
	
	if !FileAccess.file_exists("user://Saves/RankSaves/timer_rank_data_level7.json"):
		var level_7_ranks: Array = [99.483,120.106,132.654,140.356,155.766,175.682]
		var level_7_file = FileAccess.open("user://Saves/RankSaves/timer_rank_data_level7.json", FileAccess.WRITE)
		level_7_file.store_line(JSON.stringify(level_7_ranks))
